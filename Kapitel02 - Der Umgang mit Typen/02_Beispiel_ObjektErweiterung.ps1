<#
 .Synopsis
 Objekt-Erweiterung per Add-Member-Cmdlet
#>

$SB = {
    (Get-Content -Path $this.FullName -TotalCount 3 -Encoding Default) -join "`n"
}

Get-ChildItem -Path *.ps1 | ForEach-Object {
    $_ | Add-Member -MemberType ScriptProperty -Name Comment -Value $SB -PassThru
} | Format-List Name, Comment
  