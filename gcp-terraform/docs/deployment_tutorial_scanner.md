# Cloud One File Storage Security

## Deploy scanner stack

## Overview

<walkthrough-tutorial-duration duration="5"></walkthrough-tutorial-duration>

This tutorial will guide you to deploy the Trend Micro Cloud One File Storage Security scanner stack.

--------------------------------

### Permissions

The permissions that File Storage Security management roles will have after it has been deployed and configured are defined in:

* <walkthrough-editor-open-file filePath="modules/management-roles/main.tf">Management roles</walkthrough-editor-open-file>

### Backend updates

For automatic backend updates that will be pushed, see [Update GCP components](https://cloudone.trendmicro.com/docs/file-storage-security/component-update-gcp/).

<walkthrough-footnote>After the scanner stack deployment is complete, you will need to add a storage stack to your bucket to start scanning.</walkthrough-footnote>

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

* Specify the GCP project ID in <walkthrough-editor-open-file filePath="gcp-configuration/terraform.tfvars.json">terraform.tfvars.json</walkthrough-editor-open-file> under `gcp-configuration` folder

* Apply the Terraform template in the Cloud Shell:

```sh
terraform -chdir=gcp-configuration init && \
  terraform -chdir=gcp-configuration apply
```

--------------------------------

For more information, see [Permissions for deployment](https://cloudone.trendmicro.com/docs/file-storage-security/gs-before-gcp/).

## Configure and deploy the stack

Specify the following fields in <walkthrough-editor-open-file filePath="scanners/terraform.tfvars.json">terraform.tfvars.json</walkthrough-editor-open-file> under `scanners` folder and apply the Terraform template in the Cloud Shell:

1. **projectID** Specify the project for this deployment.
2. **functionAutoUpdate:** Enable or disable automatic remote code update. The default value is `True`. Allow values: `True`, `False`.

The stack in `scannerStacks` could be multiples. You can have 20 scanner stacks in a single Terraform deployment.

Scanner stack:

1. **scannerStackName**: Specify the name of the scanner stack.
2. **region**: Specify the region for the scanner stack. For the list of supported GCP regions, please see [Supported GCP Regions](https://cloudone.trendmicro.com/docs/file-storage-security/supported-gcp/).
3. **managementServiceAccountProjectID**: Copy and paste the service account information from the File Storage Security console.
4. **managementServiceAccountID**: Copy and paste the service account information from the File Storage Security console.

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
  }
}
```

### Apply the deployment

```sh
terraform -chdir=scanners init  && \
  terraform -chdir=scanners apply
```

> Please save `terraform.tfstate` and `terraform.tfvars.json` for managing the deployment (You will need them for updating and deleting stack). We recommend you use [remote configuration](https://developer.hashicorp.com/terraform/language/settings/backends/configuration) to keep your tfstate somewhere safe.

## Configure JSON in File Storage Security console

To complete the deployment process, once the stacks are deployed, follow the steps to configure management role:

1. Copy the JSON content of `scanner_stacks_outputs` from the Cloud Shell output of Terraform.
2. Paste the content back to the File Storage Security console.

> **Tip**:
> You can get Terraform output by the command.
> ```sh
> terraform output
> ```

--------------------------------

## Protect an existing bucket

You have now deployed File Storage Security scanner stack successfully.

To start scanning, you’ll need to add a storage stack to the scanner stack you’ve just deployed. To add a storage stack:

1. Go to the Cloud One File Storage Security console Stack Management page.
1. Select the scanner stack you deployed.
1. Click on “Add Storage” and follow the steps to complete the deployment.
