@description('Azure region for the Storage Account')
param location string

@description('Name of the Storage Account (3-24 lowercase letters/numbers)')
@minLength(3)
@maxLength(24)
param name string

@description('Tags to apply to the resource')
param tags object

resource storage 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  location: location
  name: name
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
  }
  tags: tags
}

@description('Storage account resource id')
output storageAccountIdOutput string = storage.id

@description('Storage account name')
output storageAccountNameOutput string = storage.name

@description('Primary Blob Endpoint URL for the Storage Account')
output primaryBlobEndpointOutput string = storage.properties.primaryEndpoints.blob
