
$o = New-Object -comobject outlook.application
$n = $o.GetNamespace("MAPI")

$f = $n.PickFolder()
#$f = 'Jenkins'
$i=0
$filepath = "e:\output\"
$f.Items | ForEach-Object {
    $SendName = $_.SenderName
    $timeStamp = [String]($_.SentOn)
    $timeStamp = $timeStamp.Replace('/', '-')
    $timeStamp = $timeStamp.Replace(':', '-')
    $timeStamp = $timeStamp.Replace(' ', '_')
    $Recipient = $_.To
    Write-Output "----------------------------------------------------------"
    Write-Output $_.SentOn "Sender: $SendName" "Recipient: $Recipient"
    $_.attachments | ForEach-Object {
        Write-Output $_.filename
        $a = $_.filename
        
        If ($a.Contains("log")) {
            #$rd = Get-Random -Maximum 100   
            $_.saveasfile((Join-Path $filepath "$timeStamp-$i.log"))
            $i=$i+1
    }
  }
}