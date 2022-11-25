terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "~> 4.31.0"
    }
  }
  required_version = ">= 0.13.5"
}

provider "google" {
  project = var.projectID
}

resource "random_id" "stack_id" {
  for_each = local.storage_stacks
  keepers = {
    # Generate a new suffix each time we switch to a new deployment
    stack_id = each.key
  }

  byte_length = 2
}

locals {
  packageURL = var.packageURL
  custom_role_prefix = var.customRolePrefix == "" ? var.customRolePrefix : "${var.customRolePrefix}_"
  management_service_accounts = [
    for v in data.google_service_account.management_service_account: "serviceAccount:${v.email}"
  ]
  storage_stacks = {
    for deployment_name, v in var.storageStacks : deployment_name => {
      scanner = v.scanner == null ? null : v.scanner
      scannerProjectID     = v.scannerProjectID == null ? null : v.scannerProjectID
      scannerServiceAccountID     = v.scannerServiceAccountID == null ? null : v.scannerServiceAccountID
      scannerTopic     = v.scannerTopic == null ? null : v.scannerTopic
      scanningBucketName     = v.scanningBucketName
      region = v.region
      managementServiceAccountProjectID = v.managementServiceAccountProjectID
      managementServiceAccountID = v.managementServiceAccountID
      reportObjectKey = v.reportObjectKey ? "True" : "False"
      disableScanningBucketIAMBinding = v.disableScanningBucketIAMBinding
      prefix = substr(trimsuffix(deployment_name, "-storage"), 0, 17)
    }
  }
}

data "google_project" "project" {}
