@{
    ModuleVersion = '1.0'
    GUID = '053c22df-cf86-4793-b2e2-196334e71425'
    Author = 'Pemo'
    Description = 'Cmdlets für das Abrufen von Systeminformationen'
    PowerShellVersion = '5.0'
    NestedModules = @('PsInfo.psm1','PsInfoHelpers.psm1')
#    ScriptsToProcess = @('PsInfoHelpers.ps1')
    TypesToProcess = @('PSInfoTypes.ps1xml')
    FormatsToProcess = @('PSInfoTypes.format.ps1xml')
    FunctionsToExport = '*'
    CmdletsToExport = '*'
  }
  