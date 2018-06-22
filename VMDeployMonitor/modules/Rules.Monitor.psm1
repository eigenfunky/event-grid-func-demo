# These are the default alert configurations for windows. The rules defined 
# here form a generic suite of alerts that should be defined on all windows 
# VMs. These alerts encompass CPU, Disk, and Memory usage statistics.
$CpuRule = @{
    Name            = "vm_cpu_gt_95"
    MetricName      = "Percentage CPU"
    Operator        = "GreaterThan"
    Threshold       = 95
    WindowSize      = $timespan
    TimeAggregation = "Average"
    Description     = "alert on CPU > 95%"
}
$WindowsDiskRule = @{
    Name            = "vm_disk_gt_95"
    MetricName      = "\LogicalDisk(_Total)\% Free Space"
    Operator        = "LessThan"
    Threshold       = 5
    WindowSize      = $timespan
    TimeAggregation = "Average"
    Description     = "alert on Disk > 95%"
}
$WindowsMemoryRule = @{
    Name            = "vm_mem_gt_95"
    MetricName      = "\Memory\% Committed Bytes In Use"
    Operator        = "GreaterThan"
    Threshold       = 95
    WindowSize      = $timespan
    TimeAggregation = "Average"
    Description     = "alert on Memory > 95%"
}

# TODO: Finish the Linux monitoring ruleset
# TODO: Disk Rule needed.
# Linux: \Memory\PercentAvailableMemory
$LinuxMemoryRule = @{
    Name              = "vm_mem_gt_95"
    MetricName        = "\Memory\PercentAvailableMemory"
    Operator          = "GreaterThan"
    Threshold         = 95
    WindowSize        = $timespan
    TimeAggregation   = "Average"
    Description       = "alert on Memory > 95%"
}

# Standard Rulesets by OS
[hashtable] $Rulesets = @{
    Windows = @($CpuRule, $WindowsDiskRule, $WindowsMemoryRule)
    Linux = @($CpuRule, $LinuxMemoryRule)
}
# Create default timespan object
$Timespan = New-TimeSpan -Minutes 5

Export-ModuleMember -Variable $CpuRule, $WindowsDiskRule, $WindowsMemoryRule, $LinuxMemoryRule, $Rulesets, $Timespan