# Cloud One File Storage Security

# Deploy scanner stack

## Overview

<walkthrough-tutorial-duration duration="5"></walkthrough-tutorial-duration>

This tutorial will guide you to deploy the Cloud One File Storage Security scanner stack.

--------------------------------

### Permissions

The permissions that File Storage Security management roles will have after it has been deployed and configured are defined in:

* <walkthrough-editor-open-file filePath="management_roles.py">Management roles</walkthrough-editor-open-file>

### Backend updates (coming soon)

For automatic backend updates that will be pushed, see [Update components](https://cloudone.trendmicro.com/docs/file-storage-security/component-update-gcp/).

<walkthrough-footnote>After the scanner stack deployment is complete, you will need to add a storage stack to your bucket to start scanning.</walkthrough-footnote>

## Project setup

Select the project in which you want to deploy the scanner stack, then copy and execute the script in the Cloud Shell:

<walkthrough-project-setup></walkthrough-project-setup>

```sh
gcloud config set project <walkthrough-project-id/>
```

## Configure and deploy the stack

Specify the following fields and execute the deployment script in the Cloud Shell:

1. **Deployment name:** Specify the name of this deployment. Please keep it under 22 characters.
1. **Region:** Specify the region of your bucket. For the list of supported GCP regions, please see [Supported GCP Regions](https://cloudone.trendmicro.com/docs/file-storage-security/supported-gcp/#GCPRegion).
1. **Cloud One region:** Specify the region ID of your Trend Micro Cloud One account. For the list of supported Cloud One regions, see [supported Cloud One regions](https://cloudone.trendmicro.com/docs/identity-and-account-management/c1-regions/). The default region is `us-1`.
1. **Service account:** Copy and paste the service account information from the File Storage Security console.

```sh
./deployment-script-scanner.sh -d <DEPLOYMENT_NAME> -r <REGION> -c <CLOUD_ONE_REGION> -m <SERVICE_ACCOUNT>
```

## Configure JSON in File Storage Security console

To complete the deployment process, once the stacks are deployed, follow the steps to configure management role:

1. Copy the content of <DEPLOYMENT_NAME>.json from the Cloud Shell script output.
1. Paste the content back to the File Storage Security console - Step 4. Scanner Stack

--------------------------------

### Deployment Status

To find out the status of your deployment, go to [Deployment Manager](https://console.cloud.google.com/dm) and search for:

* <DEPLOYMENT_NAME>

## Protect an existing bucket

You have now deployed File Storage Security scanner stack successfully.

To start scanning, you’ll need to add a storage stack to the scanner stack you’ve just deployed. To add a storage stack:

1. Go to the Cloud One File Storage Security console Stack Management page.
1. Select the scanner stack you deployed.
1. Click on “Add Storage” and follow the steps to complete the deployment.
