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
$apiVersion = "2017-09-01"
$resourceURI = "https://management.azure.com/"
$tokenAuthURI = $env:MSI_ENDPOINT + "?resource=$resourceURI&api-version=$apiVersion"
$tokenResponse = Invoke-RestMethod -Method Get -Headers @{"Secret"="$env:MSI_SECRET"} -Uri $tokenAuthURI
$accessToken = $tokenResponse.access_token
$accountId = [string]::Empty

$output = $tokenResponse | Format-List

# Authenticate with Azure Powershell through service principal
# Add-AzureRmAccount -AccessToken $accessToken -AccountId $accountId
# Get-AzureRmContext

# # TODO: Get 'subject' and/or 'resourceId' from event and log to console.

# $output = Invoke-Demo -Name $name

Out-File -Encoding ascii -FilePath $res -InputObject $output