// L11 · IaC cho "hạ tầng ứng dụng" az400-app (bản rẻ: storage + Log Analytics)
// Deploy ở scope resource group:  az deployment group create -g rg-az400-11 -f main.bicep -p main.bicepparam
targetScope = 'resourceGroup'

@description('Tên môi trường (dev/test/prod). Dùng để đặt tên và gắn tag.')
@allowed([
  'dev'
  'test'
  'prod'
])
param environmentName string = 'dev'

@description('Region. Mặc định lấy theo resource group.')
param location string = resourceGroup().location

@description('SKU storage. Dev dùng LRS cho rẻ.')
@allowed([
  'Standard_LRS'
  'Standard_ZRS'
])
param storageSku string = 'Standard_LRS'

@description('Số ngày giữ log trong Log Analytics.')
@minValue(30)
@maxValue(90)
param logRetentionDays int = 30

// Tag chuẩn: ai/cái gì tạo ra resource. Drift detection dựa vào việc so sánh với giá trị này.
var commonTags = {
  app: 'az400-app'
  env: environmentName
  managedBy: 'bicep-l11'
}

// uniqueString: tên ổn định theo RG => chạy lại nhiều lần vẫn ra cùng tên (idempotent)
var suffix = uniqueString(resourceGroup().id)

module storage 'modules/storage.bicep' = {
  name: 'storage-${environmentName}'
  params: {
    name: 'stl11${environmentName}${take(suffix, 8)}'
    location: location
    sku: storageSku
    tags: commonTags
  }
}

resource law 'Microsoft.OperationalInsights/workspaces@2025-02-01' = {
  name: 'log-l11-${environmentName}-${take(suffix, 6)}'
  location: location
  tags: commonTags
  properties: {
    sku: {
      name: 'PerGB2018' // trả theo GB ingest; lab gần như không ingest gì
    }
    retentionInDays: logRetentionDays
  }
}

output storageAccountName string = storage.outputs.name
output workspaceName string = law.name
