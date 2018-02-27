<#
 .Synopsis
 Ein einfacher Reihentest, der die Zuverlässigkeit einer Function testet
#>

. .\GetZahl.ps1

describe "Reihen-Tests" {

    it "Should return a number less than 10" {
        $Ergebnis = $false
        1..1000 | ForEach-Object {
            $Ergebnis += (Get-Zahl) -ge 10
        }
        $Ergebnis -eq 0 | Should be $true
    }
}
