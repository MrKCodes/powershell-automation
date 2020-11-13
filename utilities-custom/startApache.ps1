
# Defining the configuration to start the Apache web server
Configuration StartApache 
{
    #Import-DscResource -Name Service –ModuleName 'PSDesiredStateConfiguration'

    Node localhost
    {
        Service Apache
        {
            Name = "Apache2.4"
            State = "Running"
        }
    }
}
#Import-DscResource –ModuleName 'PSDesiredStateConfiguration'
# Defining the configuraiton to stop the SQL Server
Configuration StopMSSQL
{
    Node localhost
    {
        Service StopMSSQL
        {
            Name = "MSSQLSERVER"
            State = "Stopped"
        }
    }
}
# Compiling the StartApache configuration and creating .mof file
StartApache -Verbose 

# Running the configuration StartApache
Start-DscConfiguration -Path StartApache -Verbose -Wait

# Current Configuration of the last session: in this case it will show apache status
Get-DscConfiguration 

# Compiling the StopMSSQL configuration and creating .mof file
StopMSSQL -Verbose

# Running the configuration StopMSSQL
Start-DscConfiguration -Path StopMSSQL -Verbose -Wait

# In this case it will show MSSQL server status
Get-DscConfiguration 