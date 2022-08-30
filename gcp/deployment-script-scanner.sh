#!/bin/bash
set -e

while getopts d:r:u:m:c:a:f: args
do
  case "${args}" in
    d) DEPLOYMENT_NAME_SCANNER=${OPTARG};;
    r) REGION=${OPTARG};;
    u) PACKAGE_URL=${OPTARG};;
    m) MANAGEMENT_SERVICE_ACCOUNT=${OPTARG};;
    c) CLOUD_ONE_REGION=${OPTARG};;
    a) CLOUD_ONE_ACCOUNT=${OPTARG};;
    f) FUNCTION_AUTO_UPDATE=${OPTARG};;
  esac
done

GCP_PROJECT_ID=$(gcloud config list --format 'value(core.project)' 2> /dev/null)
ARTIFACT_BUCKET_NAME='fss-artifact'-$(cat /proc/sys/kernel/random/uuid || uuidgen | tr '[:upper:]' '[:lower:]')

echo "Artifact bucket name: $ARTIFACT_BUCKET_NAME";
echo "Scanner Deployment Name: $DEPLOYMENT_NAME_SCANNER";
echo "GCP Project ID: $GCP_PROJECT_ID";
echo "Region: $REGION";
echo "Package URL: $PACKAGE_URL";
echo "Management Service Account: $MANAGEMENT_SERVICE_ACCOUNT";
echo "Cloud One Region: $CLOUD_ONE_REGION";
echo "Cloud One Account: $CLOUD_ONE_ACCOUNT";
echo "Function Auto Update: $FUNCTION_AUTO_UPDATE";
echo "Will deploy file storage security protection unit scanner stack, Ctrl-C to cancel..."
sleep 5

if [ -z "$PACKAGE_URL" ]; then
  PACKAGE_URL='https://file-storage-security.s3.amazonaws.com/latest/'
fi

if [ -z "$CLOUD_ONE_REGION" ]; then
  CLOUD_ONE_REGION='us-1'
fi

if [ -z "$CLOUD_ONE_ACCOUNT" ]; then
  CLOUD_ONE_ACCOUNT=''
fi

if [ -z "$FUNCTION_AUTO_UPDATE" ]; then
  FUNCTION_AUTO_UPDATE='True'
fi

TEMPLATES_FILE='gcp-templates.zip'
SCANNER_FILE='gcp-scanner.zip'
SCANNER_DLT_FILE='gcp-scanner-dlt.zip'
SCANNER_PATTERN_UPDATER_FILE='gcp-scanner-pattern-updater.zip'

# Check Project Setting
gcloud deployment-manager deployments list > /dev/null

# Download the templates package
wget $PACKAGE_URL'gcp-templates/'$TEMPLATES_FILE

# Unzip the templates package
unzip $TEMPLATES_FILE && rm $TEMPLATES_FILE

# Create an artifact Google Cloud Storage bucket
gsutil mb --pap enforced -b on gs://$ARTIFACT_BUCKET_NAME

prepareArtifact() {
  # Download FSS functions artifacts
  wget $PACKAGE_URL'cloud-functions/'$1
  # Upload functions artifacts to the artifact bucket
  gsutil cp $1 gs://$ARTIFACT_BUCKET_NAME/$1 && rm $1
}

prepareArtifact $SCANNER_FILE
prepareArtifact $SCANNER_DLT_FILE
prepareArtifact $SCANNER_PATTERN_UPDATER_FILE

# Deploy or update File Storage Security roles
echo "Deploying File Storage Security roles..."
FSS_ROLES_DEPLOYMENT='trend-micro-file-storage-security-roles'
# Deploy the roles if they don't exist
roleDeployment=$(gcloud deployment-manager deployments describe $FSS_ROLES_DEPLOYMENT --format json) \
  || gcloud deployment-manager deployments create $FSS_ROLES_DEPLOYMENT --config templates/fss-roles.yaml
# Update the roles if they are not being updated
([[ ! -z "$roleDeployment" && "DONE" == $(echo "$roleDeployment" | jq -r '.deployment.operation.status') ]] \
  && gcloud deployment-manager deployments update $FSS_ROLES_DEPLOYMENT --config templates/fss-roles.yaml) \
  || echo "$FSS_ROLES_DEPLOYMENT is updating. Skip updating the roles."

SCANNER_YAML_PATH=templates/scanner/scanner.yaml
SCANNER_SA_YAML_PATH=templates/scanner/scanner-stack-service-accounts.yaml
sed -i.bak "s/<REGION>/$REGION/g" $SCANNER_YAML_PATH
sed -i.bak "s/<ARTIFACT_BUCKET_NAME>/$ARTIFACT_BUCKET_NAME/g" $SCANNER_YAML_PATH
sed -i.bak "s/<DEPLOYMENT_NAME>/$DEPLOYMENT_NAME_SCANNER/g" $SCANNER_YAML_PATH
sed -i.bak "s/<MANAGEMENT_SERVICE_ACCOUNT_ID>/$MANAGEMENT_SERVICE_ACCOUNT/g" $SCANNER_YAML_PATH
sed -i.bak "s/<MANAGEMENT_SERVICE_ACCOUNT_ID>/$MANAGEMENT_SERVICE_ACCOUNT/g" $SCANNER_SA_YAML_PATH
sed -i.bak "s/<FUNCTION_AUTO_UPDATE>/$FUNCTION_AUTO_UPDATE/g" $SCANNER_YAML_PATH

cat $SCANNER_SA_YAML_PATH
cat $SCANNER_YAML_PATH

# Deploy scanner stack service account template
gcloud deployment-manager deployments create $DEPLOYMENT_NAME_SCANNER --config $SCANNER_SA_YAML_PATH

SCANNER_DEPLOYMENT=$(gcloud deployment-manager deployments describe $DEPLOYMENT_NAME_SCANNER --format "json")

searchScannerJSONOutputs() {
  echo $SCANNER_DEPLOYMENT | jq -r --arg v "$1" '.outputs[] | select(.name==$v).finalValue'
}

SCANNER_PROJECT_ID=$(searchScannerJSONOutputs scannerProjectID)
SCANNER_SERVICE_ACCOUNT_ID=$(searchScannerJSONOutputs scannerServiceAccountID)

SECRET_STRING=$( jq -n \
  --arg fssAPIEndpoint "https://filestorage.$CLOUD_ONE_REGION.cloudone.trendmicro.com/api/" \
  --arg cloudOneAccount "$CLOUD_ONE_ACCOUNT" \
  '{FSS_API_ENDPOINT: $fssAPIEndpoint, CLOUD_ONE_ACCOUNT: $cloudOneAccount}' )

# Create scanner secrets environment variable
echo -n "$SECRET_STRING" | \
  gcloud secrets create $DEPLOYMENT_NAME_SCANNER-scanner-secrets \
    --replication-policy=user-managed --locations=$REGION \
    --data-file=-

# Allow scanner service account to access the secrets
gcloud secrets add-iam-policy-binding $DEPLOYMENT_NAME_SCANNER-scanner-secrets \
  --member="serviceAccount:$SCANNER_SERVICE_ACCOUNT_ID@$SCANNER_PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/secretmanager.secretAccessor"
# Allow management service account to access the secrets
gcloud secrets add-iam-policy-binding $DEPLOYMENT_NAME_SCANNER-scanner-secrets \
  --member="serviceAccount:$MANAGEMENT_SERVICE_ACCOUNT" \
  --role="projects/$SCANNER_PROJECT_ID/roles/trend_micro_fss_secret_management_role"

sed -i.bak "s/<SCANNER_SECRETS>/$DEPLOYMENT_NAME_SCANNER-scanner-secrets/g" $SCANNER_YAML_PATH

# Update scanner template
gcloud deployment-manager deployments update $DEPLOYMENT_NAME_SCANNER --config $SCANNER_YAML_PATH

SCANNER_DEPLOYMENT=$(gcloud deployment-manager deployments describe $DEPLOYMENT_NAME_SCANNER --format "json")

SCANNER_TOPIC=$(searchScannerJSONOutputs scannerTopic)
SCANNER_TOPIC_DLT=$(searchScannerJSONOutputs scannerTopicDLT)

SCANNER_PROJECT_NUMBER=$(gcloud projects list --filter=$SCANNER_PROJECT_ID --format="value(PROJECT_NUMBER)")
PUBSUB_SERVICE_ACCOUNT="service-$SCANNER_PROJECT_NUMBER@gcp-sa-pubsub.iam.gserviceaccount.com"
SUBSCRIPTIONS=$(gcloud pubsub topics list-subscriptions $SCANNER_TOPIC)
SCANNER_SUBSCRIPTION_ID=${SUBSCRIPTIONS#*/*/*/}

# Update scanner topic dead letter config
gcloud pubsub subscriptions update $SCANNER_SUBSCRIPTION_ID \
  --dead-letter-topic=$SCANNER_TOPIC_DLT \
  --max-delivery-attempts=5

# Binding Pub/Sub service account
gcloud pubsub subscriptions add-iam-policy-binding $SCANNER_SUBSCRIPTION_ID \
  --member="serviceAccount:$PUBSUB_SERVICE_ACCOUNT"\
  --role="roles/pubsub.subscriber"

# Binding appspot service account
APPSPOT_SERVICE_ACCOUNT=$SCANNER_PROJECT_ID@appspot.gserviceaccount.com
bindingCount=$(gcloud iam service-accounts get-iam-policy $APPSPOT_SERVICE_ACCOUNT --flatten=bindings --filter="bindings.members=serviceAccount:$MANAGEMENT_SERVICE_ACCOUNT AND bindings.role=roles/iam.serviceAccountUser" --format='json' | jq length)
[[ 0 < $bindingCount ]] \
  || gcloud iam service-accounts add-iam-policy-binding $APPSPOT_SERVICE_ACCOUNT \
    --member="serviceAccount:$MANAGEMENT_SERVICE_ACCOUNT" --role=roles/iam.serviceAccountUser

# Remove the artifact bucket
gsutil rm -r gs://$ARTIFACT_BUCKET_NAME
rm -rf templates

printScannerJSON() {
  SCANNER_JSON=$(jq --null-input \
    --arg projectID "$SCANNER_PROJECT_ID" \
    --arg deploymentName "$DEPLOYMENT_NAME_SCANNER" \
    '{"projectID": $projectID, "deploymentName": $deploymentName}')
  echo $SCANNER_JSON > $DEPLOYMENT_NAME_SCANNER.json
  cat $DEPLOYMENT_NAME_SCANNER.json
}

printScannerInfo() {
  SCANNER_INFO=$(jq --null-input \
    --arg scannerTopic "$SCANNER_TOPIC" \
    --arg scannerProjectID "$SCANNER_PROJECT_ID" \
    --arg scannerSAID "$SCANNER_SERVICE_ACCOUNT_ID" \
    '{"SCANNER_TOPIC": $scannerTopic, "SCANNER_PROJECT_ID": $scannerProjectID, "SCANNER_SERVICE_ACCOUNT_ID": $scannerSAID}')
  echo $SCANNER_INFO > $DEPLOYMENT_NAME_SCANNER-info.json
  cat $DEPLOYMENT_NAME_SCANNER-info.json
}

echo "FSS Protection Unit Information:"
printScannerInfo

echo "The scanner stack has been deployed successfully. Below is the content required to configure on File Storage Security console."

echo "--- Content of $DEPLOYMENT_NAME_SCANNER.json ---"
printScannerJSON
echo "--- End of the content ---"
