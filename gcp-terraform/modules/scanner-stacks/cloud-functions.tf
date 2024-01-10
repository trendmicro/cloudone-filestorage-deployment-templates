resource "null_resource" "gcp_scanner_pattern_updater" {
  provisioner "local-exec" {
    command = "curl ${var.packageURL}gcp-scanner-pattern-updater.zip --output gcp-scanner-pattern-updater.zip"
  }
}

resource "null_resource" "gcp_scanner" {
  provisioner "local-exec" {
    command = "curl ${var.packageURL}gcp-scanner.zip --output gcp-scanner.zip"
  }
}

resource "null_resource" "gcp_scanner_dlt" {
  provisioner "local-exec" {
    command = "curl ${var.packageURL}gcp-scanner-dlt.zip --output gcp-scanner-dlt.zip"
  }
}

resource "google_storage_bucket" "pattern_update_bucket" {
  for_each                    = local.scanner_stacks
  location                    = each.value.region
  project                     = var.projectID
  name                        = "${each.value.prefix}-${random_id.stack_id[each.key].hex}-pattern-update-bucket"
  uniform_bucket_level_access = true
  force_destroy               = true
}

resource "google_storage_bucket" "artifact_bucket" {
  for_each                    = local.scanner_stacks
  location                    = each.value.region
  project                     = var.projectID
  name                        = "${each.value.prefix}-${random_id.stack_id[each.key].hex}-artifact"
  uniform_bucket_level_access = true
  force_destroy               = true
}

resource "google_storage_bucket_object" "gcp_scanner_pattern_updater_source_zip" {
  for_each     = local.scanner_stacks
  source       = "gcp-scanner-pattern-updater.zip"
  content_type = "application/zip"

  name   = "gcp-scanner-pattern-updater.zip"
  bucket = google_storage_bucket.artifact_bucket[each.key].name

  depends_on = [
    null_resource.gcp_scanner_pattern_updater
  ]

  lifecycle {
    ignore_changes = all
  }
}

resource "google_storage_bucket_object" "gcp_scanner_source_zip" {
  for_each     = local.scanner_stacks
  source       = "gcp-scanner.zip"
  content_type = "application/zip"

  name   = "gcp-scanner.zip"
  bucket = google_storage_bucket.artifact_bucket[each.key].name

  depends_on = [
    null_resource.gcp_scanner
  ]

  lifecycle {
    ignore_changes = all
  }
}

resource "google_storage_bucket_object" "gcp_scanner_dlt_source_zip" {
  for_each     = local.scanner_stacks
  source       = "gcp-scanner-dlt.zip"
  content_type = "application/zip"

  name   = "gcp-scanner-dlt.zip"
  bucket = google_storage_bucket.artifact_bucket[each.key].name

  depends_on = [
    null_resource.gcp_scanner_dlt
  ]

  lifecycle {
    ignore_changes = all
  }
}

resource "google_cloudfunctions_function" "pattern_updater_function" {
  for_each = local.scanner_stacks

  name = "${each.value.prefix}-${random_id.stack_id[each.key].hex}-pattern-updater"

  source_archive_bucket = google_storage_bucket.artifact_bucket[each.key].name
  source_archive_object = google_storage_bucket_object.gcp_scanner_pattern_updater_source_zip[each.key].name

  entry_point           = "main"
  runtime               = "python312"
  available_memory_mb   = 2048
  service_account_email = google_service_account.pattern_updater_service_account[each.key].email
  timeout               = 120
  region                = each.value.region

  environment_variables = {
    "LD_LIBRARY_PATH"       = "./:./lib"
    "PATTERN_UPDATE_BUCKET" = google_storage_bucket.pattern_update_bucket[each.key].name
  }

  event_trigger {
    event_type = "providers/cloud.pubsub/eventTypes/topic.publish"
    resource   = google_pubsub_topic.pattern_updater_topic[each.key].name
  }

  lifecycle {
    ignore_changes = [
      labels,
      environment_variables
    ]
  }
}


resource "google_cloud_scheduler_job" "pattern_updater_scheduler" {
  for_each = local.scanner_stacks

  name = "${each.value.prefix}-${random_id.stack_id[each.key].hex}-scheduler"

  description = "pattern update"
  region      = each.value.region
  schedule    = "0 * * * *"
  time_zone   = "UTC"

  pubsub_target {
    topic_name = google_pubsub_topic.pattern_updater_topic[each.key].id
    data       = base64encode("Pattern Update")
  }
}

resource "google_cloudfunctions_function" "scanner_function" {
  for_each = local.scanner_stacks

  name = "${each.value.prefix}-${random_id.stack_id[each.key].hex}-scanner"

  source_archive_bucket = google_storage_bucket.artifact_bucket[each.key].name
  source_archive_object = google_storage_bucket_object.gcp_scanner_source_zip[each.key].name

  entry_point           = "main"
  runtime               = "python312"
  available_memory_mb   = 2048
  service_account_email = google_service_account.scanner_service_account[each.key].email
  timeout               = 120
  region                = each.value.region

  environment_variables = {
    "DEPLOYMENT_NAME"       = each.key
    "LD_LIBRARY_PATH"       = "/workspace:/workspace/lib"
    "PATTERN_PATH"          = "./patterns"
    "PROJECT_ID"            = var.projectID
    "REGION"                = each.value.region
    "PATTERN_UPDATE_BUCKET" = google_storage_bucket.pattern_update_bucket[each.key].name
  }

  secret_environment_variables {
    key        = "SCANNER_SECRETS"
    project_id = data.google_project.project.number
    secret     = google_secret_manager_secret.scanner_secret[each.key].secret_id
    version    = "latest"
  }

  timeouts {
    create = "60m"
    delete = "2h"
  }

  event_trigger {
    event_type = "providers/cloud.pubsub/eventTypes/topic.publish"
    resource   = google_pubsub_topic.scanner_topic[each.key].name
    failure_policy {
      retry = true
    }
  }

  lifecycle {
    ignore_changes = [
      labels,
      secret_environment_variables
    ]
  }
}

resource "google_cloudfunctions_function" "scanner_dlt_function" {
  for_each = local.scanner_stacks

  name = "${each.value.prefix}-${random_id.stack_id[each.key].hex}-scanner-dlt"

  source_archive_bucket = google_storage_bucket.artifact_bucket[each.key].name
  source_archive_object = google_storage_bucket_object.gcp_scanner_dlt_source_zip[each.key].name

  entry_point           = "main"
  runtime               = "python312"
  service_account_email = google_service_account.scanner_service_account[each.key].email
  region                = each.value.region

  event_trigger {
    event_type = "providers/cloud.pubsub/eventTypes/topic.publish"
    resource   = google_pubsub_topic.scanner_topic_dlt[each.key].name
  }

  lifecycle {
    ignore_changes = [
      labels
    ]
  }
}
