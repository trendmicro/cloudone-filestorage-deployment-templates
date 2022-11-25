data "google_service_account" "management_service_account" {
  for_each = local.scanner_stacks
  project = each.value.managementServiceAccountProjectID
  account_id = each.value.managementServiceAccountID
}

resource "google_service_account_iam_binding" "scanner_gcf_service_account_iam" {
  for_each = local.scanner_stacks
  service_account_id = google_service_account.scanner_service_account[each.key].name
  role               = "projects/${var.projectID}/roles/${local.custom_role_prefix}trend_micro_fss_service_account_management_role"

  members = [
    "serviceAccount:${data.google_service_account.management_service_account[each.key].email}"
  ]
}

resource "google_service_account_iam_binding" "pattern_updater_service_account_iam" {
  for_each = local.scanner_stacks
  service_account_id = google_service_account.pattern_updater_service_account[each.key].name
  role               = "projects/${var.projectID}/roles/${local.custom_role_prefix}trend_micro_fss_service_account_management_role"

  members = [
    "serviceAccount:${data.google_service_account.management_service_account[each.key].email}"
  ]
}

resource "google_pubsub_topic_iam_binding" "scanner_topic_management_iam_binding" {
  for_each = local.scanner_stacks
  topic = google_pubsub_topic.scanner_topic[each.key].name
  role = "projects/${var.projectID}/roles/${local.custom_role_prefix}trend_micro_fss_pubsub_management_role"
  members = [
    "serviceAccount:${data.google_service_account.management_service_account[each.key].email}"
  ]
}

resource "google_pubsub_topic_iam_binding" "scanner_topic_iam_management_iam_binding" {
  for_each = local.scanner_stacks
  topic = google_pubsub_topic.scanner_topic[each.key].name
  role = "projects/${var.projectID}/roles/${local.custom_role_prefix}trend_micro_fss_pubsub_iam_management_role"
  members = [
    "serviceAccount:${data.google_service_account.management_service_account[each.key].email}"
  ]
}

resource "google_pubsub_topic_iam_binding" "scanner_topic_publisher_iam_binding" {
  for_each = local.scanner_stacks
  topic = google_pubsub_topic.scanner_topic[each.key].name
  role = "roles/pubsub.publisher"
  members = [
    "serviceAccount:${google_service_account.scanner_service_account[each.key].email}"
  ]

  lifecycle {
    ignore_changes = [
      members, // Prevent the policy is overwritten by stack updating beacuse TF will replace bucket listener's service account by scaner service account defined in here
    ]
  }
}

resource "google_pubsub_topic_iam_binding" "scanner_dlt_topic_management_iam_binding" {
  for_each = local.scanner_stacks
  topic = google_pubsub_topic.scanner_topic_dlt[each.key].name
  role = "projects/${var.projectID}/roles/${local.custom_role_prefix}trend_micro_fss_pubsub_management_role"
  members = [
    "serviceAccount:${data.google_service_account.management_service_account[each.key].email}"
  ]
}

resource "google_pubsub_topic_iam_binding" "scanner_dlt_topic_iam_management_iam_binding" {
  for_each = local.scanner_stacks
  topic = google_pubsub_topic.scanner_topic_dlt[each.key].name
  role = "projects/${var.projectID}/roles/${local.custom_role_prefix}trend_micro_fss_pubsub_iam_management_role"
  members = [
    "serviceAccount:${data.google_service_account.management_service_account[each.key].email}"
  ]
}

resource "google_pubsub_topic_iam_binding" "scanner_dlt_topic_publisher_iam_binding" {
  for_each = local.scanner_stacks
  topic = google_pubsub_topic.scanner_topic_dlt[each.key].name
  role = "roles/pubsub.publisher"
  members = [
    "serviceAccount:service-${data.google_project.project.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
  ]
}

resource "google_storage_bucket_iam_binding" "pattern_update_scanner_iam_binding" {
  for_each = local.scanner_stacks
  bucket = google_storage_bucket.pattern_update_bucket[each.key].name
  role = "projects/${var.projectID}/roles/${local.custom_role_prefix}trend_micro_fss_get_pattern_update_scanner_role"
  members = [
    "serviceAccount:${google_service_account.scanner_service_account[each.key].email}"
  ]
}

resource "google_storage_bucket_iam_binding" "pattern_updater_iam_binding" {
  for_each = local.scanner_stacks
  bucket = google_storage_bucket.pattern_update_bucket[each.key].name
  role = "projects/${var.projectID}/roles/${local.custom_role_prefix}trend_micro_fss_pattern_update_role"
  members = [
    "serviceAccount:${google_service_account.pattern_updater_service_account[each.key].email}"
  ]
}

resource "google_cloudfunctions_function_iam_binding" "pattern_updater_function_iam_binding" {
  for_each = local.scanner_stacks
  region = each.value.region
  cloud_function = google_cloudfunctions_function.pattern_updater_function[each.key].name
  role = "projects/${var.projectID}/roles/${local.custom_role_prefix}trend_micro_fss_cloud_function_management_role"
  members = [
    "serviceAccount:${data.google_service_account.management_service_account[each.key].email}"
  ]
}

resource "google_cloudfunctions_function_iam_binding" "scanner_function_iam_binding" {
  for_each = local.scanner_stacks
  region = each.value.region
  cloud_function = google_cloudfunctions_function.scanner_function[each.key].name
  role = "projects/${var.projectID}/roles/${local.custom_role_prefix}trend_micro_fss_cloud_function_management_role"
  members = [
    "serviceAccount:${data.google_service_account.management_service_account[each.key].email}"
  ]
}

resource "google_cloudfunctions_function_iam_binding" "scanner_dlt_function_iam_binding" {
  for_each = local.scanner_stacks
  region = each.value.region
  cloud_function = google_cloudfunctions_function.scanner_dlt_function[each.key].name
  role = "projects/${var.projectID}/roles/${local.custom_role_prefix}trend_micro_fss_cloud_function_management_role"
  members = [
    "serviceAccount:${data.google_service_account.management_service_account[each.key].email}"
  ]
}

resource "google_secret_manager_secret_iam_binding" "scanner_secret_management_service_account_iam_binding" {
  for_each = local.scanner_stacks
  secret_id = google_secret_manager_secret.scanner_secret[each.key].secret_id
  role = "projects/${var.projectID}/roles/${local.custom_role_prefix}trend_micro_fss_secret_management_role"
  members = [
    "serviceAccount:${data.google_service_account.management_service_account[each.key].email}"
  ]
}

resource "google_secret_manager_secret_iam_binding" "scanner_secret_scanner_service_account_iam_binding" {
  for_each = local.scanner_stacks
  secret_id = google_secret_manager_secret.scanner_secret[each.key].secret_id
  role = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${google_service_account.scanner_service_account[each.key].email}"
  ]
}

resource "google_secret_manager_secret_iam_binding" "scanner_outputs_management_service_account_iam_binding" {
  for_each = local.scanner_stacks
  secret_id = google_secret_manager_secret.scanner_outputs_secret[each.key].secret_id
  role = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${data.google_service_account.management_service_account[each.key].email}"
  ]
}
