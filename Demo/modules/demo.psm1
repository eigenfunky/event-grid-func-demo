function Invoke-Demo {
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $Name
    )
    begin {}
    process {
        $message = "Hey there, $Name"
    }
    end { $message }
}

Export-ModuleMember -Function Invoke-Demo