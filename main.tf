terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}


module "resource_group" {
  source              = "./modules/resource_group"
  resource_group_name = var.resource_group_name
  location            = var.location
}

module "policy" {
  source                  = "./modules/policy"
  policy_definition_name  = var.policy_definition_name
  policy_display_name     = var.policy_display_name
  resource_group_id       = module.resource_group.id
}

module "log_analytics" {
  source                = "./modules/log_analytics"
  log_analytics_name    = var.log_analytics_workspace_name
  resource_group_name   = module.resource_group.name
  location              = module.resource_group.location
  retention_days        = var.retention_days
}
