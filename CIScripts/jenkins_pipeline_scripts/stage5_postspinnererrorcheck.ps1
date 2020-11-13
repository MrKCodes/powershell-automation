$CLASSIF=${env:CLASSIFIER} + '_Enovia'
#$OPTION=${env:PACKAGE}
$SCRIPT=${env:OTSCRIPT}
$FTSHOST=${env:FTSHOST}
$log="D:\ds\slave\buildlogs"
$STEP_CONFIG = ${env:STEP_CONFIG}
$STEP_SPINNER = ${env:STEP_SPINNER}
$STEP_STAGING = ${env:STEP_STAGING}

Start-Transcript -Append "$log\${env:CLASSIFIER}"

Write-Output "-----------------------------------------------------------------------------------------------------------------------"

if ($SCRIPT -eq 'TRUE') { Set-Location D:\ds\slave\build\"$CLASSIF"\post-spinner

    Write-Output "Executing the post spinner One time script CAPA Template Creation"                                               
    D:\ds\3ds\win_b64\code\bin\mql -c "set cont user creator password Passw0rd ;verb on;run CAPA_Template_Creation.tcl;"      
}

elseif ($SCRIPT -eq 'FALSE') {
    Write-Output "Post Spinner script need not to run"
}



if ( $STEP_SPINNER -eq 'TRUE'){
    Write-Output "-----------------------------------------------------------------------------------------------------------------------"
    Write-Output "If there are any spinner errors, throwing EXCEPTION"                                          
    if (Get-Content D:\ds\slave\build\"$CLASSIF"\spinner\logs\SpinnerError.log | Select-String -NotMatch "SpinnerAgent finished with no errors.") {
        throw "Spinner Error"                                                                                   
    }
}
elseif ( $STEP_SPINNER -eq 'FALSE') {
    Write-Output " ----------- Since spinner is not executed, hence skipping the ERROR CHECK----------"
}

Stop-Transcript