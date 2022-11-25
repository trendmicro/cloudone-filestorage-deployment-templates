output "storage_stacks_outputs" {
  value = <<-EOT
    ${jsonencode({
        "storageStacks": [for k, v in local.storage_stacks : {"deploymentName": "${k}", "projectID": "${var.projectID}"}],
    })}
  EOT
}

output "management_service_accounts" {
  value = local.management_service_accounts
}
