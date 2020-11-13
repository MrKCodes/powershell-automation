<#
Required parameters from Jenkins

CLASSIFIER
ENVIRONMENT         bhp_dev/ bhp_qa/ bhp_prod
ARTIFACT_ID
VERSION

this is a Windows Batch file
#>


rem rmdir /s /q D:\single_build\biovia
mkdir D:\single_build\biovia

cd D:\ds\bpp\bin
D:

pkgutil -u finia/fileutils

pkgutil -u finia/geotools

pkgutil -u finia/geodata

pkgutil -u dassault/kafka

pkgutil -u dassault/rabbitmq

pkgutil -u dassault/voyager

pkgutil -u dassault/vox

pkgutil -u dassaultdev/voyager

pkgutil -u dassaultdev/vox

cd D:\ds\bpp\apps
D:
rmdir /s /q finia
rmdir /s /q dassault
rmdir /s /q dassaultdev


cd D:\single_build\
D:
powershell -command  "Expand-Archive -Path D:\single_build\biovia\%CLASSIFIER%.zip -DestinationPath D:\ds\bpp\apps -Force"

xcopy D:\single_build\biovia\%CLASSIFIER%\ D:\ds\bpp\apps /E /Y


cd D:\ds\bpp\apps\conf
D:
xcopy %ENVIRONMENT%.package.conf D:\ds\bpp\apps\dassault\voyager\package.conf /E /Y

cd D:\ds\bpp\bin

pkgutil -i finia/fileutils

pkgutil -i finia/geotools

pkgutil -i finia/geodata

pkgutil -i dassault/rabbitmq

pkgutil -i dassault/kafka

pkgutil -i dassault/voyager

pkgutil -i dassault/vox

pkgutil -i dassaultdev/voyager

pkgutil -i dassaultdev/vox


rem Aepmanager -k restart

rem powershell -command "Get-Service | Where-Object {$_.displayName.Contains('BIOVIA Pipeline Pilot 19.1.0 Service (Httpd)')}  | Stop-Service"
rem powershell -command "Get-Service | Where-Object {$_.displayName.Contains('BIOVIA Pipeline Pilot 19.1.0 Service (Httpd)')}  | Start-Service"

Aepmanager -k restart


regress -p dassaultdev/voyager 