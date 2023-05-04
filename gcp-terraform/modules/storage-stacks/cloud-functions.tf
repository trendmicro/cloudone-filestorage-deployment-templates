resource "null_resource" "gcp_bucket_listener" {
  provisioner "local-exec" {
    command = "curl ${var.packageURL}gcp-listener.zip --output gcp-listener.zip"
  }
}

resource "null_resource" "gcp_post_action_tag" {
  provisioner "local-exec" {
    command = "curl ${var.packageURL}gcp-action-tag.zip --output gcp-action-tag.zip"
  }
}

resource "google_storage_bucket" "artifact_bucket" {
  for_each = local.storage_stacks
  location = each.value.region
  project = var.projectID
  name = "${each.value.prefix}-${random_id.stack_id[each.key].hex}-artifact"
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "gcp_bucket_listener_zip" {
  for_each = local.storage_stacks
  source       = "gcp-listener.zip"
  content_type = "application/zip"

  name         = "gcp-listener.zip"
  bucket       = google_storage_bucket.artifact_bucket[each.key].name

  depends_on   = [
    null_resource.gcp_bucket_listener
  ]

  lifecycle {
    ignore_changes = all
  }
}

resource "google_storage_bucket_object" "gcp_post_action_tag_source_zip" {
  for_each = local.storage_stacks
  source       = "gcp-action-tag.zip"
  content_type = "application/zip"

  name         = "gcp-action-tag.zip"
  bucket       = google_storage_bucket.artifact_bucket[each.key].name

  depends_on   = [
    null_resource.gcp_post_action_tag
  ]

  lifecycle {
    ignore_changes = all
  }
}

resource "google_cloudfunctions_function" "bucket_listener_function" {
  for_each = local.storage_stacks

  name = "${each.value.prefix}-${random_id.stack_id[each.key].hex}-bucket-listener"

  source_archive_bucket = google_storage_bucket.artifact_bucket[each.key].name
  source_archive_object = google_storage_bucket_object.gcp_bucket_listener_zip[each.key].name

  entry_point = "handler"
  runtime = "nodejs16"
  service_account_email = google_service_account.bucket_listener_service_account[each.key].email
  region = each.value.region

  event_trigger {
    event_type = "google.storage.object.finalize"
    resource = "projects/${var.projectID}/buckets/${each.value.scanningBucketName}"
  }

  environment_variables = {
    "SCANNER_PUBSUB_TOPIC": each.value.scanner != null ? var.scanner_pubsub_topics[each.value.scanner].name: each.value.scannerTopic
    "SCANNER_PROJECT_ID": each.value.scanner != null ? var.projectID : each.value.scannerProjectID
    "SCAN_RESULT_TOPIC": "projects/${var.projectID}/topics/${google_pubsub_topic.scan_result_topic[each.key].name}"
    "DEPLOYMENT_NAME": each.key,
    "REPORT_OBJECT_KEY": each.value.reportObjectKey
    "OBJECT_FILTER_PREFIX": each.value.objectFilterPrefix
  }

  lifecycle {
    ignore_changes = [
      labels
    ]
  }
}


resource "google_cloudfunctions_function" "post_action_tag_function" {
  for_each = local.storage_stacks

  name = "${each.value.prefix}-${random_id.stack_id[each.key].hex}-post-action-tag"

  source_archive_bucket = google_storage_bucket.artifact_bucket[each.key].name
  source_archive_object = google_storage_bucket_object.gcp_post_action_tag_source_zip[each.key].name

  entry_point = "main"
  runtime = "python38"
  service_account_email = google_service_account.post_action_tag_service_account[each.key].email
  region = each.value.region

  event_trigger {
    event_type = "providers/cloud.pubsub/eventTypes/topic.publish"
    resource = google_pubsub_topic.scan_result_topic[each.key].name
  }

  lifecycle {
    ignore_changes = [
      labels
    ]
  }
}
