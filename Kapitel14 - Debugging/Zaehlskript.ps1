<#
 .Synopsis
 Eine Zählschleife für den Debugger-Test
#>

function f1
{
    param([Int]$Max)
    $i = 0
    while($i -lt $Max)
    {
        $i++
        "While-Durchlauf Nr. $i"
    }
}
