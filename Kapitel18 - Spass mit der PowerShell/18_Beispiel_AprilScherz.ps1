<#
 .Synopsis
 Ein April-Scherz-Beispiel
#>

function Out-Psychedelic
{
    param([String]$Term)
    "Sorry.. heute gibt es leider keine $Term - bitte wenden Sie sich an Ihren Administrator".ToCharArray().ForEach{
        $f = "Green","Yellow","Blue","Magenta", "Black" | Get-Random
        Write-Host -ForegroundColor $f -BackgroundColor White -Object $_ -NoNewline
        [Console]::Beep(2000,10)
    }
    Start-Sleep -Milliseconds 200
    [Console]::Beep(800,400)
    [Console]::Beep(400,400)
    [Console]::Beep(2000,400)
    Write-Host
}
                                                                                                                       

function Get-Process
{
    Out-Psychedelic -Term Prozesse
}

function Get-Service
{
    Out-Psychedelic -Term Prozesse
}

function Get-Hotfix
{
    Out-Psychedelic -Term Hotfixes
}

function Get-ADUser
{
    Out-Psychedelic -Term Benutzerkonten
}

<#
 .Synopsis
 Räumt wieder auf, in dem der alte Zustand wiederhgestellt wird
#>
function Clear-Mess
{
    @("Process", "Service", "Hotfix", "ADUser").ForEach{
        del function:Get-$_
    }
    Write-Warning "Alle Cmdlets funktionieren wieder wie gewohnt"
}

