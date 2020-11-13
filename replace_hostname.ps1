$list = Get-ChildItem -Path 'D:\ds\install\GA.RESPONSE'
Set-Location -Path 'D:\ds\install\GA.RESPONSE'

foreach ( $file in $list) {
    ( Get-Content -Path $file ) -replace 'apac.ent.bhpbilliton.net' , 'dsone.3ds.com' | Out-File -FilePath $file

}