terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.0"  # Ensure you're using a compatible version
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "compliance_rg" {
  name     = var.resource_group_name
  location = var.location
}

# Azure Policy Definition
resource "azurerm_policy_definition" "compliance_policy" {
  name         = var.policy_definition_name
  policy_type  = "Custom"
  mode         = "All"
  display_name = var.policy_display_name
  description  = "Ensures that all resources have specific tags."
  metadata = jsonencode({
    category = "Compliance"
  })

  policy_rule = jsonencode({
    if = {
      field = "tags"
      exists = false
    }
    then = {
      effect = "deny"
    }
  })
}

# Azure Policy Assignment
resource "azurerm_policy_assignment" "assign_compliance_policy" {
  name                 = var.policy_definition_name
  policy_definition_id = azurerm_policy_definition.compliance_policy.id
  scope                = azurerm_resource_group.compliance_rg.id
}

# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "compliance_law" {
  name                = var.log_analytics_workspace_name
  location            = azurerm_resource_group.compliance_rg.location
  resource_group_name = azurerm_resource_group.compliance_rg.name
  sku                 = "PerGB2018"
  retention_in_days   = var.retention_days
}

