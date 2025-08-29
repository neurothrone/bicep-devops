targetScope = 'subscription'

// !: --- Parameters ---
@description('Environment for all resources (e.g., dev, test, prod)')
@allowed([
  'dev'
  'test'
  'prod'
])
param environment string

@description('Location for all resources')
param location string

@description('Solution name to be used in resource naming (alphanumeric, lowercase)')
param solutionName string

@description('Tags to apply to all resources')
param resourceTags object = {
  environment: environment
  project: 'bicep-devops'
}

@description('Timestamp to ensure unique resource names (format: yyyyMMddHHmmss)')
param deploymentTimestamp string = utcNow('yyyyMMddHHmmss')

// !: --- Variables ---
var resourceGroupBaseName = 'rg-${solutionName}-${uniqueString(subscription().id)}'
var resourceGroupFullName = '${resourceGroupBaseName}-${environment}'
var resourceGroupModuleName = '${resourceGroupBaseName}-${deploymentTimestamp}-${environment}'

var storageAccountBaseName = 'stg${uniqueString(subscription().id, resourceGroupFullName)}'
var storageAccountFullName = '${storageAccountBaseName}${environment}'
var storageModuleFullName = '${storageAccountBaseName}-${deploymentTimestamp}-${environment}'

// !: --- Modules ---
@description('Module to create the Resource Group')
module resourceGroupModule 'modules/resource-group.bicep' = {
  name: resourceGroupModuleName
  params: {
    location: location
    resourceGroupName: resourceGroupFullName
    tags: resourceTags
  }
}

module storageModule 'modules/storage.bicep' = {
  name: storageModuleFullName
  scope: resourceGroup(resourceGroupFullName)
  params: {
    location: location
    storageAccountName: storageAccountFullName
    tags: resourceTags
  }
  dependsOn: [resourceGroupModule]
}

// !: --- Outputs ---
output storageAccountIdOutput string = storageModule.outputs.storageAccountIdOutput
output storageAccountNameOutput string = storageModule.outputs.storageAccountNameOutput
output primaryBlobEndpointOutput string = storageModule.outputs.primaryBlobEndpointOutput
