#!/bin/bash
set -e

while getopts s:d:r:u:k:m:c:a: args
do
  case "${args}" in
    s) SCANNING_BUCKET_NAME=${OPTARG};;
    d) DEPLOYMENT_NAME_PREFIX=${OPTARG};;
    r) REGION=${OPTARG};;
    u) PACKAGE_URL=${OPTARG};;
    k) REPORT_OBJECT_KEY=${OPTARG};;
    m) MANAGEMENT_SERVICE_ACCOUNT=${OPTARG};;
    c) CLOUD_ONE_REGION=${OPTARG};;
    a) CLOUD_ONE_ACCOUNT=${OPTARG};;
  esac
done

DEPLOYMENT_NAME_SCANNER=$DEPLOYMENT_NAME_PREFIX'-scanner'
DEPLOYMENT_NAME_STORAGE=$DEPLOYMENT_NAME_PREFIX'-storage'

if [ -z "$PACKAGE_URL" ]; then
  PACKAGE_URL='https://file-storage-security.s3.amazonaws.com/latest/'
fi

if [ -z "$REPORT_OBJECT_KEY" ]; then
  REPORT_OBJECT_KEY='False'
else
  REPORT_OBJECT_KEY=$(echo $REPORT_OBJECT_KEY | tr '[:upper:]' '[:lower:]')
  REPORT_OBJECT_KEY=$(echo ${REPORT_OBJECT_KEY:0:1} | tr '[a-z]' '[A-Z]')${REPORT_OBJECT_KEY:1}
fi

if [ -z "$CLOUD_ONE_REGION" ]; then
  CLOUD_ONE_REGION='us-1'
fi

if [ -z "$CLOUD_ONE_ACCOUNT" ]; then
  CLOUD_ONE_ACCOUNT=''
fi

bash deployment-script-scanner.sh -d $DEPLOYMENT_NAME_SCANNER -r $REGION -m $MANAGEMENT_SERVICE_ACCOUNT -u $PACKAGE_URL -c $CLOUD_ONE_REGION -a $CLOUD_ONE_ACCOUNT
bash deployment-script-storage.sh -s $SCANNING_BUCKET_NAME -d $DEPLOYMENT_NAME_STORAGE -r $REGION -m $MANAGEMENT_SERVICE_ACCOUNT -i "$(cat $DEPLOYMENT_NAME_SCANNER-info.json)" -u $PACKAGE_URL -k $REPORT_OBJECT_KEY

echo "The stacks have been deployed successfully. Below is the content required to configure on File Storage Security console."

echo "--- Content of $DEPLOYMENT_NAME_SCANNER.json ---"
cat $DEPLOYMENT_NAME_SCANNER.json
echo "--- End of the content ---"
echo ""
echo "--- Content of $DEPLOYMENT_NAME_STORAGE.json ---"
cat $DEPLOYMENT_NAME_STORAGE.json
echo "--- End of the content ---"
