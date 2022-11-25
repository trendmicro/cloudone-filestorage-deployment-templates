provider "google" {
  project = var.projectID
}

module "scanner_stacks" {
  source = "../modules/scanner-stacks"
  customRolePrefix = var.customRolePrefix
  functionAutoUpdate = var.functionAutoUpdate
  projectID = var.projectID
  packageURL = var.packageURL
  scannerStacks = var.scannerStacks
}

module "storage_stacks" {
  source = "../modules/storage-stacks"
  customRolePrefix = var.customRolePrefix
  functionAutoUpdate = var.functionAutoUpdate
  projectID = var.projectID
  packageURL = var.packageURL
  storageStacks = var.storageStacks
  scanner_service_accounts = module.scanner_stacks.scanner_service_accounts
  scanner_pubsub_topics = module.scanner_stacks.scanner_pubsub_topics
}

module "function-auto-update-settings" {
  source = "../modules/function-auto-update-settings"
  customRolePrefix = var.customRolePrefix
  functionAutoUpdate = var.functionAutoUpdate
  projectID = var.projectID
  managementServiceAccounts = toset(concat(module.scanner_stacks.management_service_accounts, module.storage_stacks.management_service_accounts))
}
