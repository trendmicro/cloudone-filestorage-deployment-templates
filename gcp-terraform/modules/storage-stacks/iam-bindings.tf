data "google_service_account" "management_service_account" {
  for_each = local.storage_stacks
  project = each.value.managementServiceAccountProjectID
  account_id = each.value.managementServiceAccountID
}

resource "google_pubsub_topic_iam_binding" "scan_result_topic_publisher_iam_binding" {
  for_each = local.storage_stacks
  topic = google_pubsub_topic.scan_result_topic[each.key].name
  role = "roles/pubsub.publisher"
  members = [
    "serviceAccount:${google_service_account.bucket_listener_service_account[each.key].email}",
    "serviceAccount:${google_service_account.post_action_tag_service_account[each.key].email}",
    "serviceAccount:${each.value.scanner != null ? var.scanner_service_accounts[each.value.scanner].account_id : each.value.scannerServiceAccountID}@${each.value.scanner != null ? var.projectID : each.value.scannerProjectID}.iam.gserviceaccount.com"
  ]
}

resource "google_pubsub_topic_iam_binding" "scan_result_topic_management_iam_binding" {
  for_each = local.storage_stacks
  topic = google_pubsub_topic.scan_result_topic[each.key].name
  role = "projects/${var.projectID}/roles/${local.custom_role_prefix}trend_micro_fss_pubsub_management_role"
  members = [
    "serviceAccount:${data.google_service_account.management_service_account[each.key].email}"
  ]
}

resource "google_cloudfunctions_function_iam_binding" "bucket_listener_iam_binding" {
  for_each = local.storage_stacks
  region = each.value.region
  cloud_function = google_cloudfunctions_function.bucket_listener_function[each.key].name
  role = "projects/${var.projectID}/roles/${local.custom_role_prefix}trend_micro_fss_cloud_function_management_role"
  members = [
    "serviceAccount:${data.google_service_account.management_service_account[each.key].email}"
  ]
}

resource "google_storage_bucket_iam_binding" "bucket_listener_service_account_iam_binding" {
  for_each = { for storage, values in local.storage_stacks: storage => values if !values.disableScanningBucketIAMBinding }
  bucket  = each.value.scanningBucketName
  role = "roles/storage.legacyObjectReader"
  members = [
    "serviceAccount:${google_service_account.bucket_listener_service_account[each.key].email}"
  ]
}

resource "google_cloudfunctions_function_iam_binding" "post_action_tag_iam_binding" {
  for_each = local.storage_stacks
  region = each.value.region
  cloud_function = google_cloudfunctions_function.post_action_tag_function[each.key].name
  role = "projects/${var.projectID}/roles/${local.custom_role_prefix}trend_micro_fss_cloud_function_management_role"
  members = [
    "serviceAccount:${data.google_service_account.management_service_account[each.key].email}"
  ]
}

resource "google_storage_bucket_iam_binding" "post_action_tag_service_account_iam_binding" {
  for_each = { for storage, values in local.storage_stacks: storage => values if !values.disableScanningBucketIAMBinding }
  bucket  = each.value.scanningBucketName
  role = "projects/${var.projectID}/roles/${local.custom_role_prefix}trend_micro_fss_post_action_tag_role"
  members = [
    "serviceAccount:${google_service_account.post_action_tag_service_account[each.key].email}"
  ]
}

resource "google_secret_manager_secret_iam_binding" "storage_outputs_management_service_account_iam_binding" {
  for_each = local.storage_stacks
  secret_id = google_secret_manager_secret.storage_outputs_secret[each.key].secret_id
  role = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${data.google_service_account.management_service_account[each.key].email}"
  ]
}

resource "google_project_iam_binding" "bucket_listener_sign_blob_iam_binding" {
  for_each = local.storage_stacks
  project = var.projectID
  role    = "projects/${var.projectID}/roles/${local.custom_role_prefix}trend_micro_fss_bucket_listener_role"

  members = ["serviceAccount:${google_service_account.bucket_listener_service_account[each.key].email}"]

  condition {
    title  = "Bucket Listener Sign Blob IAM Binding"
    description = "Trend Micro File Storage Security Bucket Listener Sign Blob IAM Binding"
    expression  = "(resource.type == \"storage.googleapis.com/Bucket\" && resource.name.startsWith(\"projects/_/buckets/${each.value.scanningBucketName}\")) || (resource.type != \"storage.googleapis.com/Bucket\")"
  }
}
