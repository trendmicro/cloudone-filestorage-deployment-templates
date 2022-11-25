resource "google_pubsub_topic" "scanner_topic" {
  for_each = local.scanner_stacks
  name = "${each.value.prefix}-${random_id.stack_id[each.key].hex}-scanner-topic"

  depends_on = [
    google_service_account.scanner_service_account
  ]
}

resource "google_pubsub_topic" "pattern_updater_topic" {
  for_each = local.scanner_stacks
  name = "${each.value.prefix}-${random_id.stack_id[each.key].hex}-pattern-updater-topic"

  depends_on = [
    google_service_account.pattern_updater_service_account
  ]
}

resource "google_pubsub_topic" "scanner_topic_dlt" {
  for_each = local.scanner_stacks
  name = "${each.value.prefix}-${random_id.stack_id[each.key].hex}-scanner-topic-dlt"
}

resource "null_resource" "add_gcp_scanner_topic_dlt" {
  for_each = local.scanner_stacks
  provisioner "local-exec" {
    command = <<-EOT
      SUBSCRIPTIONS=$(gcloud pubsub topics list-subscriptions ${google_pubsub_topic.scanner_topic[each.key].name})

      SCANNER_SUBSCRIPTION_ID=$${SUBSCRIPTIONS#*/*/*/}

      gcloud pubsub subscriptions update $SCANNER_SUBSCRIPTION_ID \
        --dead-letter-topic=${google_pubsub_topic.scanner_topic_dlt[each.key].name} \
        --max-delivery-attempts=5

      gcloud pubsub subscriptions add-iam-policy-binding $SCANNER_SUBSCRIPTION_ID \
        --member="serviceAccount:service-${data.google_project.project.number}@gcp-sa-pubsub.iam.gserviceaccount.com"\
        --role="roles/pubsub.subscriber"
    EOT
  }

  depends_on = [
    google_pubsub_topic.scanner_topic,
    google_cloudfunctions_function.scanner_function,
    google_pubsub_topic.scanner_topic_dlt
  ]
}
