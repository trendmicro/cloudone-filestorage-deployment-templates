locals {
  custom_role_prefix = var.customRolePrefix == "" ? var.customRolePrefix : "${var.customRolePrefix}_"
  custom_role_title_prefix = var.customRolePrefix == "" ? var.customRolePrefix : "${replace(var.customRolePrefix, "_", "-")}-"
}

resource "google_project_iam_custom_role" "trend_micro_fss_cloud_function_management_role" {
  project = var.projectID

  role_id = "${local.custom_role_prefix}trend_micro_fss_cloud_function_management_role"
  description = "Trend Micro File Storage Security Cloud Function Management Role"
  title = "${local.custom_role_title_prefix}trend-micro-fss-cloud-function-management-role"
  permissions = [
    "cloudfunctions.functions.get",
    "cloudfunctions.functions.list",
    "cloudfunctions.functions.sourceCodeGet",
    "cloudfunctions.functions.sourceCodeSet",
    "cloudfunctions.functions.update",
    "cloudbuild.builds.get",
    "cloudbuild.builds.list"
  ]

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_project_iam_custom_role" "trend_micro_fss_log_management_role" {
  project = var.projectID

  role_id = "${local.custom_role_prefix}trend_micro_fss_log_management_role"
  description = "Trend Micro File Storage Security Log Management Role"
  title = "${local.custom_role_title_prefix}trend-micro-fss-log-management-role"
  permissions = [
    "logging.logs.list",
    "logging.queries.create",
    "logging.queries.get",
    "logging.queries.list"
  ]

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_project_iam_custom_role" "trend_micro_fss_pubsub_iam_management_role" {
  project = var.projectID

  role_id = "${local.custom_role_prefix}trend_micro_fss_pubsub_iam_management_role"
  description = "Trend Micro File Storage Security PubSub IAM Management Role"
  title = "${local.custom_role_title_prefix}trend-micro-fss-pubsub-iam-management-role"
  permissions = [
    "pubsub.topics.getIamPolicy",
    "pubsub.topics.setIamPolicy"
  ]

  lifecycle {
    prevent_destroy = true
  }
}


resource "google_project_iam_custom_role" "trend_micro_fss_pubsub_management_role" {
  project = var.projectID

  role_id = "${local.custom_role_prefix}trend_micro_fss_pubsub_management_role"
  description = "Trend Micro File Storage Security PubSub Management Role"
  title = "${local.custom_role_title_prefix}trend-micro-fss-pubsub-management-role"
  permissions = [
    "pubsub.topics.get",
    "pubsub.topics.list",
    "pubsub.subscriptions.get",
    "pubsub.subscriptions.list"
  ]

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_project_iam_custom_role" "trend_micro_fss_secret_management_role" {
  project = var.projectID

  role_id = "${local.custom_role_prefix}trend_micro_fss_secret_management_role"
  description = "Trend Micro File Storage Security Secret Management Role"
  title = "${local.custom_role_title_prefix}trend-micro-fss-secret-management-role"
  permissions = [
    "secretmanager.secrets.get",
    "secretmanager.versions.add",
    "secretmanager.versions.enable",
    "secretmanager.versions.destroy",
    "secretmanager.versions.disable",
    "secretmanager.versions.get",
    "secretmanager.versions.list",
    "secretmanager.versions.access"
  ]

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_project_iam_custom_role" "trend_micro_fss_service_account_management_role" {
  project = var.projectID

  role_id = "${local.custom_role_prefix}trend_micro_fss_service_account_management_role"
  description = "Trend Micro File Storage Security Service Account Management Role"
  title = "${local.custom_role_title_prefix}trend-micro-fss-service-account-management-role"
  permissions = [
    "iam.serviceAccounts.get",
    "iam.serviceAccounts.getIamPolicy",
    "iam.serviceAccounts.list"
  ]

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_project_iam_custom_role" "trend_micro_fss_source_code_set_role" {
  project = var.projectID

  role_id = "${local.custom_role_prefix}trend_micro_fss_source_code_set_role"
  description = "Trend Micro File Storage Security Source Code Set Role"
  title = "${local.custom_role_title_prefix}trend-micro-fss-source-code-set-role"
  permissions = [
    "cloudfunctions.functions.sourceCodeSet"
  ]

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_project_iam_custom_role" "trend_micro_fss_pattern_update_role" {
  project = var.projectID

  role_id = "${local.custom_role_prefix}trend_micro_fss_pattern_update_role"
  description = "Trend Micro File Storage Security Pattern Update Role"
  title = "${local.custom_role_title_prefix}trend-micro-fss-pattern-update-role"
  permissions = [
    "storage.objects.create",
    "storage.objects.delete",
    "storage.objects.get",
    "storage.objects.list",
    "storage.objects.update"
  ]

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_project_iam_custom_role" "trend_micro_fss_get_pattern_update_scanner_role" {
  project = var.projectID

  role_id = "${local.custom_role_prefix}trend_micro_fss_get_pattern_update_scanner_role"
  description = "Trend Micro File Storage Security Get Pattern Update Role"
  title = "${local.custom_role_title_prefix}trend-micro-fss-get-pattern-update-scanner-role"
  permissions = [
    "storage.objects.get",
    "storage.objects.list"
  ]

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_project_iam_custom_role" "trend_micro_fss_bucket_listener_role" {
  project = var.projectID

  role_id = "${local.custom_role_prefix}trend_micro_fss_bucket_listener_role"
  description = "Trend Micro File Storage Security Bucket Listener Role"
  title = "${local.custom_role_title_prefix}trend-micro-fss-bucket-listener-role"
  permissions = [
    "iam.serviceAccounts.signBlob"
  ]

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_project_iam_custom_role" "trend_micro_fss_post_action_tag_role" {
  project = var.projectID

  role_id = "${local.custom_role_prefix}trend_micro_fss_post_action_tag_role"
  description = "Trend Micro File Storage Security Post Action Tag Role"
  title = "${local.custom_role_title_prefix}trend-micro-fss-post-action-tag-role"
  permissions = [
    "storage.objects.get",
    "storage.objects.update"
  ]

  lifecycle {
    prevent_destroy = true
  }
}
