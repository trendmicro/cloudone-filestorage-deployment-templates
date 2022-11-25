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

module "google_api"{
  source = "../modules/google-api"
  projectID = var.projectID
  customRolePrefix = var.customRolePrefix
}

module "management_roles"{
  source = "../modules/management-roles"
  projectID = var.projectID
  customRolePrefix = var.customRolePrefix
}
