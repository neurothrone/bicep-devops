# Bicep DevOps

## Commands

### Login

```shell
az login
```

### 1. Create the resource group

```shell
az deployment sub create \
  --name rg-bicep-devops \
  --location swedencentral \
  --template-file infra/create/main.bicep \
  --parameters location=swedencentral resourceGroupName=rg-bicep-devops \
  --confirm-with-what-if
```

### 2. Create the service principal

```shell
subscription="your-subscription-id"
rg="rg-bicep-devops"
az ad sp create-for-rbac \
  --name $rg \
  --role contributor \
  --scopes /subscriptions/$subscription/resourceGroups/$rg \
  --json-auth --output json
```

### 3. Deploy the main template

```shell
# Use in github workflow
# Subscription-scope deployment combining file + inline overrides
az deployment sub create \
  --name rg-bicep-devops \
  --location swedencentral \
  --template-file infra/deploy/main.bicep \
  --parameters @infra/deploy/main.parameters.json \
               location=swedencentral \
               resourceGroupName=rg-bicep-devops \
  --confirm-with-what-if

az deployment sub create \
  --name rg-bicep-devops \
  --location swedencentral \
  --template-file infra/deploy/main.bicep \
  --parameters @infra/deploy/main.parameters.json \
  --confirm-with-what-if
```

```shell
# Tenant ID of the signed-in context
az account show --query tenantId -o tsv

# Client ID (Application ID) of your app registration by display name
az ad app list --display-name "<YOUR_APP_REGISTRATION_NAME>" --query "[0].appId" -o tsv
```

```shell
az group create --name rg-bicep-devops --location swedencentral
```

```shell
az bicep build --file infra/deploy/main.bicep
```

```shell
az account list

subscriptionId=$(az account show --query id -o tsv)
appName="bicep-devops"
rbacRole="Contributor"
az ad sp create-for-rbac \
  --name $appName \
  --role $rbacRole \
  --scopes /subscriptions/$subscriptionId \
  --json-auth --output json
```

We only need these:

```json
{
  "clientId": "...",
  "clientSecret": "...",
  "subscriptionId": "...",
  "tenantId": "..."
}
```

```shell
az group delete --resource-group <rg-name> --yes --no-wait
```
