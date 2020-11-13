<#
    Current logs directory : e:\output
    


#>
Param(
        [string]$logpath='e:\output'

)
$pwp=Get-Location

Set-Location $logpath

foreach ($logfile in ( Get-ChildItem -Path $logpath)){
    Write-Output "----Checking File : $logfile"
    $line_n = 0
    $flag = 0
    foreach ($line in ( Get-Content $logfile)) {
        if ( $line.contains('ERROR')){
            $flag = 1
            #$err=$line.Substring(0,65)
            if ( $line.Length -le 70) {
                $err=$line.Substring(0,$line.Length)
                Write-Output "Error at $line_n : ---$err ......."
            }
            else {
                $err=$line.Substring(0,70)
                Write-Output "Error at $line_n : ---$err ......."
            }
        }
        $line_n = $line_n + 1
      
     }
        if ($flag -eq 0) {
            Write-Output "      No Errors" 
        }
        
}
Set-Location -Path $pwp



