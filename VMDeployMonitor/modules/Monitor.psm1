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

function Compare-Rulesets {}

function Add-VmAlerts {}

Export-ModuleMember -Function Get-VmAlerts, Compare-Rulesets, Add-VmAlerts

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

function Get-VmOS {}

function Get-VmDiagnosticsEnabled {}