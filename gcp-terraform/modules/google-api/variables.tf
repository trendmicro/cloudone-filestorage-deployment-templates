variable "projectID" {
  type = string
}

variable "customRolePrefix" {
  type = string
  default = ""
}

variable "gcpServicesList" {
  description = "Google APIs need to be enabled"
  type        = set(string)
  default     = [
    "cloudbuild.googleapis.com",
    "deploymentmanager.googleapis.com",
    "cloudfunctions.googleapis.com",
    "pubsub.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudscheduler.googleapis.com",
    "iamcredentials.googleapis.com",
    "iam.googleapis.com",
    "secretmanager.googleapis.com"
  ]
}
