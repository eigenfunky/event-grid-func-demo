
<#
.SYNOPSIS
    This function is a demonstration of how to authenticate with an MSI token 
    and call modules.
.DESCRIPTION
    This function is a simple demo function to explore the following:
        1. How to utilize the powershell runtime for function apps
        2. How to get a JSON Web Token from MSI
        3. How to authenticate with AzureRm powershell with this access token
        4. How to parse request parameters
        5. How to define and preload modules for consumption.

    This function provides a solid foundation for someone looking to wrap 
    existing powershell scripts in a function app for azure ops automation.

    Next steps:
        1. Institute exception handling for function body
        2. Parse subscription id from resource id
#>

# Constants
[string] $SPApplicationId = $env:ServicePrincipalApplicationId
# TODO: Get this from resource uri instead of app settings
[string] $SubscriptionId = $env:SubscriptionId
[string] $ApiVersion = "2017-09-01"
[string] $ResourceURI = "https://management.azure.com/"

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