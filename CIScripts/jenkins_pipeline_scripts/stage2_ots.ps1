$CLASSIF=${env:CLASSIFIER} + '_Enovia'
#$OPTION=${env:PACKAGE}
$SCRIPT=${env:OTSCRIPT}
$FTSHOST=${env:FTSHOST}
$log="D:\ds\slave\buildlogs"

Start-Transcript -Append "$log\${env:CLASSIFIER}"


if ($SCRIPT -eq 'TRUE') { 
    Set-Location D:\ds\slave\build\"$CLASSIF"\onetimescripts\                                      
    Write-Output "Executing one time script"                                                                
    D:\ds\3ds\win_b64\code\bin\mql -c "set cont user creator password Passw0rd ;verb on;run Member_List_Creation.tcl;"       
}

Stop-Transcript
