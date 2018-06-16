function Invoke-Demo {
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $Name
    )
    begin {
        $message = "hello, "
    }
    process {
        $message += $Name
    }
    end {
        $message
    }
}

Export-ModuleMember -Function Invoke-Demo