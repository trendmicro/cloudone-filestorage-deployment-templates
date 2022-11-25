variable "scannerStacks" {
  type = map(object({
    region = string
    managementServiceAccountProjectID = string
    managementServiceAccountID = string
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
