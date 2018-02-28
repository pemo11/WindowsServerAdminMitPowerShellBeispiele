<#
 .Synopsis
 DSC-Ressource für das Anlegen eines Profilskriptes
#>

enum ProfileType
{
  CurrentUserAllHosts
  CurrentUserCurrentHost
  AllUsersAllHosts
  AllUsersCurrentHost
}

enum Ensure
{
  Absent
  Present
}

[DSCResource()]
class xPSProfileResource
{
  [DSCProperty(Key)]
  [ProfileType]$ProfileType

  [DSCProperty(Mandatory)]
  [String]$Username

  [DSCProperty()]
  [String]$Hostname

  [DSCProperty()]
  [String]$ErrorBackgroundColor

  [DSCProperty()]
  [Ensure]$Ensure

  [bool]Test()
  {
     $Result = $false
     switch($this.ProfileType)
     {
         "CurrentUserAllHosts" { }
            "CurrentUserCurrentHost" { }
            "AllUsersAllHosts" { }
            "AllUsersCurrentHost" { }
        }
        return $Result
    }

    [void]Set()
    {
        switch($this.ProfileType)
        {
            "CurrentUserAllHosts" { }
            "CurrentUserCurrentHost" { }
            "AllUsersAllHosts" {
            "AllUsersCurrentHost" { }
           }
         }
      }
  }

  [xPSProfileResource]Get()
  {
      if ($this.Ensure -eq "Present")  {
          switch($this.ProfileType)
          {
              "CurrentUserAllHosts" {  }
              "CurrentUserCurrentHost" {  }
              "AllUsersAllHosts" { }
              "AllUsersAllHosts" { }
            }
        } 
        return $this
    }
}
