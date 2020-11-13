$CLASSIF=${env:CLASSIFIER} + '_Enovia'
#$OPTION=${env:PACKAGE}
#$SCRIPT=${env:OTSCRIPT}
$FTSHOST=${env:FTSHOST}
$log="D:\ds\slave\buildlogs"
$STEP_CONFIG = ${env:STEP_CONFIG}
$STEP_SPINNER = ${env:STEP_SPINNER}
$STEP_STAGING = ${env:STEP_STAGING}

Start-Transcript -Append "$log\${env:CLASSIFIER}"


if ( $STEP_CONFIG -eq 'TRUE'){    
    Write-Output "---- Setting up the new config.xml ----"                                                                
    $HOST_NAME= $FTSHOST                                                                                        
    $DOMAIN_NAME='apac.ent.bhpbilliton.net'

    (Get-Content D:\ds\slave\build\$CLASSIF\config\ootb_config.xml) -replace 'HD_SERVER_HOST_NAME', "$HOST_NAME.$DOMAIN_NAME" | Out-File -encoding ASCII D:\ds\slave\build\"$CLASSIF"\config\ootb_config.xml
    #(Get-Content D:\ds\slave\build\$CLASSIF\config\custom_config.xml) -replace 'HD_SERVER_HOST_NAME', "$HOST_NAME.$DOMAIN_NAME" | Out-File -encoding ASCII D:\ds\slave\build\"$CLASSIF"\config\custom_config.xml

    # $command="set cont user admin_platform password Passw0rd ;verb on;set system searchindex file " + "D:\ds\slave\build\"+$CLASSIF + "\config\config.xml;"+ "start searchindex mode partial vault *;"
    $command="set cont user admin_platform password Passw0rd ;verb on;set system searchindex file " + "D:\ds\slave\build\"+$CLASSIF + "\config\ootb_config.xml;"
    $command1="set cont user admin_platform password Passw0rd ;verb on;set system searchindexcustom file " + "D:\ds\slave\build\"+$CLASSIF + "\config\custom_config.xml;"
    Write-Output "Setting ootb config"
    D:\ds\3ds\win_b64\code\bin\mql -c $command

    Write-Output "Setting custom config"
    D:\ds\3ds\win_b64\code\bin\mql -c $command1  

}

else {
    Write-Output "--------- Skipping the CONFIG.XML Step------------------"
}


  

Stop-Transcript
