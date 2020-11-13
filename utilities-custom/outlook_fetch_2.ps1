$o = New-Object -comobject outlook.application
$n = $o.GetNamespace("MAPI")

$f = $n.PickFolder('Jenkins')

#$filepath = "e:\output\"

foreach ($item in $f.items) {
    $sender = $item.SenderName
    foreach($attach in $item.Attachments){
        if($attach.filename.contains("log")) {
            write-host "$sender sent $($attach.filename)"
        }
    }
}