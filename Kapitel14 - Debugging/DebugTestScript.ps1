<#
 .Synopsis
 Dieses Skript soll nur debuggt werden - was es macht spielt daher keine Rolle
#>

function Schritt1
{
    "Schritt 1..."
}

function Schritt2
{
    "Schritt 2..."
}

1..10 | ForEach-Object {
    if ($i % 2 -eq 0)
    {
        Schritt1
    }
    else
    {
        Schritt2
    }
}
