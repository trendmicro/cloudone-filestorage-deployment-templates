variable "projectID" {
  type = string
  description = "The GCP project ID you want to apply the deployment to."
  default = ""
}

variable "customRolePrefix" {
  type = string
  default = ""
}

variable "managementServiceAccounts" {
  description = "The list of management service accounts"
  type        = list(string)
  default     = []
}

variable "functionAutoUpdate" {
  type = bool
  description = "Enable or disable automatic remote code update."
  default = true
}
