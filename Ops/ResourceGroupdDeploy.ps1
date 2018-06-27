param (
    [Parameter(Mandatory = $true)]
    [string]
    $ResourceGroupName,
    [Parameter(Mandatory = $true)]
    [string]
    $Location
)

begin {
    $rg = Get-AzureRmResourceGroup -Name $ResourceGroupName
}

process {
    if ($rg -ne $null) {
        $rg = New-AzureRmResourceGroup -Name $ResourceGroupName -Location $Location
    }
}

end {
    $rg
}