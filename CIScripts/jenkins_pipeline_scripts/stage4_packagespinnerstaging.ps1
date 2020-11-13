$CLASSIF=${env:CLASSIFIER} + '_Enovia'
$OPTION=${env:PACKAGE}
#$SCRIPT=${env:OTSCRIPT}
$FTSHOST=${env:FTSHOST}
$log="D:\ds\slave\buildlogs"
$STEP_CONFIG = ${env:STEP_CONFIG}
$STEP_SPINNER = ${env:STEP_SPINNER}
$STEP_STAGING = ${env:STEP_STAGING}

Start-Transcript -Append "$log\${env:CLASSIFIER}"



if ($OPTION -eq 'TRUE') { Set-Location D:\ds\slave\build\"$CLASSIF"\spinner

        Write-Output "Executing the Package Import"                                                             
        D:\ds\3ds\win_b64\code\bin\mql -c "set cont user creator password Passw0rd;set env SPINNERIMPORTPATH D:\ds\slave\build\$CLASSIF\spinner;exec prog SpinnerImport content=package username=admin_platform password=Passw0rd packagename=*;"   
}

if ( $STEP_STAGING -eq 'TRUE') {
    Write-Output "-----------------------------------------------------------------------------------------------------------------------"
    Write-Output "Copying the STAGING and other jars"                                                           
    xcopy D:\ds\slave\build\"$CLASSIF"\STAGING D:\ds\3ds\STAGING /Y /E                                          
    xcopy D:\ds\slave\build\"$CLASSIF"\STAGING\ematrix\classes\BHPConstant.jar D:\ds\3ds\win_b64\docs\javaserver\ /Y    
}
elseif ( $STEP_STAGING -eq 'FALSE' ) {
    Write-Output "------- SKipping STAGING copy ---------------"
}


if ( $STEP_SPINNER -eq 'TRUE'){
    Write-Output "-----------------------------------------------------------------------------------------------------------------------"
    Write-Output "Executing the Spinner"                                                                        

    Set-Location D:\ds\slave\build\"$CLASSIF"\spinner                                                           
    D:\ds\3ds\win_b64\code\bin\mql -c "set cont user creator password Passw0rd ;verb on;exec prog emxSpinnerAgent.tcl;"   

}

elseif ( $STEP_SPINNER -eq 'FALSE') {
    Write-Output "-------- Skipping the SPINNER steps ----------"
}


        

Stop-Transcript
