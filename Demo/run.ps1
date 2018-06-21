
# Constants
[string] $SPApplicationId = $env:ServicePrincipalApplicationId
# TODO: Get this from resource uri instead of app settings
[string] $SubscriptionId = $env:SubscriptionId
[string] $ApiVersion = "2017-09-01"
[string] $ResourceURI = "https://management.azure.com/"
Write-Information "$ApiVersion"

# Parameters
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
$uri = $env:MSI_ENDPOINT + "?resource=$ResourceURI&api-version=$ApiVersion"
$params = @{
    Method = "Get"
    Headers = @{
        "Secret" = "$env:MSI_SECRET"
    }
    Uri = $uri
}
$token = Invoke-RestMethod @params

# Authenticate with Azure Powershell through service principal
$params = @{
    AccessToken = $token.access_token
    AccountId = $SPApplicationId
    SubscriptionId = $SubscriptionId
}
Add-AzureRmAccount @params
Get-AzureRmContext

# TODO: Get 'subject' and/or 'resourceId' from event and log to console.

$output = Invoke-Demo -Name $name

Out-File -Encoding ascii -FilePath $res -InputObject $output