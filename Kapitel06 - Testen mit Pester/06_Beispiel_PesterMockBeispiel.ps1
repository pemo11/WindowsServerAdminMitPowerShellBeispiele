<#
 .Synopsis
 Cmdlets, die nicht ausgeführt werden können, können über Mocks nachgebildet werden
#>

. .\ADUserAnlegen.ps1
. .\ADCmdletProxies.ps1

Describe "AD-Tests mit Mock" {

    # Alle Cmdlets muss es geben, was sie ausführen spielt aber keine Rolle,
    # da sie nicht ausgeführt werden - es kommt lediglich auf die Namen
    # und gegebenenfalls die Parameter an

    Context "Mock it" {
        Mock -CommandName New-ADUser
        Mock -CommandName Add-ADGroupMember
        Mock -CommandName Get-AdGroup
        Mock -CommandName New-ADGroup

    it "Tests creating a new useraccount with Mocks" {
        { Create-UserAccount -AccountName TestKonto } | Should not throw
    }
   }
}

