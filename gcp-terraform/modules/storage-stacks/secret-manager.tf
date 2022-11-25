resource "google_secret_manager_secret" "storage_outputs_secret" {
  for_each = local.storage_stacks
  secret_id = "${each.key}-storage-output-secrets"

  replication {
    user_managed {
      replicas {
        location = each.value.region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "storage_outputs_secret_version" {
  for_each = local.storage_stacks
  secret = google_secret_manager_secret.storage_outputs_secret[each.key].id

  secret_data = jsonencode({
      region = each.value.region
      scanningBucketName = each.value.scanningBucketName
      storageProjectID = var.projectID
      scanResultTopic = google_pubsub_topic.scan_result_topic[each.key].name
      bucketListenerFunctionName = "projects/${google_cloudfunctions_function.bucket_listener_function[each.key].project}/locations/${google_cloudfunctions_function.bucket_listener_function[each.key].region}/functions/${google_cloudfunctions_function.bucket_listener_function[each.key].name}"
      postScanActionTagFunctionName = "projects/${google_cloudfunctions_function.post_action_tag_function[each.key].project}/locations/${google_cloudfunctions_function.post_action_tag_function[each.key].region}/functions/${google_cloudfunctions_function.post_action_tag_function[each.key].name}"
      bucketListenerServiceAccountID = google_service_account.bucket_listener_service_account[each.key].account_id
      postActionTagServiceAccountID = google_service_account.post_action_tag_service_account[each.key].account_id
      functionAutoUpdate = var.functionAutoUpdate
  })
}
