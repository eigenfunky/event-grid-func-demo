 <#
 .DESCRIPTION
    This module defines some logic to add alert rules to a vm.
 #>

function Get-VmAlerts {
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $ResourceGroupName,
        [Parameter(Mandatory = $true)]
        [string]
        $TargetResourceId
    )
    $params = @{
        ResourceGroupName = $ResourceGroupName
        TargetResourceId  = $TargetResourceId
        DetailedOutput    = $true
    }

    return Get-AzureRmAlertRule @params
}

function Compare-Rulesets {
    param (
        [Parameter(Mandatory = $true)]
        [hashtable[]]
        $Ruleset,
        [Parameter(Mandatory = $true)]
        [hashtable[]]
        $ActiveRuleset,
        [Parameter(Mandatory = $true)]
        [string[]]
        $EqualityProperties
    )
    [hashtable[]] $RulesToAdd = @()
    $params = @{
        ReferenceObject  = $Ruleset
        DifferenceObject = $ActiveRuleset
        Property         = $EqualityProperties
        IncludeEqual     = $true
        PassThru         = $true
    }
    $results = Compare-Object @params

    # Add all of the left differential rules to the array.
    foreach ($rule in $results) {
        if ($rule.SideIndicator -eq "<=") {
            $RulesToAdd += $rule
        }
    }

    return $RulesToAdd
}

function Add-VmAlerts {
    param (
        [Parameter(Mandatory = $true)]
        [hashtable[]]
        $rules
    )

    # Range over rules and add each one.
    foreach ($rule in $rules) {
        $alertRequest = Add-AzureRmMetricAlertRule @rule
        $alertRequest
    }
}


function Map-RulesToHashtables {
    param (
        [Parameter(Mandatory = $true)]
        [PSCustomObject[]] $Alerts
        )
        [hashtable[]] $configuredRules = @()
        foreach ($alert in $Alerts) {
            $rule = @{
                Operator        = $alert.Condition.OperatorProperty
                Threshold       = $alert.Condition.Threshold
                WindowSize      = $alert.Condition.WindowSize
                TimeAggregation = $alert.Condition.TimeAggregation
                MetricName      = $alert.Condition.DataSource.MetricName
            }
            
            $configuredRules += $rule
        }
        
        $configuredRules
    }
    
function Get-VmOS {
    param (
        [Parameter(Mandatory = $true)]
        [PSCustomObject]
        $vm
    )
    return $vm.StorageProfile.OsDisk.OsType
}
    
# function Get-VmDiagnosticsEnabled {
#     param ()
# }

Export-ModuleMember -Function Add-VmAlerts