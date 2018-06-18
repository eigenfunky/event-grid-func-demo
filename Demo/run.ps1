[string] $name = [string]::Empty

if ($REQ_METHOD -eq "POST") {
    # Method: POST
    $requestBody = Get-Content $req -Raw | ConvertFrom-Json
    $name = $requestBody.name
} 
elseif ($REQ_METHOD -eq "GET") {
    # Method: GET
    if ($REQ_QUERY_name) {
        $name = $REQ_QUERY_name
    }
}

# Get params
$VaultName = $env:VaultName
$TenantId = $env:TenantId
$ServicePrincipalApplicationId = $env:ServicePrincipalApplicationId
$ServicePrincipalSecret = Get-AzureKeyVaultSecret -VaultName $VaultName -Name "ServicePrincipalSecret"
$credentials = New-Object PSCredential($ServicePrincipalApplicationId, $ServicePrincipalSecret)

# Authenticate with Azure Powershell through service principal
$params = @{
    ServicePrincipal = $true
    Credential = $credentials
    TenantId = $TenantId
}
Login-AzureRmAccount @params
Get-AzureRmContext

# TODO: Get 'subject' and/or 'resourceId' from event and log to console.

$output = Invoke-Demo -Name $name

Out-File -Encoding ascii -FilePath $res -InputObject $output