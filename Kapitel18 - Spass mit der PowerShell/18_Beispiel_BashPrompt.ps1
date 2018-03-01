<#
 .Synopsis
 Ein einfacher Bash-Prompt
 #>
function Prompt
{
  "$($env:username)@$(Hostname)$(cd)$ "
   "`a"
}


