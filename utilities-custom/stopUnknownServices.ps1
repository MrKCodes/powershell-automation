<#
    This DSC configuration will stop the following service:
    * 3DExperience 3DMonitoringAgent
    * 3DExperience 3DSpace CAS
    * 3DExperience 3DSpace NoCAS
    * Jenkins
    * MS SQL Server
    * MS SQL Server Agetn
    * MS SQL Server Browser
    * Windows Defender Firewall

    Note: This script need to be executed with ELEVATED PRIVILIEDGES (for Get-DscConfigurations)!!!!
          Make double sure before executing anything like that !!!!


#>

Configuration stopService
{
    #param($ComputerName="localhost")
    Node localhost
    {
        Service "DS_Monitoring"
        {
            Name = "3DMonitoringAgent_R2019x"
            State = "Stopped"
        }

        Service "DS_3DSpace_CAS"
        {
            Name = "3DSpaceTomEE_R2019x"
            State = "Stopped"
        }

        Service "DS_3DSpace_NoCAS"
        {
            Name = "3DSpaceTomEENoCAS_R2019x"
            State = "Stopped"
        }

        Service "Jenkins"
        {
            Name = "Jenkins"
            State = "Stopped"
        }

        Service "MS_SQL_Server"
        {
            Name = "MSSQLSERVER"
            State = "Stopped"
        }

        Service "MS_SQL_Agent"
        {
            Name = "SQLSERVERAGENT"
            State = "Stopped"
        }

        Service "MS_SQL_Browser"
        {
            Name = "SQLBrowser"
            State = "Stopped"
        }

        Service "Windows_Firewall"
        {
            Name = "mpssvc"
            StartupType = "Disabled"
            State = "Stopped"
        }

    }
}

# Compiling the above configurations
stopService

# Running the configurations
Start-DscConfiguration stopService -Wait -Verbose -Force

Write-Output " Current DSC Configurations are::"
Write-Output "-------------------------------------------------------------------------------------------"

Get-DscConfiguration