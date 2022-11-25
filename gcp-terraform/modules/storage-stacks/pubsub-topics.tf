resource "google_pubsub_topic" "scan_result_topic" {
  for_each = local.storage_stacks
  name = "${each.value.prefix}-${random_id.stack_id[each.key].hex}-scan-result-topic"
}
