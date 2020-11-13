<#
    Service restart utility
    try {
        Stopping service 3DSpace CAS
        Service Stopped
    } catch()

* requires admin priviledges

#>

<#
Param(
    [Parameter(Mandatory=$true)]
    [string]$choice
    )
#>
$timestamp=Get-Date -f MM-dd-yyyy_HH_mm_ss
$logpath = "logs\$timestamp.log"

Write-Output "Note: This needs to be run with elavated priviledges ! Make double sure if you really need to run this..>!"
Write-Output "The action will be performed on the following services:"
Write-Output "* 3DSpaceTomEENoCAS_R2019x        - "
Write-Output "* 3DSpaceTomEE_R2019x             - "
Write-Output " "

Write-Output "Options ----"
Write-Output "[1] stop"
Write-Output "[2] Start"
Write-Output "[3] Restart"
Write-Output "Input: "

$choice = Read-Host
Start-Transcript -Path $logpath

function stopServices {
    try {
        Write-Output "____________________________________________________"
        Write-Output " Stopping Service 3DSpaceTomEENoCAS..."
        Stop-Service "3DSpaceTomEENoCAS_R2019x"
        Write-Output " Service Stopped"
        Start-Sleep -Seconds 1
        Write-Output "____________________________________________________"
        Write-Output " Stopping Service 3DSpaceTomEE..."
        Stop-Service "3DSpaceTomEE_R2019x"
        Write-Output " Service Stopped"
        Write-Output "____________________________________________________"
        Start-Sleep -Seconds 1

        Get-Service "3DSpaceTomEENoCAS_R2019x"
        Get-Service "3DSpaceTomEE_R2019x"
        Write-Output "____________________________________________________"
    }
    catch {
        "There was some issue while stopping the service"
    }
    
}

function startServices {
    try {
        Write-Output "____________________________________________________"
        Write-Output " Starting Service 3DSpaceTomEENoCAS..."
        Start-Service "3DSpaceTomEENoCAS_R2019x"
        Write-Output " Service Started"
        Start-Sleep -Seconds 1
        Write-Output "____________________________________________________"
        Write-Output " Starting Service 3DSpaceTomEE..."
        Start-Service "3DSpaceTomEE_R2019x"
        Write-Output " Service Started"
        Write-Output "____________________________________________________"
        Start-Sleep -Seconds 1

        Get-Service "3DSpaceTomEENoCAS_R2019x"
        Get-Service "3DSpaceTomEE_R2019x"
        Write-Output "____________________________________________________"
    }
    catch {
        "There was some issue while starting the service"
    }
    
}
if ( $choice -eq "1"){
    stopServices
}

elseif ($choice -eq "2") {
    startServices    
}

elseif ( $choice -eq "3") {
    stopServices
    startServices    
}
else {
    Write-Output "------ Invalid Output -------"
}




Stop-Transcript