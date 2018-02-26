<#
 .Synopsis
 Eine Function mit einem dynamischen Parameter
#>

function Get-TextData
{
  [CmdletBinding()]
  param([String]$Path)
  DynamicParam
  {
    if ([System.IO.Path]::GetExtension($Path) -eq ".xml")
    {
      $Attributes = New-Object -TypeName System.Management.Automation.ParameterAttribute
      $Attributes.ParameterSetName = "__AllParameterSets"
      $Attributes.Mandatory = $false
      $AttributeCollection = New-Object -TypeName System.Collections.ObjectModel.Collection[Attribute]
      $AttributeCollection.Add($Attributes)
      $SwitchType = [System.Management.Automation.SwitchParameter]
      $DynParameter = New-Object -Type System.Management.Automation.RuntimeDefinedParameter -ArgumentList "AsXml", $SwitchType, $AttributeCollection
      $DynParameterDic = New-Object -Type Management.Automation.RuntimeDefinedParameterDictionary
      $DynParameterDic.Add("AsXml", $DynParameter)
      $DynParameterDic
    }
  }
  end {
   if ($PSBoundParameters.AsXml -ne $null) {
      [Xml](Get-Content -Path $Path)
   }
   else {
      Get-Content -Path $Path
   }
  }
}

$XmlDef = @'
<books>
 <book id='1000'>
  <title>Alles klar mit PowerShell</title>
 </book>
</books>
'@

$XmlDef > Books.xml

# Den Parameter AsXml gibt es nur, wenn die Erweiterung des Pfades, der dem 
# Path-Parameter übergeben wird, die Erweiterung .Xml besitzt

Get-TextData .\Books.xml -AsXml