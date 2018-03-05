<#
 .Synopsis
 Eine selbst entwickelte DSC-Ressource
 .Description
 Legt eine Profilskriptdatei in einem Benutzerprofile an
#>

enum Ensure
{ 
    Absent 
    Present 
}

[DscResource()]
class cPoshProfileResource
{
    [DscProperty()]
    [Ensure]$Ensure
    [DscProperty(Mandatory,Key)]
    [String]$Username
    [DscProperty(NotConfigurable)]
    [Nullable[Datetime]] $CreationTime

    [void]Set()
    {
        $ProfilePath = "C:\Users\$($this.Username)\Documents\WindowsPowerShell\Profile.ps1"
        if ($this.Ensure -eq "Present")
        {
            # Es muss nicht abgefragt werden, ob Profile.ps1 bereits existiert, da die Set()-Methode
            # ja nur dann ausgeführt wird, wenn dies nicht der Fall ist
            New-Item -ItemType File -Path $ProfilePath -Force
            $Ps1Code = "# A DSC generated profile script`n"
            $Ps1Code += "`$Host.PrivateData.ErrorBackgroundColor = 'White'`n"
            $Ps1Code += "cd `$env:userprofile\documents\WindowsPowerShell`n`n"
            Add-Content -Path $ProfilePath -Value $Ps1Code
        }
        else
        {
            if (Test-Path -Path $ProfilePath)
            {
                Remove-Item -Path $ProfilePath -Force
            }
        }
        
    }

    [bool]Test()
    {
        $ProfilePath = "C:\Users\$($this.Username)\Documents\WindowsPowerShell\Profile.ps1"
        $ProfileScriptExist = Test-Path -Path $ProfilePath
        if ($this.Ensure -eq "Present")
        {
            return $ProfileScriptExist
        }
        else
        {
            return -not $ProfileScriptExist
        }
    }

    [cPoshProfileResource]Get()
    {
        $ProfilePath = "C:\Users\$($this.Username)\Documents\WindowsPowerShell\Profile.ps1"
        if (Test-Path -Path $ProfilePath) {
            $this.Ensure = "Present"
            $this.CreationTime = (Get-Item -Path $ProfilePath).CreationTime
        }
        else {
            $this.CreationTime = $null
            $this.Ensure = "Absent"
        }
        return $this
    }
}