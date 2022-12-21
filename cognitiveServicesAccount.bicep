param name string
param location string = resourceGroup().location
param tags object = {}

@description('If the SKU supports scale out/in then the capacity integer should be included. If scale out/in is not possible for the resource this may be omitted.')
param skuCapacity int = 0

@description('If the service has different generations of hardware, for the same SKU, then that can be captured here.')
param skufamily string = ''

@description('The name of the SKU. Ex - P3. It is typically a letter+number code')
@allowed([
  'C2'
  'C3'
  'C4'
  'D3'
  'F0'
  'S'
  'S0'
  'S1'
  'S2'
  'S3'
  'S4'  
])
param skuName string = 'F0'

@description('The SKU size. When the name field is the combination of tier and some other value, this would be the standalone code.')
param skuSize string = ''

@description('This field is required to be implemented by the Resource Provider if the service has more than one tier, but is not required on a PUT.')
@allowed([
  ''
  'Free'
  'Standard'
])
param skuTier string = ''

@description('The type of Cognitive Service account.')
@allowed([
  'Academic'
  'AnomalyDetector'
  'Bing.Autosuggest'
  'Bing.Autosuggest.v7'
  'Bing.CustomSearch'
  'Bing.Search'
  'Bing.Search.v7'
  'Bing.Speech'
  'Bing.SpellCheck'
  'Bing.SpellCheck.v7'
  'CognitiveServices'
  'ComputerVision'
  'ContentModerator'
  'CustomSpeech'
  'CustomVision.Prediction'
  'CustomVision.Training'
  'Emotion'
  'Face'
  'FormRecognizer'
  'ImmersiveReader'
  'LUIS'
  'LUIS.Authoring'
  'MetricsAdvisor'
  'Personalizer'
  'QnAMaker'
  'Recommendations'
  'SpeakerRecognition'
  'Speech'
  'SpeechServices'
  'SpeechTranslation'
  'TextAnalytics'
  'TextTranslation'
  'WebLM'
])
param kind string

@description('The identity type')
@allowed([
  'None'
  'SystemAssigned'
  'SystemAssigned, UserAssigned'
  'UserAssigned'
])
param identityType string = 'SystemAssigned'

@description('The list of user assigned identities associated with the resource. The user identity dictionary key references will be ARM resource ids in the form: /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{identityName}')
param identityUserAssignedIdentities object = {}

@description('Array of string.')
param allowedFqdnList array = []

@description('(Metrics Advisor Only) The Azure AD Client Id (Application Id).')
param aadClientId string = ''

@description('(Metrics Advisor Only) The Azure AD Tenant Id.')
param aadTenantId string = ''

@description('(Personalization Only) The flag to enable statistics of Bing Search.')
param eventHubConnectionString string = ''

@description('(QnAMaker/TextAnalytics Only) The Azure Search endpoint id of QnAMaker.')
param qnaAzureSearchEndpointId string = ''

@description('(QnAMaker/TextAnalytics Only) The Azure Search endpoint key of QnAMaker.')
param qnaAzureSearchEndpointKey string = ''

@description('(QnAMaker Only) The runtime endpoint of QnAMaker.')
param qnaRuntimeEndpoint string = ''

@description('(Bing Search Only) The flag to enable statistics of Bing Search.')
param statisticsEnabled bool = false

@description('(Personalization Only) The storage account connection string.')
param storageAccountConnectionString string = ''

@description('(Metrics Advisor Only) The super user of Metrics Advisor.')
param superUser string = ''

@description('(Metrics Advisor Only) The website name of Metrics Advisor.')
param websiteName string = ''

@description('The name to assign to the Text Analytics resource.')
param customSubDomain string = ''

param disableLocalAuth bool = false
param dynamicThrottlingEnabled bool = false


@description('Enumerates the possible value of keySource for Encryption')
@allowed([
  'Microsoft.CognitiveServices'
  'Microsoft.KeyVault'
])
param encryptionKeySource string = 'Microsoft.CognitiveServices'
param encryptionKeyVaultPropertiesIdentityClientId string = ''
param encryptionKeyVaultPropertiesKeyName string = ''
param encryptionKeyVaultPropertiesKeyVaultUri string = ''
param encryptionKeyVaultPropertiesKeyVersion string = ''

@description('Resource migration token')
param migrationToken string = ''

// networkAcls
@description('The default action when no rule from ipRules and from virtualNetworkRules match. This is only used after the bypass property has been evaluated.')
@allowed([
  'Allow'
  'Deny'
])
param networkAclsDefaultAction string = 'Allow'

@description('List of ipRule objects in the form {value: string}')
param networkAclsIpRules array = []

@description('''Array of virtualNetworkRule objects in the form
  {
    id: 'string' (required)
    ignoreMissingVnetServiceEndpoint: bool
    state: 'string'
  }
''')
param networkAclsVirtualNetworkRules array = []

@description('Whether or not public endpoint access is allowed for this account.')
@allowed([
  'Disabled'
  'Enabled'
])
param publicNetworkAccess string = 'Enabled'

param restore bool = false
param restrictOutboundNetworkAccess bool = false

@description('''The storage accounts for this resource in the form:
  {
    identityClientId: 'string'
    resourceId: 'string'
  }
''')
param userOwnedStorage array = []

var apiProperties = kind == 'MetricsAdvisor' ? {
  aadClientId: aadClientId
  aadTenantId: aadTenantId
  superUser: superUser
  websiteName: websiteName 
} : kind == 'Personalizer' ? {
  eventHubConnectionString: eventHubConnectionString
  storageAccountConnectionString: storageAccountConnectionString
} : kind == 'TextAnalytics' ? {
  qnaAzureSearchEndpointId: qnaAzureSearchEndpointId
  qnaAzureSearchEndpointKey: qnaAzureSearchEndpointKey
} : kind == 'QnAMaker' ? {
  qnaAzureSearchEndpointId: qnaAzureSearchEndpointId
  qnaAzureSearchEndpointKey: qnaAzureSearchEndpointKey
  qnaRuntimeEndpoint: qnaRuntimeEndpoint
} : kind == 'Bing.CustomSearch' || kind == 'Bing.Search' || kind == 'Bing.Search.v7' ? {
  statisticsEnabled: statisticsEnabled
} : {}

var encryption = encryptionKeySource == 'Microsoft.CognitiveServices' ? {
  keySource: encryptionKeySource
} : encryptionKeySource == 'Microsoft.KeyVault' ? {
  keySource: encryptionKeySource
  keyVaultProperties: {
    identityClientId: encryptionKeyVaultPropertiesIdentityClientId
    keyName: encryptionKeyVaultPropertiesKeyName
    keyVaultUri: encryptionKeyVaultPropertiesKeyVaultUri
    keyVersion: encryptionKeyVaultPropertiesKeyVersion
  }
} : {}

resource cognitiveServicesAccount 'Microsoft.CognitiveServices/accounts@2022-10-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    capacity: skuCapacity
    family: skufamily
    name: skuName
    size: skuSize
    tier: skuTier
  }
  kind: kind
  identity: {
    type: identityType
    userAssignedIdentities: !empty(identityUserAssignedIdentities) ? identityUserAssignedIdentities : null
  }
  properties: {
    allowedFqdnList: allowedFqdnList
    apiProperties: apiProperties
    customSubDomainName: customSubDomain
    disableLocalAuth: disableLocalAuth
    dynamicThrottlingEnabled: dynamicThrottlingEnabled
    encryption: encryption
    migrationToken: migrationToken
    networkAcls: {
      defaultAction: networkAclsDefaultAction
      ipRules: networkAclsIpRules
      virtualNetworkRules: networkAclsVirtualNetworkRules
    }
    publicNetworkAccess: publicNetworkAccess
    restore: restore
    restrictOutboundNetworkAccess: restrictOutboundNetworkAccess
    userOwnedStorage: !empty(userOwnedStorage) ? userOwnedStorage : null
  }
}
