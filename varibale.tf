variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resource deployment"
  type        = string
}

variable "policy_definition_name" {
  description = "The name of the policy definition"
  type        = string
}

variable "policy_display_name" {
  description = "The display name for the policy"
  type        = string
}

variable "log_analytics_workspace_name" {
  description = "The name of the Log Analytics Workspace"
  type        = string
}

variable "retention_days" {
  description = "Number of days to retain logs"
  type        = number
  
}
