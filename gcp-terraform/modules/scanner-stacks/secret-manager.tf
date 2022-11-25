resource "google_secret_manager_secret" "scanner_secret" {
  for_each = local.scanner_stacks
  secret_id = "${each.key}-scanner-secrets"

  replication {
    user_managed {
      replicas {
        location = each.value.region
      }
    }
  }
}

resource "google_secret_manager_secret" "scanner_outputs_secret" {
  for_each = local.scanner_stacks
  secret_id = "${each.key}-scanner-output-secrets"

  replication {
    user_managed {
      replicas {
        location = each.value.region
      }
    }
  }
}


resource "google_secret_manager_secret_version" "scanner_secret_version" {
  for_each = local.scanner_stacks
  secret = google_secret_manager_secret.scanner_secret[each.key].id

  secret_data = jsonencode({})
}

resource "google_secret_manager_secret_version" "scanner_outputs_secret_version" {
  for_each = local.scanner_stacks
  secret = google_secret_manager_secret.scanner_outputs_secret[each.key].id

  secret_data = jsonencode({
      region = each.value.region
      scannerProjectID = var.projectID
      scannerTopic = google_pubsub_topic.scanner_topic[each.key].name
      scannerTopicDLT = google_pubsub_topic.scanner_topic_dlt[each.key].name
      scannerFunctionName = "projects/${google_cloudfunctions_function.scanner_function[each.key].project}/locations/${google_cloudfunctions_function.scanner_function[each.key].region}/functions/${google_cloudfunctions_function.scanner_function[each.key].name}"
      patternUpdaterFunctionName = "projects/${google_cloudfunctions_function.pattern_updater_function[each.key].project}/locations/${google_cloudfunctions_function.pattern_updater_function[each.key].region}/functions/${google_cloudfunctions_function.pattern_updater_function[each.key].name}"
      scannerDLTFunctionName = "projects/${google_cloudfunctions_function.scanner_dlt_function[each.key].project}/locations/${google_cloudfunctions_function.scanner_dlt_function[each.key].region}/functions/${google_cloudfunctions_function.scanner_dlt_function[each.key].name}"
      scannerSecretsName = google_secret_manager_secret.scanner_secret[each.key].secret_id
      scannerServiceAccountID = google_service_account.scanner_service_account[each.key].account_id
      patternUpdateSchedulerJobName = google_cloud_scheduler_job.pattern_updater_scheduler[each.key].name
      patternUpdateBucket = google_storage_bucket.pattern_update_bucket[each.key].name
      functionAutoUpdate = var.functionAutoUpdate
  })
}
