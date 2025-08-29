targetScope = 'subscription'

// !: --- Parameters ---
@description('Azure region for the resource group')
param location string

@description('Name of the resource group to create')
@minLength(1)
param resourceGroupName string

@description('Tags to apply to the resource')
param tags object

// !: --- Resources ---
resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-07-01' = {
  location: location
  name: resourceGroupName
  tags: tags
}

// !: --- Outputs ---
@description('The name of the created resource group')
output nameOutput string = resourceGroup.name

@description('The location of the created resource group')
output locationOutput string = resourceGroup.location
