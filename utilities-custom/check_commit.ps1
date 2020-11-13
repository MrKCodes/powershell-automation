<#
    Current logs directory : e:\output
    


#>
Param(
        [string]$logpath='e:\output'

)
$pwp=Get-Location

Set-Location $logpath

Set-Location E:\output

foreach ($logfile in ( Get-ChildItem -Path $logpath)){
    Write-Output ""
    Write-Output "----Checking File : $logfile"
    #$line_n = 0
    #$flag = 0
    foreach ($line in ( Get-Content $logfile)) {
        iF ( $line.contains('New build name is') ){
            $build_name = $line.Substring( $line.IndexOf('#'), $line.Length-$line.IndexOf('#') )
            Write-Output "Build Name : $build_name"
        } 
        if ( $line.contains('GIT_AUTHOR_EMAIL')){
            $commit = $line.Substring( $line.IndexOf('GIT_AUTHOR_EMAIL'),($line.IndexOf('@')-1) )
            Write-Output "$commit'"
        }
        #$line_n = $line_n + 1
      
     }
}

Set-Location $pwp

