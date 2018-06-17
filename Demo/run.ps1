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

# Next steps:
# TODO: Add some code to get the secret from the key vault
# TODO: Authenticate with the service principal
# TODO: Get 'subject' and/or 'resourceId' from event and log to console.

$output = Invoke-Demo -Name $name

Out-File -Encoding ascii -FilePath $res -InputObject $output