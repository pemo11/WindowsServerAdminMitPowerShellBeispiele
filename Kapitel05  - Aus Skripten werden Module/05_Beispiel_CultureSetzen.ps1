<#
 .Synopsis
 Setzen der Kultur für die Ausführung eines Scriptblocks
#>
function Using-Culture
{
  param([ScriptBlock]$Scriptblock, 
        [CultureInfo]$Culture)
  $oldCulture = [System.Threading.Thread]::CurrentThread.CurrentCulture
  $oldUICulture = [System.Threading.Thread]::CurrentThread.CurrentUICulture
  try
  {
    [System.Threading.Thread]::CurrentThread.CurrentCulture = $Culture
    [System.Threading.Thread]::CurrentThread.CurrentUICulture = $Culture
    & $Scriptblock
  }
  finally
  {
    [System.Threading.Thread]::CurrentThread.CurrentCulture = $oldCulture
    [System.Threading.Thread]::CurrentThread.CurrentUICulture = $oldUICulture
  }    
}

Using-Culture -Scriptblock { Get-Date} -Culture fi