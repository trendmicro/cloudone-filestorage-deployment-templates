resource "google_service_account" "bucket_listener_service_account" {
  for_each = local.storage_stacks
  account_id   = "${each.value.prefix}-${random_id.stack_id[each.key].hex}-bl-sa"
  display_name = "Service Account for Bucket Listener Cloud Function"
}

resource "google_service_account" "post_action_tag_service_account" {
  for_each = local.storage_stacks
  account_id   = "${each.value.prefix}-${random_id.stack_id[each.key].hex}-pat-sa"
  display_name = "Service Account for PostAction Tag Cloud Function"
}


data "google_service_account" "bucket_listener_service_accounts" {
  for_each = local.storage_stacks
  account_id = google_service_account.bucket_listener_service_account[each.key].id
}
