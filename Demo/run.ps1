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

$output = Invoke-Demo -Name $name

Out-File -Encoding ascii -FilePath $res -InputObject $output