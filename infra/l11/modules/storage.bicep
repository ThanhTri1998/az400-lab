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
    allowSharedKeyAccess: true // lab: để true cho đơn giản; production nên false + dùng Entra ID
    accessTier: 'Hot'
  }
}

output name string = sa.name
output id string = sa.id
