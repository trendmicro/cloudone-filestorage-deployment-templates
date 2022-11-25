output "all_in_one_outputs" {
  value = <<-EOT
    [%{ for scanner, v in var.scannerStacks  ~}{"deploymentName":"${scanner}", "projectID": "${var.projectID}", "storageStacks": [%{ for storage, v in var.storageStacks  ~}%{ if v.scanner == scanner ~}{"deploymentName":"${storage}", "projectID":"${var.projectID}"},%{ endif ~}%{ endfor ~}]},%{ endfor ~}]
  EOT
}
