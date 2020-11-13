<#
      QUINTIQ DEPLOYMENT SCRIPT (to be called in he Jenkins)
   * $serverDir is the path to the Ips_deviation_monitoring where models are present
   * $buildDIr is the path of the downloaded BUILD (zipped) from the NEXUS
   * $backupModel is the path where we will keep the previous Models and database backup
   
   * We are following the following steps for the DELMIA Quintiq deployment
      * Backing up the old Models before deploying the new ones
      * Backing up the current state of the Database
      * Copying the new models as pulled from BitBucket, as it is in the model dir
      * Stopping the quintiq services in the following sequence:
            QTCE -> QSERVER -> QDBODBC
      * Starting the quintiq services in the following sequence:
            QDBODBC -> QSERVER -> QTCE
    
   * Restarting the Quintiq service will automatically import the new models
    
   * Then all needed is the validate if everything is working fine
    
   * If anything goes WRONG we can revert back the database as well as database
   * 
   * Variables needed to be imported from JENKINS:
      * BUILD_ID - Unique identifier for the latest build
      * DB_HOST  - HOSTNAME of the DB Server
      * DB_USER  - User to be used to login to DB
      * DB_PASS
      * CRED     - Choice if credntials are required or not 


                                                        --Kartikeya Chauhan

#>

$serverDir='D:\ds\quintiq\models\Ips___deviation_monitoring'
$buildDir='d:\ds\slave\build'
$backupModel='d:\ds\backup\'


#$date=Get-Date

$build=${env:BUILD_ID} + '.zip'

###### DATABASE script block 

$db_host=${env:DB_HOST}

$credChoice=${env:CRED}
$username = ${env:DB_USER}
$password = ConvertTo-SecureString ${env:DB_PASS} -AsPlainText -Force

$psCred = New-Object System.Management.Automation.PSCredential -ArgumentList ($username, $password)


#### Clearing the old backup #####

#Remove-Item -path $backupModel\models -Recurse -Force

New-Item $backupModel\models_${env:BUILD_ID} -ItemType "directory"

#### Taking bakup of current Models ####

xcopy $serverDir $backupModel\models_${env:BUILD_ID} /Y /E

#### Taking Backup of Database ### Taking the credentials if required ##


if ($credChoice -eq "TRUE") {
      Backup-SqlDatabase -ServerInstance $db_host -Database "IPS_VOY_Internal" -BackupFile "D:\backup\quintiq_${env:BUILD_ID}.bak" -Credential $psCred
      
}
else {
      Backup-SqlDatabase -ServerInstance $db_host -Database "IPS_VOY_Internal" -BackupFile "D:\backup\quintiq_${env:BUILD_ID}.bak"     >> D:\ds\slave\buildlogs\quintiq_$CLASSIF.txt
}


#### Deploying the new Models #####
New-Item $buildDir\${env:BUILD_ID} -ItemType "directory"                                            >> D:\ds\slave\buildlogs\quintiq_$CLASSIF.txt
Expand-Archive -Path $buildDir\$build -DestinationPath $buildDir\${env:BUILD_ID} -Force             >> D:\ds\slave\buildlogs\quintiq_$CLASSIF.txt

Remove-Item -path D:\ds\quintiq\models\Ips___deviation_monitoring\_Main -recurse                    >> D:\ds\slave\buildlogs\quintiq_$CLASSIF.txt
#Remove-Item -path  D:\ds\quintiq\models\Ips___deviation_monitoring\_var -recurse

xcopy $buildDir\${env:BUILD_ID}\_Main D:\ds\quintiq\models\Ips___deviation_monitoring\_Main\ /E     >> D:\ds\slave\buildlogs\quintiq_$CLASSIF.txt
xcopy $buildDir\${env:BUILD_ID}\_var D:\ds\quintiq\models\Ips___deviation_monitoring\_var /E        >> D:\ds\slave\buildlogs\quintiq_$CLASSIF.txt

#### Restarting the services ####
Get-Service | Where-Object {$_.DisplayName.Contains('QREMOTEJOBSERVER')} | Stop-Service             >> D:\ds\slave\buildlogs\quintiq_$CLASSIF.txt
Get-Service | Where-Object {$_.DisplayName.Contains('QTCE')} | Stop-Service                         >> D:\ds\slave\buildlogs\quintiq_$CLASSIF.txt
Get-Service | Where-Object {$_.DisplayName.Contains('QSERVER')} | Stop-Service                      >> D:\ds\slave\buildlogs\quintiq_$CLASSIF.txt
Get-Service | Where-Object {$_.DisplayName.Contains('QDBODBC')} | Stop-Service                      >> D:\ds\slave\buildlogs\quintiq_$CLASSIF.txt

Get-Service | Where-Object {$_.DisplayName.Contains('QDBODBC')} | Start-Service                     >> D:\ds\slave\buildlogs\quintiq_$CLASSIF.txt
Get-Service | Where-Object {$_.DisplayName.Contains('QSERVER')} | Start-Service                     >> D:\ds\slave\buildlogs\quintiq_$CLASSIF.txt
Get-Service | Where-Object {$_.DisplayName.Contains('QTCE')} | Start-Service                        >> D:\ds\slave\buildlogs\quintiq_$CLASSIF.txt
Get-Service | Where-Object {$_.DisplayName.Contains('QREMOTEJOBSERVER')} | Start-Service            >> D:\ds\slave\buildlogs\quintiq_$CLASSIF.txt

<# 
#>