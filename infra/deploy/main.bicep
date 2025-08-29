targetScope = 'subscription'

// !: --- Parameters ---
@description('Resource Group name')
param resourceGroupName string

@description('Location for all resources')
param location string

// !: --- Modules ---
module storageModule 'modules/storage.bicep' = {
  name: 'storageModule'
  scope: resourceGroup(resourceGroupName)
  params: {
    location: location
    name: 'stg${uniqueString(resourceGroupName)}'
  }
}

// !: --- Outputs ---
output storageAccountIdOutput string = storageModule.outputs.storageAccountIdOutput
output storageAccountNameOutput string = storageModule.outputs.storageAccountNameOutput
output primaryBlobEndpointOutput string = storageModule.outputs.primaryBlobEndpointOutput
