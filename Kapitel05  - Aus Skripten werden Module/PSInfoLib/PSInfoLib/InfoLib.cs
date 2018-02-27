/*
 * Ruft ein paar Systeminformationen per WMI ab
 * 
 */
using System;
using System.Management;
using System.Collections.Generic;
using System.Linq;

namespace PSInfoLib
{
    public class PCInfo
    {
        public string Model { get; set; }
        public string Hersteller { get; set; }
        public double ArbeitsspeicherGB { get; set; }
        public string CPUTyp { get; set; }
        public string CPUTakt { get; set; }
    }

    public class OSInfo
    {
        public string OSName { get; set; }
        public string OSHersteller { get; set; }
        public string ZeitpunktLetztesBooten { get; set; }
    }

    public static class InfoLib
    {
        public static PCInfo GetPCInfo()
        {
            ManagementClass computerClass = new ManagementClass("Win32_ComputerSystem");
            ManagementObjectCollection mCol = computerClass.GetInstances();
            PCInfo pcInfo = new PCInfo();
            foreach(ManagementObject mo in mCol)
            {
                Int64 arbeitspeicherBytes = Int64.Parse(mo.Properties["TotalPhysicalMemory"].Value.ToString());
                pcInfo.ArbeitsspeicherGB = arbeitspeicherBytes / Math.BigMul(1048576, 1024);
                pcInfo.Model = mo.Properties["Model"].Value.ToString();
                pcInfo.Hersteller = mo.Properties["Manufacturer"].Value.ToString();
            }

            ManagementClass cpuClass = new ManagementClass("Win32_Processor");
            mCol = cpuClass.GetInstances();
            foreach (ManagementObject mo in mCol)
            {
                pcInfo.CPUTakt = mo.Properties["MaxClockSpeed"].Value.ToString();
                pcInfo.CPUTyp = mo.Properties["Caption"].Value.ToString();
                pcInfo.Hersteller = mo.Properties["Manufacturer"].Value.ToString();
            }

            return pcInfo;
        }

        public static OSInfo GetOSInfo()
        {
            ManagementClass computerClass = new ManagementClass("Win32_OperatingSystem");
            ManagementObjectCollection mCol = computerClass.GetInstances();
            OSInfo osInfo = new OSInfo();
            foreach (ManagementObject mo in mCol)
            {
                osInfo.OSName = mo.Properties["Name"].Value.ToString();
                osInfo.OSHersteller = mo.Properties["Manufacturer"].Value.ToString();
                osInfo.ZeitpunktLetztesBooten = mo.Properties["LastBootUpTime"].Value.ToString();
            }
            return osInfo;
        }
    }
}
