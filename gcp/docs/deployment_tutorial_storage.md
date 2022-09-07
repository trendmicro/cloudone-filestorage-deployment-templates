# Cloud One File Storage Security

# Deploy storage stack

## Overview

<walkthrough-tutorial-duration duration="5"></walkthrough-tutorial-duration>

This tutorial will guide you to deploy the Cloud One File Storage Security storage stack.

--------------------------------

### Permissions

The permissions that File Storage Security management roles will have after it has been deployed and configured are defined in:

* <walkthrough-editor-open-file filePath="management_roles.py">Management roles</walkthrough-editor-open-file>
* <walkthrough-editor-open-file filePath="storage/storage_stack_roles.py">Storage stack management roles</walkthrough-editor-open-file>

### Backend updates

For automatic backend updates that will be pushed, see [Update components](https://cloudone.trendmicro.com/docs/file-storage-security/component-update-gcp/).

## Project setup

1. Select the project from the drop-down list.
1. Copy and execute the script below in the Cloud Shell to complete the project setup.

<walkthrough-project-setup></walkthrough-project-setup>

```sh
gcloud config set project <walkthrough-project-id/>
```

## Enable permissions for deployment

You need the following permissions before deployment:

### Step 1: Enable the following APIs:

* Cloud Build API
* Cloud Deployment Manager V2 API
* Cloud Functions API
* Cloud Pub/Sub API
* Cloud Resource Manager API
* Cloud Scheduler API
* IAM Service Account Credentials API
* Identity and Access Management API
* Secret Manager API

List the APIs that are enabled:

```sh
gcloud service list --enabled
```

Enable all the needed APIs at once:

```sh
gcloud services enable cloudbuild.googleapis.com deploymentmanager.googleapis.com cloudfunctions.googleapis.com pubsub.googleapis.com cloudresourcemanager.googleapis.com cloudscheduler.googleapis.com iamcredentials.googleapis.com iam.googleapis.com secretmanager.googleapis.com
```

--------------------------------

### Step 2: Create a custom role containing the permissions below:

* cloudfunctions.functions.setIamPolicy
* iam.roles.create
* iam.serviceAccounts.setIamPolicy
* pubsub.topics.setIamPolicy
* resourcemanager.projects.setIamPolicy

Naming rules:

1. **ROLE_ID length**: 3~64. ID can only include letters, numbers, periods and underscores.
1. **ROLE_TITLE length**: 1~100.

```sh
gcloud iam roles create <ROLE_ID> --project=<walkthrough-project-id/> \
    --title=<ROLE_TITLE> --description="Custom role for deployment" \
    --permissions="cloudfunctions.functions.setIamPolicy,iam.roles.create,iam.serviceAccounts.setIamPolicy,pubsub.topics.setIamPolicy,resourcemanager.projects.setIamPolicy" --stage=GA
```

--------------------------------

### Step 3: Bind the custom role to the service account:

Bind the custom role to <GCP_PROJECT_NUMBER>@cloudservices.gserviceaccount.com. This service account is created by GCP, and its name is Google APIs Service Agent.

1. Get project number:

```sh
gcloud projects list --filter=<walkthrough-project-id/> --format="value(PROJECT_NUMBER)"
```

2. Bind service account:

```sh
gcloud projects add-iam-policy-binding <walkthrough-project-id/> \
    --member=serviceAccount:<PROJECT_NUMBER>@cloudservices.gserviceaccount.com
    --role=<ROLE_ID>
```

--------------------------------

For more information, see [Permissions for deployment](https://cloudone.trendmicro.com/docs/file-storage-security/gs-before-gcp/).

## Configure and deploy the stack

Specify the following fields and execute the deployment script in the Cloud Shell:

1. **Scanning bucket name:** Specify the existing bucket name that you wish to protect.
1. **Deployment name:** Specify the name of this deployment. Please keep it under 22 characters.
1. **Region:** Specify the region of your bucket. For the list of supported GCP regions, please see [Supported GCP Regions](https://cloudone.trendmicro.com/docs/file-storage-security/supported-gcp/#GCPRegion).
1. **Scanner information JSON:** Copy and paste the scanner information from the File Storage Security console.
1. **Service account:** Copy and paste the service account information from the File Storage Security console.
1. **Function auto update:** Enable or disable automatic remote code update. The default value is `True`. Allow values: `True`, `False`.

```sh
./deployment-script-storage.sh -s <SCANNING_BUCKET_NAME> -d <DEPLOYMENT_NAME> -r <REGION> -i <SCANNER_INFORMATION> -m <SERVICE_ACCOUNT> -f <FUNCTION_AUTO_UPDATE>
```

## Configure JSON in File Storage Security console

To complete the deployment process, once the stacks are deployed, follow the steps to configure management role:

1. Copy the content of <DEPLOYMENT_NAME>.json from the Cloud Shell script output.
1. Paste the content back to the File Storage Security console - Step 5. Storage Stack

--------------------------------

### Deployment Status

To find out the status of your deployment, go to [Deployment Manager](https://console.cloud.google.com/dm) and search for:

* <DEPLOYMENT_NAME>

## Start scanning

You have now deployed File Storage Security scanner and storage stacks successfully. To test your deployment, you'll need to generate a malware detection using the eicar file.

1. Download the eicar file from eicar file page into your scanning bucket with the script.

    ```sh
    wget https://secure.eicar.org/eicar.com.txt
    gsutil cp eicar.com.txt gs://<SCANNING_BUCKET_NAME>/eicar
    ```

1. File Storage Security scans the file and detects the malware.

1. Execute the script to examine the scan result:

    ```sh
    gsutil stat 'gs://<SCANNING_BUCKET_NAME>/eicar'
    ```

1. In Metadata, look for the following tags:
    * **fss-scan-date**: date_and_time
    * **fss-scan-result**: malicious
    * **fss-scanned**: true

The tags indicate that File Storage Security scanned the file and tagged it correctly as malware. The scan results are also available in the console on the Scan Activity page.

--------------------------------

### Next Step

[Quarantine or promote files based on the scan results](https://cloudone.trendmicro.com/docs/file-storage-security/github-sample-code/#post-scan)
