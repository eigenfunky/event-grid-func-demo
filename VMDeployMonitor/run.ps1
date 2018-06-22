
# Constants
[string] $SPApplicationId = $env:ServicePrincipalApplicationId
# TODO: Get this from resource uri instead of app settings
[string] $SubscriptionId = $env:SubscriptionId
[string] $ApiVersion = "2017-09-01"
[string] $ResourceURI = "https://management.azure.com/"
Write-Information "$ApiVersion"

# Define parameters
[string] $resourceId = [string]::Empty
[string] $subject = [string]::Empty
# Get parameters
if ($REQ_METHOD -eq "POST") {
    # Method: POST
    $requestBody = Get-Content $req -Raw | ConvertFrom-Json
    $resourceId = $requestBody.resourceId
    $subject = $requestBody.subject
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

# Invoke modules here.

Out-File -Encoding ascii -FilePath $res -InputObject $output