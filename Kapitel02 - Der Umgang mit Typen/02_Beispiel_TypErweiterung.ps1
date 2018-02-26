<#
 .Synopsis
 Typ-Erweiterung über eine Typdefinitionsdatei
#>

$TypDef = @'
<Types>
    <Type>
        <Name>System.ServiceProcess.ServiceController</Name>
        <Members>
            <ScriptProperty>
                <Name>AnzahlAbhDienste</Name>
                <GetScriptBlock>
                 $this.DependentServices.Count
                </GetScriptBlock>
            </ScriptProperty>
        </Members>
    </Type>
</Types>
'@

$TypDef > "ServiceControllerTypDef.ps1xml"

Update-TypeData -AppendPath .\ServiceControllerTypDef.ps1xml

Get-Service | Select-Object Name, AnzahlAbhDienste

