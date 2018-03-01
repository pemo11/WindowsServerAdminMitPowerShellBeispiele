<#
.Synopsis
Abfragen der Versionsnummer der installierten Azure-PowerShell
.Notes
Die Ausführung kann etwas dauern
Der Web Plattform Installer (WebPI) muss in der Version 5.0 installiert sein
#>
function Get-WindowsAzurePowerShellVersion
{
    [CmdletBinding()]
    param()
    Write-Host 'Azure PowerShell installierte Version: ' -ForegroundColor 'Yellow'
    Get-Module -ListAvailable | Where-Object Name -eq 'Azure' | 
     Select-Object Version, Name, Author
    Write-Host "`nAzure PowerShell verfügbare Version: " -ForegroundColor 'Green'
    try {
        $AssName = "Microsoft.Web.PlatformInstaller, Version=5.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
        Add-Type -AssemblyName $AssName -ErrorAction Stop
        $ProductManager = New-Object -TypeName Microsoft.Web.PlatformInstaller.ProductManager
        $ProductManager.Load()
        $ProductManager.Products |
         Where-Object { $_.Title -match 'Azure PowerShell' -and $_.Author -eq 'Microsoft Corporation' }  | Select-Object Title, Version, Published
    }
    catch {
        Write-Warning "Microsoft.Web.PlatformInstaller-Assembly kann nicht geladen werden."        
    }
}

Get-WindowsAzurePowerShellVersion
