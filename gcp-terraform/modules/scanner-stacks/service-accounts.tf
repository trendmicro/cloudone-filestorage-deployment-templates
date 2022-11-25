resource "google_service_account" "scanner_service_account" {
  for_each = local.scanner_stacks
  account_id   = "${each.value.prefix}-${random_id.stack_id[each.key].hex}-scan-sa"
  display_name = "Service Account for Scanner Cloud Function"
}

resource "google_service_account" "pattern_updater_service_account" {
  for_each = local.scanner_stacks
  account_id   = "${each.value.prefix}-${random_id.stack_id[each.key].hex}-upd-sa"
  display_name = "Service Account for Pattern Updater Function"
}
