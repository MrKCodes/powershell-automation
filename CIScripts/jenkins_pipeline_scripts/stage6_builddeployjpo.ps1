$CLASSIF=${env:CLASSIFIER} + '_Enovia'
#$OPTION=${env:PACKAGE}
#$SCRIPT=${env:OTSCRIPT}
$FTSHOST=${env:FTSHOST}
$log="D:\ds\slave\buildlogs"
$STEP_CONFIG = ${env:STEP_CONFIG}
$STEP_SPINNER = ${env:STEP_SPINNER}
$STEP_STAGING = ${env:STEP_STAGING}

Start-Transcript -Append "$log\${env:CLASSIFIER}"

Write-Output "-----------------------------------------------------------------------------------------------------------------------"
xcopy D:\ds\slave\build\"$CLASSIF"\config\BHP.BHPCustomFilter.web.xml.part D:\ds\3ds\win_b64\resources\warutil\fragment /Y  


if ( $STEP_STAGING -eq 'TRUE'){
    Write-Output "-----------------------------------------------------------------------------------------------------------------------"
    Write-Output "Executing the Build Deploy scripts"                                                           
    D:\ds\3ds\win_b64\code\command\BuildDeploy3DSpace_CAS.bat                                                   
    Write-Output "-----------------------------------------------------------------------------------------------------------------------"
    D:\ds\3ds\win_b64\code\command\BuildDeploy3DSpace_NoCAS.bat                                                 
    Write-Output "-----------------------------------------------------------------------------------------------------------------------"
    Write-Output "Compiling the JPO"                                                                            
    D:\ds\3ds\win_b64\code\bin\mql -c "set cont user creator password Passw0rd ;verb on;compile program * force update;"          
    Write-Output "-----------------------------------------------------------------------------------------------------------------------"

}

else {
    Write-Output " --------- Skipping BUILD DEPLOY and Compile JPO since STAGING is false ---------"
}


Stop-Transcript