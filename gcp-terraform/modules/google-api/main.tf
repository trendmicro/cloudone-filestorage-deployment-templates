data "google_project" "project" {}

locals {
  custom_role_prefix = var.customRolePrefix == "" ? var.customRolePrefix : "${var.customRolePrefix}_"
  custom_role_title_prefix = var.customRolePrefix == "" ? var.customRolePrefix : "${replace(var.customRolePrefix, "_", "-")}-"
}

resource "google_project_service" "gcp_services" {
  project  = var.projectID
  for_each = var.gcpServicesList
  service = each.value

  disable_on_destroy = false
}

resource "google_project_iam_custom_role" "trend_micro_fss_cloudservices_api_role" {
  project  = var.projectID

  role_id = "${local.custom_role_prefix}trend_micro_fss_cloudservices_api_role"
  description = "Trend Micro File Storage Security Google APIs Service Agent role"
  title = "${local.custom_role_title_prefix}trend-micro-fss-cloudservices-api-role"
  permissions = [
    "cloudfunctions.functions.setIamPolicy",
    "iam.roles.create",
    "iam.serviceAccounts.setIamPolicy",
    "pubsub.topics.setIamPolicy",
    "resourcemanager.projects.setIamPolicy"
  ]
}

resource "google_project_iam_binding" "iam_binding_cloudservice_agent" {
  project = var.projectID
  role    = "projects/${var.projectID}/roles/${google_project_iam_custom_role.trend_micro_fss_cloudservices_api_role.role_id}"

  members = [
    "serviceAccount:${data.google_project.project.number}@cloudservices.gserviceaccount.com",
  ]

  depends_on = [
    data.google_project.project,
    google_project_iam_custom_role.trend_micro_fss_cloudservices_api_role
  ]
}
