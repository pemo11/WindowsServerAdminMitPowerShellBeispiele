<#
 .Synopsis
 Typ-Erweiterung per Update-TypeData
#> 

$SB = {
    if ($this.Extension -eq ".Ps1")
    {
        (Get-Help -Name $this.FullName).Synopsis
    }
} 

Update-TypeData -TypeName System.IO.FileInfo `
 -MemberName Comment -MemberType ScriptProperty -Value $SB
 
 Get-ChildItem $env:userprofile\Documents\WindowsPowerShell | 
  Select-Object Name, Comment 