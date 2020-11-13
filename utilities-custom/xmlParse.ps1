[xml]$myXML= Get-Content UserIntentions_CODE.xml
#Write-Output $myXML.UserIntentions.SetVariable.($_.name, $_.value) 
#$nodes = Select-Xml "//Object[Property/@Name='ServiceState' and Property='Running']/Property[@Name='DisplayName']" $xml
#$nodes | ForEach-Object {$_.Node.'#text'}

$base_url = "https://pun-bhpvmw01.dsone.3ds.com"
$ds_dir = "d:\ds"
$jdk_path = "$ds_dir\java\jdk1.8.0_191"
$smtp_host = "mailhost.ap.3ds.com"

( Get-Content "UserIntentions_CODE.xml" ) -Replace ($myXML.UserIntentions.SetVariable | Where-Object { $_.name -eq "Java@jdk"}).value, $jdk_path | Out-File "UserIntentions_CODE.xml"
( Get-Content "UserIntentions_CODE.xml" ) -Replace ($myXML.UserIntentions.SetVariable | Where-Object { $_.name -eq "MSSQL_ConnectUser"}).value, "https://bhpvmwx.dsone.3ds.com/3dpassport" | Out-File "UserIntentions_CODE.xml"
( Get-Content "UserIntentions_CODE.xml" ) -Replace ($myXML.UserIntentions.SetVariable | Where-Object { $_.name -eq "MSSQL_ConnectPwd"}).value, "https://bhpvmwx.dsone.3ds.com/3dpassport" | Out-File "UserIntentions_CODE.xml"
( Get-Content "UserIntentions_CODE.xml" ) -Replace ($myXML.UserIntentions.SetVariable | Where-Object { $_.name -eq "MSSQL_Instance"}).value, "https://bhpvmwx.dsone.3ds.com/3dpassport" | Out-File "UserIntentions_CODE.xml"
( Get-Content "UserIntentions_CODE.xml" ) -Replace ($myXML.UserIntentions.SetVariable | Where-Object { $_.name -eq "MSSQL_Server"}).value, "https://bhpvmwx.dsone.3ds.com/3dpassport" | Out-File "UserIntentions_CODE.xml"
( Get-Content "UserIntentions_CODE.xml" ) -Replace ($myXML.UserIntentions.SetVariable | Where-Object { $_.name -eq "X3DCSMA_creator_password"}).value, "https://bhpvmwx.dsone.3ds.com/3dpassport" | Out-File "UserIntentions_CODE.xml"
( Get-Content "UserIntentions_CODE.xml" ) -Replace ($myXML.UserIntentions.SetVariable | Where-Object { $_.name -eq "X3DCSMA_administor_password"}).value, "https://bhpvmwx.dsone.3ds.com/3dpassport" | Out-File "UserIntentions_CODE.xml"
( Get-Content "UserIntentions_CODE.xml" ) -Replace ($myXML.UserIntentions.SetVariable | Where-Object { $_.name -eq "DATA_TARGET_PATH"}).value, "https://bhpvmwx.dsone.3ds.com/3dpassport" | Out-File "UserIntentions_CODE.xml"


( Get-Content "UserIntentions_CODE.xml" ) -Replace ($myXML.UserIntentions.SetVariable | Where-Object { $_.name -eq "X3DCSMA_3DPassportURL"}).value, "$base_url/3dpassport" | Out-File "UserIntentions_CODE.xml"
( Get-Content "UserIntentions_CODE.xml" ) -Replace ($myXML.UserIntentions.SetVariable | Where-Object { $_.name -eq "X3DCSMA_FULL_TEXT_SEARCH"}).value, "$base_url/3dpassport" | Out-File "UserIntentions_CODE.xml"
( Get-Content "UserIntentions_CODE.xml" ) -Replace ($myXML.UserIntentions.SetVariable | Where-Object { $_.name -eq "X3DCSMA_FEDERATED_SEARCH"}).value, "$base_url/3dpassport" | Out-File "UserIntentions_CODE.xml"
( Get-Content "UserIntentions_CODE.xml" ) -Replace ($myXML.UserIntentions.SetVariable | Where-Object { $_.name -eq "X3DCSMA_3DDashboardURL"}).value, "$base_url/3dpassport" | Out-File "UserIntentions_CODE.xml"
( Get-Content "UserIntentions_CODE.xml" ) -Replace ($myXML.UserIntentions.SetVariable | Where-Object { $_.name -eq "X3DCSMA_3DSpaceURL"}).value, "h$base_url/3dpassport" | Out-File "UserIntentions_CODE.xml"
( Get-Content "UserIntentions_CODE.xml" ) -Replace ($myXML.UserIntentions.SetVariable | Where-Object { $_.name -eq "X3DCSMA_3DSWYMURL"}).value, "$base_url/3dpassport" | Out-File "UserIntentions_CODE.xml"
( Get-Content "UserIntentions_CODE.xml" ) -Replace ($myXML.UserIntentions.SetVariable | Where-Object { $_.name -eq "X3DCSMA_ENOVIAV5"}).value, "$base_url/3dpassport" | Out-File "UserIntentions_CODE.xml"
( Get-Content "UserIntentions_CODE.xml" ) -Replace ($myXML.UserIntentions.SetVariable | Where-Object { $_.name -eq "X3DCSMA_3DCommentURL"}).value, "$base_url/3dpassport" | Out-File "UserIntentions_CODE.xml"
( Get-Content "UserIntentions_CODE.xml" ) -Replace ($myXML.UserIntentions.SetVariable | Where-Object { $_.name -eq "X3DCSMA_3DNotificationURL"}).value, "$base_url/3dpassport" | Out-File "UserIntentions_CODE.xml"
( Get-Content "UserIntentions_CODE.xml" ) -Replace ($myXML.UserIntentions.SetVariable | Where-Object { $_.name -eq "X3DCSMA_SMTP_HOST"}).value, "$smtp_host" | Out-File "UserIntentions_CODE.xml"
( Get-Content "UserIntentions_CODE.xml" ) -Replace ($myXML.UserIntentions.SetVariable | Where-Object { $_.name -eq "X3DCSMA_SMTP_MAIL_SENDER"}).value, "$base_url/3dpassport" | Out-File "UserIntentions_CODE.xml"
( Get-Content "UserIntentions_CODE.xml" ) -Replace ($myXML.UserIntentions.SetVariable | Where-Object { $_.name -eq "X3DCSMA_portCAS"}).value, "8089" | Out-File "UserIntentions_CODE.xml"
( Get-Content "UserIntentions_CODE.xml" ) -Replace ($myXML.UserIntentions.SetVariable | Where-Object { $_.name -eq "TARGET_PATH"}).value, "https://bhpvmwx.dsone.3ds.com/3dpassport" | Out-File "UserIntentions_CODE.xml"



#Write-Output ($myXML | Select-Xml -XPath "//SetVariable[name= 'X3DCSMA_3DPassportURL']").Node.value 
Write-Output ($myXML.UserIntentions.SetVariable | Where-Object { $_.value -eq "D:\dsplm\product\3dexperience\3DSpace\3dspacedata"}).name