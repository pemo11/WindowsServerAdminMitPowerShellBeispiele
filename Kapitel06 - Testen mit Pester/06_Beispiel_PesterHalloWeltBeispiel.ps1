<#
 .Synopsis
 Ein "Hallo, Welt"-Beispiel für den Umgang mit Pester
#>

# ist nicht erforderlich
Import-Module -Name Pester

# Diese Ps1-Datei enthält die zu testenden Functions
. .\GetZahl.ps1

# Einleiten einer Sammlung von Tests
describe "Allgemeine Tests" {

    it "Should return a number less than 10" {
        (Get-Zahl) -lt 10 | Should be $true
    }
}