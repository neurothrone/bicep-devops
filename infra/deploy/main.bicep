targetScope = 'subscription'

// !: --- Parameters ---
@description('Location for all resources')
param location string

@description('Resource Group name')
param resourceGroupName string

@description('Tags to apply to all resources')
param resourceTags object = {
  environment: 'dev'
  project: 'bicep-devops'
}

// !: --- Modules ---
@description('Module to create the Resource Group')
module resourceGroupModule 'modules/resource-group.bicep' = {
  name: 'resourceGroupModule'
  params: {
    location: location
    resourceGroupName: resourceGroupName
    tags: resourceTags
  }
}

module storageModule 'modules/storage.bicep' = {
  name: 'storageModule'
  scope: resourceGroup(resourceGroupModule.name)
  params: {
    location: location
    name: 'stg${uniqueString(subscription().id, resourceGroupName)}dev'
    tags: resourceTags
  }
  dependsOn: [resourceGroupModule]
}

// !: --- Outputs ---
output storageAccountIdOutput string = storageModule.outputs.storageAccountIdOutput
output storageAccountNameOutput string = storageModule.outputs.storageAccountNameOutput
output primaryBlobEndpointOutput string = storageModule.outputs.primaryBlobEndpointOutput
