# Cloud One File Storage Security

## Deploy storage stack

## Overview

<walkthrough-tutorial-duration duration="5"></walkthrough-tutorial-duration>

This tutorial will guide you to deploy the Trend Micro Cloud One File Storage Security storage stack.

--------------------------------

### Permissions

The permissions that File Storage Security management roles will have after it has been deployed and configured are defined in:

* <walkthrough-editor-open-file filePath="modules/management-roles/main.tf">Management roles</walkthrough-editor-open-file>

### Backend updates

For automatic backend updates that will be pushed, see [Update GCP components](https://cloudone.trendmicro.com/docs/file-storage-security/component-update-gcp/).

## Project setup

1. Select the project from the drop-down list at the top of the GCP console.
2. Copy and execute the script below in the Cloud Shell to complete the project setup.

<walkthrough-project-setup></walkthrough-project-setup>

```sh
gcloud config set project <walkthrough-project-id/>
```

## Enable permissions for deployment

You need to apply the settings and create the custom roles in the project before File Storage Security stack deployment. This only needs to be done once on a GCP project for File Storage Security stack deployment:

### Step 1: Apply the GCP configuration deployment

Enable all the needed APIs and create required custom roles by Terraform.

* Specify the GCP project ID in <walkthrough-editor-open-file filePath="gcp-configuration/terraform.tfvars.json">terraform.tfvars.json</walkthrough-editor-open-file> under `gcp-configuration` folder.

* Apply the Terraform template in the Cloud Shell:

```sh
terraform -chdir=gcp-configuration init && \
  terraform -chdir=gcp-configuration apply
```

--------------------------------

For more information, see [Permissions for deployment](https://cloudone.trendmicro.com/docs/file-storage-security/gs-before-gcp/).

## Configure and deploy the stack

Specify the following fields in <walkthrough-editor-open-file filePath="storages/terraform.tfvars.json">terraform.tfvars.json</walkthrough-editor-open-file> under `storages` folder and apply the Terraform template in the Cloud Shell:

1. **projectID** Specify the project for this deployment.
2. **functionAutoUpdate:** Enable or disable automatic remote code update. The default value is `true`. Allow values: `true`, `false`.

The stack in JSON object `storageStacks` could be multiples. You can have 20 storage stacks in a single Terraform deployment.

Storage stack:
1. **storageStackName**: Specify the name of the storage stack.
2. **scannerStackName**: Specify the existing bucket name that you wish to protect.
3. **region**: Specify the region of your bucket. For the list of supported GCP regions, please see [Supported GCP Regions](https://cloudone.trendmicro.com/docs/file-storage-security/supported-gcp/).
4. **managementServiceAccountProjectID**: Copy and paste the service account information from the File Storage Security console.
5. **managementServiceAccountID**: Copy and paste the service account information from the File Storage Security console.
6. **scannerProjectID**: Copy and paste the service account information from the File Storage Security console.
7. **scannerServiceAccountID**: Copy and paste the service account information from the File Storage Security console.
8. **scannerTopic**: Copy and paste the service account information from the File Storage Security console.
9. **reportObjectKey**: Select `true` to report the object keys of the scanned objects to File Storage Security backend services. File Storage Security can then display the object keys of the malicious objects in the response of events API. Allows values `true`, `true`.

> **Tips**:
 `scanner` is only required in all-in-one deployment, so the default value should be `null`. `disableScanningBucketIAMBinding` is required by converting from the GCP Deployment Manager's deployment, if it's a new deployment should be `false`.

```sh
{
  "projectID": "<GCP_PROJECT_ID>",
  "functionAutoUpdate": true,
  "storageStacks": {
    "<STORAGE_STACK_NAME>": {
      "scanningBucketName": "<SCANNING_BUCKET_NAME>",
      "region": "<GCP_REGION>",
      "managementServiceAccountProjectID": "<MANAGEMENT_SERVICE_ACCOUNT_GCP_PROJECT_ID>",
      "managementServiceAccountID": "<MANAGEMENT_SERVICE_ACCOUNT_ID>",
      "scannerProjectID": "<SCANNER_STACK_PROJECT_ID>",
      "scannerTopic": "<SCANNER_STACK_PUBSUB_TOPIC_NAME>",
      "scannerServiceAccountID": "<SCANNER_STACK_SERVICE_ACCOUNT_ID>",
      "reportObjectKey": false,
      "disableScanningBucketIAMBinding": false,
      "scanner": null
    }
  }
}
```

### Apply the deployment

```sh
terraform -chdir=storages init  && \
  terraform -chdir=storages apply
```

> Please save `terraform.tfstate` and `terraform.tfvars.json` for managing the deployment (You will need them for updating and deleting stack). We recommend you use [remote configuration](https://developer.hashicorp.com/terraform/language/settings/backends/configuration) to keep your tfstate somewhere safe.

## Configure JSON in File Storage Security console

To complete the deployment process, once the stacks are deployed, follow the steps to configure management role:

1. Copy the JSON content of `storage_stacks_outputs` from the Cloud Shell output of Terraform.
2. Paste the content back to the File Storage Security console.

> **Tip**:
> You can get Terraform output by the command.
> ```sh
> terraform output
> ```

--------------------------------

## Start scanning

You have now deployed File Storage Security scanner and storage stacks successfully. To test your deployment, you'll need to generate a malware detection using the eicar file.

1. Download the eicar file from eicar file page into your scanning bucket with the script.

    ```sh
    wget https://secure.eicar.org/eicar.com.txt
    gsutil cp eicar.com.txt gs://<SCANNING_BUCKET_NAME>/eicar
    ```

2. Execute the script to examine the scan result:

    ```sh
    gsutil stat 'gs://<SCANNING_BUCKET_NAME>/eicar'
    ```

3. In Metadata, look for the following tags:
    * **fss-scan-date**: date_and_time
    * **fss-scan-result**: malicious
    * **fss-scanned**: true

The tags indicate that File Storage Security scanned the file and tagged it correctly as malware. The scan results are also available in the console on the Scan Activity page.

--------------------------------

### Next Step

[Quarantine or promote files based on the scan results](https://cloudone.trendmicro.com/docs/file-storage-security/github-sample-code/#post-scan)
