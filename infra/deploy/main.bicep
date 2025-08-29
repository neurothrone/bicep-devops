targetScope = 'subscription'

// !: --- Parameters ---
@description('Resource Group name')
param resourceGroupName string

@description('Location for all resources')
param location string

// !: --- Modules ---
resource rg 'Microsoft.Resources/resourceGroups@2024-07-01' = {
  name: resourceGroupName
  location: location
  tags: {
    deployedBy: 'Bicep'
  }
}

module storageModule 'modules/storage.bicep' = {
  name: 'storageModule'
  scope: resourceGroup(rg.name)
  params: {
    location: location
    name: 'stg${uniqueString(rg.id)}'
  }
}

// !: --- Outputs ---
output storageAccountIdOutput string = storageModule.outputs.storageAccountIdOutput
output storageAccountNameOutput string = storageModule.outputs.storageAccountNameOutput
output primaryBlobEndpointOutput string = storageModule.outputs.primaryBlobEndpointOutput
