/*
 * Ein Cmdlet für das Abrufen von Systeminformationen
 * 
 */
using System;
using System.Management.Automation;
using PSInfoLib;

namespace PsInfoCmdlet
{
    [Cmdlet(VerbsCommon.Get, "PCInfo")]
    public class GetPCInfo : PSCmdlet
    {
        protected override void ProcessRecord()
        {
            PCInfo pcInfo = PSInfoLib.InfoLib.GetPCInfo();
            WriteObject(pcInfo);
        }
    }

    [Cmdlet(VerbsCommon.Get, "OSInfo")]
    public class GetOSInfo : PSCmdlet
    {
        protected override void ProcessRecord()
        {
            OSInfo osInfo = PSInfoLib.InfoLib.GetOSInfo();
            WriteObject(osInfo);
        }
    }

}
