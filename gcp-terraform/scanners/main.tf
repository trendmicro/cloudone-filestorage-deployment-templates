module "scanner_stacks" {
  source = "../modules/scanner-stacks"
  customRolePrefix = var.customRolePrefix
  functionAutoUpdate = var.functionAutoUpdate
  projectID = var.projectID
  packageURL = var.packageURL
  scannerStacks = var.scannerStacks
}

module "function-auto-update-settings" {
  source = "../modules/function-auto-update-settings"
  functionAutoUpdate = var.functionAutoUpdate
  projectID = var.projectID
  customRolePrefix = var.customRolePrefix
  managementServiceAccounts = toset(module.scanner_stacks.management_service_accounts)
}
