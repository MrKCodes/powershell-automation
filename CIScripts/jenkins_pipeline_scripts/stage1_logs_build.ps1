if (Test-Path D:\ds\slave\buildlogs ){
    Write-Output "Logs folder exists"
}
else {
    New-Item D:\ds\slave\buildlogs -ItemType "directory"
}



$CLASSIF=${env:CLASSIFIER} + '_Enovia'
#$OPTION=${env:PACKAGE}
#$SCRIPT=${env:OTSCRIPT}
$FTSHOST=${env:FTSHOST}
$log="D:\ds\slave\buildlogs"
$BACKUP=${env:BACKUP}

$STEP_CONFIG = ${env:STEP_CONFIG}
$STEP_SPINNER = ${env:STEP_SPINNER}
$STEP_STAGING = ${env:STEP_STAGING}

Start-Transcript -Path "$log\${env:CLASSIFIER}"
Write-Output "-----------------------------------------------------------------------------------------------------------------------"

if ($BACKUP -eq 'TRUE'){
    Write-Output "---- Taking the STAGING backup------"
    Compress-Archive -Path "D:\ds\3ds\STAGING" -DestinationPath "D:\ds\backup\${env:CLASSIFIER}_staging.zip" -CompressionLevel Optimal
}

else {
    Write-Output "----Skipping the STAGING backup----"
}
Write-Output "-----------------------------------------------------------------------------------------------------------------------"
Set-Location D:\ds\slave\build\                                                                             

Write-Output "----Exapanding the BUILD----"                                                                         

Expand-Archive -Path D:\ds\slave\build\"$CLASSIF".zip -DestinationPath D:\ds\slave\build\"$CLASSIF" -Force  

Stop-Transcript
