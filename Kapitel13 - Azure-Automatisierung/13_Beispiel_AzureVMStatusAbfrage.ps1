<#
 .Synopsis
 Status aller Azure-VMs einer Ressource abfragen
#>

Get-AzureRmVM  | ForEach-Object {
    # Jetzt mit Ressourcengruppe und VMName Status holen
    Get-AzureRmVm -ResourceGroupName $_.ResourceGroupName -Name $_.Name -Status -PipelineVariable Vm | 
            Select-Object  -ExpandProperty Statuses | 
                Where-Object Code  -like "PowerState/*" | Select-Object @{n="VM";e={$Vm.Name}}, DisplayStatus
}
