variable "storageStacks" {
  type = map(object({
    scanner = string
    scannerProjectID = string
    scannerTopic = string
    scannerServiceAccountID = string
    scanningBucketName  = string
    region = string
    managementServiceAccountProjectID = string
    managementServiceAccountID = string
    reportObjectKey = string
    disableScanningBucketIAMBinding = bool
    objectFilterPrefix = string
  }))
}

variable "projectID" {
  type = string
  default = ""
}

variable "customRolePrefix" {
  type = string
  default = ""
}

variable "packageURL" {
  type = string
  default = "https://file-storage-security.s3.amazonaws.com/latest/cloud-functions/"
}

variable "functionAutoUpdate" {
  type = bool
  default = true
}

variable "scanner_service_accounts" {}
variable "scanner_pubsub_topics" {}
