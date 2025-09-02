targetScope = 'resourceGroup'

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

@description('Timestamp to ensure unique resource names (format: yyyyMMddHHmmss)')
param deploymentTimestamp string = utcNow('yyyyMMddHHmmss')

@description('Tags to apply to all resources')
param resourceTags object

// !: --- Variables ---
var storageAccountBaseName = 'stg${uniqueString(resourceGroup().id)}'
var storageAccountFullName = '${storageAccountBaseName}${environment}'
var storageModuleFullName = '${storageAccountBaseName}-${deploymentTimestamp}-${environment}'

var tags = union(resourceTags, {
  Environment: environment
})

// !: --- Modules ---
module storageModule 'modules/storage.bicep' = {
  name: storageModuleFullName
  scope: resourceGroup()
  params: {
    location: location
    storageAccountName: storageAccountFullName
    tags: tags
  }
}

// !: --- Outputs ---
output storageAccountIdOutput string = storageModule.outputs.storageAccountIdOutput
output storageAccountNameOutput string = storageModule.outputs.storageAccountNameOutput
output primaryBlobEndpointOutput string = storageModule.outputs.primaryBlobEndpointOutput
