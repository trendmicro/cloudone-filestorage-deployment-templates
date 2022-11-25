output "scanner_stacks_outputs" {
  value = <<-EOT
    ${jsonencode({
        "scannerStacks": [for k, v in local.scanner_stacks : {"deploymentName": "${k}", "projectID": "${var.projectID}"}],
    })}
  EOT
}

output "scanner_informations" {
  value = <<-EOT
    [%{ for k, v in local.scanner_stacks ~}{"deploymentName":"${k}", "projectID": "${var.projectID}", "scannerServiceAccountID": "${google_service_account.scanner_service_account[k].account_id}", "scannerTopic": "${google_pubsub_topic.scanner_topic[k].name}" }",%{ endfor ~}]
  EOT
}

output "scanner_service_accounts" {
  value = google_service_account.scanner_service_account
}

output "scanner_pubsub_topics" {
  value = google_pubsub_topic.scanner_topic
}

output "management_service_accounts" {
  value = local.management_service_accounts
}
