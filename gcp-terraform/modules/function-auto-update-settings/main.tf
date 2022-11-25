locals {
  custom_role_prefix = var.customRolePrefix == "" ? var.customRolePrefix : "${var.customRolePrefix}_"
}

resource "time_static" "function_update_iam_binding_time" {}

resource "google_project_iam_binding" "function_update_iam_binding" {
  count = var.functionAutoUpdate ? 1 : 0
  project = var.projectID
  role    = "projects/${var.projectID}/roles/${local.custom_role_prefix}trend_micro_fss_source_code_set_role"

  members = var.managementServiceAccounts

  condition {
    title  = "FSS Stack Function Update Binding ${time_static.function_update_iam_binding_time.rfc3339}" // Preventing the binding is removed by the other TF deployments in the same project
    expression  = ""
  }
}

resource "google_service_account_iam_binding" "appspot_service_account_iam_binding" {
  count = var.functionAutoUpdate ? 1 : 0
  service_account_id = "projects/${var.projectID}/serviceAccounts/${var.projectID}@appspot.gserviceaccount.com"
  role               = "roles/iam.serviceAccountUser"

  members = var.managementServiceAccounts

  condition {
    title  = "FSS Stack Function Update Binding ${time_static.function_update_iam_binding_time.rfc3339}" // Preventing the binding is removed by the other TF deployments in the same project
    expression  = ""
  }
}
