terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "~> 5.38.0"
    }
  }

  required_version = ">= 1.2.0"
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
