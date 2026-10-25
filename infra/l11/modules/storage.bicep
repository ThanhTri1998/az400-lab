// Module storage account có "secure defaults" (PSRule/linter sẽ kiểm tra các thuộc tính này)
param name string
param location string
param sku string
param tags object

resource sa 'Microsoft.Storage/storageAccounts@2025-01-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: sku
  }
  kind: 'StorageV2'
  properties: {
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
    allowBlobPublicAccess: false
    allowSharedKeyAccess: false // PSRule Azure.Storage.LocalAuth: tắt access key, dùng Entra ID
    accessTier: 'Hot'
    networkAcls: {
      defaultAction: 'Deny' // PSRule Azure.Storage.Firewall: chỉ nhận traffic được cho phép
      bypass: 'AzureServices'
    }
  }
}

output name string = sa.name
output id string = sa.id
