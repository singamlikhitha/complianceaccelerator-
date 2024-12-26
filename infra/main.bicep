param resourceGroupName string
param location string
param policyDefinitionName string
param policyDisplayName string
param retentionDays int
param logAnalyticsWorkspaceName string

// Resource Group
resource complianceRg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

// Azure Policy Definition
resource compliancePolicy 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: policyDefinitionName
  properties: {
    displayName: policyDisplayName
    description: 'Ensures that all resources have specific tags.'
    policyType: 'Custom'
    mode: 'All'
    metadata: {
      category: 'Compliance'
    }
    policyRule: {
      if: {
        field: 'tags'
        exists: false
      }
      then: {
        effect: 'deny'
      }
    }
  }
}

// Azure Policy Assignment
resource assignCompliancePolicy 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: policyDefinitionName
  properties: {
    policyDefinitionId: compliancePolicy.id
    scope: complianceRg.id
  }
}

// Log Analytics Workspace
resource complianceLaw 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: logAnalyticsWorkspaceName
  location: complianceRg.location
  properties: {
    retentionInDays: retentionDays
    sku: 'PerGB2018'
  }
}
