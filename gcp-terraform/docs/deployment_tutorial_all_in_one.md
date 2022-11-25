# Cloud One File Storage Security

## Deploy scanner and storage stacks

## Overview

<walkthrough-tutorial-duration duration="10"></walkthrough-tutorial-duration>

This tutorial will guide you to protect an existing GCS (Google Cloud Storage) from malware by deploying Trend Micro Cloud One File Storage Security scanner and storage stacks.

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

### Step 1: Apply the GCP configuration deployment:

Enable all the needed APIs and create required custom roles by Terraform.

* Specify the GCP project ID in <walkthrough-editor-open-file filePath="gcp-configuration/terraform.tfvars.json">terraform.tfvars.json</walkthrough-editor-open-file> under `gcp-configuration` folder.

* Apply the Terraform template in the Cloud Shell:

```sh
terraform -chdir=gcp-configuration init && \
  terraform -chdir=gcp-configuration apply
```

--------------------------------

For more information, see [Permissions for deployment](https://cloudone.trendmicro.com/docs/file-storage-security/gs-before-gcp/).

## Configure and deploy the stacks

Specify the following fields in <walkthrough-editor-open-file filePath="all-in-one/terraform.tfvars.json">terraform.tfvars.json</walkthrough-editor-open-file> under `all-in-one` folder and apply the Terraform template in the Cloud Shell:

1. **projectID**: Specify the project for this deployment.
2. **functionAutoUpdate**: Enable or disable automatic remote code update. The default value is `true`. Allow values: `true`, `false`.

The stack in JSON object `scannerStacks` and `storageStacks` could be multiples. You can have 5 scanner stacks with 20 storage stacks in a single Terraform deployment.

Scanner stack:

1. **scannerStackName**: Specify the name of the scanner stack.
2. **region**: Specify the region for the scanner stack. For the list of supported GCP regions, please see [Supported GCP Regions](https://cloudone.trendmicro.com/docs/file-storage-security/supported-gcp/).
3. **managementServiceAccountProjectID**: Copy and paste the service account information from the File Storage Security console.
4. **managementServiceAccountID**: Copy and paste the service account information from the File Storage Security console.

Storage stack:

1. **storageStackName**: Specify the name of the storage stack.
2. **scannerStackName**: Specify the name of the scanner stack.
3. **scanningBucketName**: Specify the existing bucket name that you wish to protect.
4. **region**: Specify the region of your bucket. For the list of supported GCP regions, please see [Supported GCP Regions](https://cloudone.trendmicro.com/docs/file-storage-security/supported-gcp/).
5. **managementServiceAccountProjectID**: Copy and paste the service account information from the File Storage Security console.
6. **managementServiceAccountID**: Copy and paste the service account information from the File Storage Security console.
7. **reportObjectKey**: Select `true` to report the object keys of the scanned objects to File Storage Security backend services. File Storage Security can then display the object keys of the malicious objects in the response of events API. Allows values `true`, `false`.

> **Tips**:
`scannerProjectID`, `scannerTopic`, `scannerServiceAccountID` should be `null` in All-in-One deployment. `disableScanningBucketIAMBinding` is required by converting from the GCP Deployment Manager's deployment, if it's a new deployment should be `false`.

```sh
{
  "projectID": "<GCP_PROJECT_ID>",
  "functionAutoUpdate": true,
  "scannerStacks": {
    "<SCANNER_STACK_NAME>": {
      "region": "<GCP_REGION>",
      "managementServiceAccountProjectID": "<MANAGEMENT_SERVICE_ACCOUNT_GCP_PROJECT_ID>",
      "managementServiceAccountID": "<MANAGEMENT_SERVICE_ACCOUNT_ID>"
    }
  },
  "storageStacks": {
    "<STORAGE_STACK_NAME>": {
      "scanner": "<SCANNER_STACK_NAME>",
      "scanningBucketName": "<SCANNING_BUCKET_NAME>",
      "region": "<GCP_REGION>",
      "managementServiceAccountProjectID": "<MANAGEMENT_SERVICE_ACCOUNT_GCP_PROJECT_ID>",
      "managementServiceAccountID": "<MANAGEMENT_SERVICE_ACCOUNT_ID>",
      "scannerProjectID": null,
      "scannerTopic": null,
      "scannerServiceAccountID": null,
      "reportObjectKey": false,
      "disableScanningBucketIAMBinding": false
    }
  }
}
```

### Initialize and apply the deployment

```sh
terraform -chdir=all-in-one init  && \
  terraform -chdir=all-in-one apply
```

> Please save `terraform.tfstate` and `terraform.tfvars.json` for managing the deployment (You will need them for updating and deleting stack). We recommend you use [remote configuration](https://developer.hashicorp.com/terraform/language/settings/backends/configuration) to keep your tfstate somewhere safe.

## Configure JSON in File Storage Security console

To complete the deployment process, once the stacks are deployed, follow the steps to configure management role:

1. Copy the JSON content of `all_in_one_outputs` from the Cloud Shell output of Terraform.
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

The labels indicate that File Storage Security scanned the file and labeled it correctly as malware. The scan results are also available in the File Storage Security web console on the Scan Activity page.

--------------------------------

### Next Step

[Quarantine or promote files based on the scan results](https://cloudone.trendmicro.com/docs/file-storage-security/github-sample-code/#post-scan)
