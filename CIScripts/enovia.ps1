<#

d:\ds\slave\scripts\enovia.ps1
Required parameters from Jenkins

CLASSIFIER      BUILD_TIMESTAMP
PACKAGE         Choice to import package or not
OTSCRIPT        Choice to run the One time script or not
ARTIFACT_ID
VERSION
FTSHOST         3DSpace Index hostname

Change the password for admin_platform
Change the password for the creator

Artifact from NEXUS will be stored at d:\ds\slave\build
#>

#Remove-Item D:\ds\slave\build\ -Recurse -Force

#New-Item D:\ds\slave\build\ -ItemType "directory"

if (Test-Path D:\ds\slave\buildlogs ){
    Write-Output "Logs folder exists"
}
else {
    New-Item D:\ds\slave\buildlogs -ItemType "directory"
}



$CLASSIF=${env:CLASSIFIER} + '_Enovia'
$OPTION=${env:PACKAGE}
$SCRIPT=${env:OTSCRIPT}
$FTSHOST=${env:FTSHOST}
$log="D:\ds\slave\buildlogs"

Start-Transcript -Path "$log\${env:CLASSIFIER}"

Write-Output "-----------------------------------------------------------------------------------------------------------------------"

Write-Output "---- Taking the STAGING backup------"
Compress-Archive -Path "D:\ds\3ds\STAGING" -DestinationPath "D:\ds\backup\${env:CLASSIFIER}_staging.zip" -CompressionLevel Optimal

Write-Output "-----------------------------------------------------------------------------------------------------------------------"
Set-Location D:\ds\slave\build\                                                                             

Write-Output "----Exapanding the BUILD----"                                                                         

Expand-Archive -Path D:\ds\slave\build\"$CLASSIF".zip -DestinationPath D:\ds\slave\build\"$CLASSIF" -Force  


if ($SCRIPT -eq 'TRUE') { 
    Set-Location D:\ds\slave\build\"$CLASSIF"\onetimescripts\                                      
    Write-Output "Executing one time script"                                                                
    D:\ds\3ds\win_b64\code\bin\mql -c "set cont user creator password Passw0rd ;verb on;run Member_List_Creation.tcl;"       
}

Write-Output "---- Setting up the new config.xml ----"                                                                
$HOST_NAME= $FTSHOST                                                                                        
$DOMAIN_NAME='apac.ent.bhpbilliton.net'

(Get-Content D:\ds\slave\build\$CLASSIF\config\ootb_config.xml) -replace 'HD_SERVER_HOST_NAME', "$HOST_NAME.$DOMAIN_NAME" | Out-File -encoding ASCII D:\ds\slave\build\"$CLASSIF"\config\ootb_config.xml
#(Get-Content D:\ds\slave\build\$CLASSIF\config\custom_config.xml) -replace 'HD_SERVER_HOST_NAME', "$HOST_NAME.$DOMAIN_NAME" | Out-File -encoding ASCII D:\ds\slave\build\"$CLASSIF"\config\custom_config.xml



# $command="set cont user admin_platform password Passw0rd ;verb on;set system searchindex file " + "D:\ds\slave\build\"+$CLASSIF + "\config\config.xml;"+ "start searchindex mode partial vault *;"
$command="set cont user admin_platform password Passw0rd ;verb on;set system searchindex file " + "D:\ds\slave\build\"+$CLASSIF + "\config\	ootb_config.xml;"+ "start searchindex mode partial vault *;"
$command1="set cont user admin_platform password Passw0rd ;verb on;set system searchindexcustom file " + "D:\ds\slave\build\"+$CLASSIF + "\config\custom_config.xml;"+ "start searchindex mode partial vault *;"
Write-Output "Setting ootb config"
D:\ds\3ds\win_b64\code\bin\mql -c $command

Write-Output "Setting custom config"
D:\ds\3ds\win_b64\code\bin\mql -c $command1                                                                  


if ($OPTION -eq 'TRUE') { Set-Location D:\ds\slave\build\"$CLASSIF"\spinner

    Write-Output "Executing the Package Import"                                                             
    D:\ds\3ds\win_b64\code\bin\mql -c "set cont user creator password Passw0rd;set env SPINNERIMPORTPATH D:\ds\slave\build\$CLASSIF\spinner;exec prog SpinnerImport content=package username=admin_platform password=Passw0rd packagename=*;"   
}

Write-Output "-----------------------------------------------------------------------------------------------------------------------"
Write-Output "Copying the STAGING and other jars"                                                           
xcopy D:\ds\slave\build\"$CLASSIF"\STAGING D:\ds\3ds\STAGING /Y /E                                          

xcopy D:\ds\slave\build\"$CLASSIF"\STAGING\ematrix\classes\BHPConstant.jar D:\ds\3ds\win_b64\docs\javaserver\ /Y    

Write-Output "-----------------------------------------------------------------------------------------------------------------------"
Write-Output "Executing the Spinner"                                                                        

Set-Location D:\ds\slave\build\"$CLASSIF"\spinner                                                           
D:\ds\3ds\win_b64\code\bin\mql -c "set cont user creator password Passw0rd ;verb on;exec prog emxSpinnerAgent.tcl;"           


Write-Output "-----------------------------------------------------------------------------------------------------------------------"

if ($SCRIPT -eq 'TRUE') { Set-Location D:\ds\slave\build\"$CLASSIF"\post-spinner

    Write-Output "Executing the post spinner One time script CAPA Template Creation"                                               
    D:\ds\3ds\win_b64\code\bin\mql -c "set cont user creator password Passw0rd ;verb on;run CAPA_Template_Creation.tcl;"      
}
Write-Output "-----------------------------------------------------------------------------------------------------------------------"
Write-Output "If there are any spinner errors, throwing EXCEPTION"                                          
if (Get-Content D:\ds\slave\build\"$CLASSIF"\spinner\logs\SpinnerError.log | Select-String -NotMatch "SpinnerAgent finished with no errors.") {
    throw "Spinner Error"                                                                                   
}

Write-Output "-----------------------------------------------------------------------------------------------------------------------"
xcopy D:\ds\slave\build\"$CLASSIF"\config\BHP.BHPCustomFilter.web.xml.part D:\ds\3ds\win_b64\resources\warutil\fragment /Y  

Write-Output "-----------------------------------------------------------------------------------------------------------------------"
Write-Output "Executing the Build Deploy scripts"                                                           
D:\ds\3ds\win_b64\code\command\BuildDeploy3DSpace_CAS.bat                                                   
Write-Output "-----------------------------------------------------------------------------------------------------------------------"
D:\ds\3ds\win_b64\code\command\BuildDeploy3DSpace_NoCAS.bat                                                 
Write-Output "-----------------------------------------------------------------------------------------------------------------------"
Write-Output "Compiling the JPO"                                                                            
D:\ds\3ds\win_b64\code\bin\mql -c "set cont user creator password Passw0rd ;verb on;compile program * force update;"          
Write-Output "-----------------------------------------------------------------------------------------------------------------------"


#Get-Content D:\ds\slave\buildlogs\$CLASSIF.txt
Stop-Transcript

