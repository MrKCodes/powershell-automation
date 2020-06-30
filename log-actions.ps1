<#
    this script will have multiple functions:
    one will delete all the older logs
    other will find the erros and print the line as well as the error description

#>



# Function 1 - Delete-Log   - delete log older than 7 days
# Usage - Delete-Logs -Directory "path to logs"

function Delete-Logs {
    param (
        # Parameter help description
        [Parameter()]
        [string] $Directory
    )
    
    Get-ChildItem $Directory -Force -ea 0 |
    Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-7)} |
    ForEach-Object {
        $_ | Remove-Item -Force
        $_.FullName | Out-File .\deletelog.txt -Append
    }
}

# Another function Find-Error
# Usage - Find-Error - Directory "Path to logs"
function Find-Error {
    param (
        # Parameter help description
        [Parameter()]
        [string] $Directory
    )
    $fileList = Get-ChildItem $Directory
    $currentLocation = Get-Location

    Set-Location $Directory

    foreach ($file in $fileList){
        Write-Output "-----Checking in file $file"
        $content = Get-Content $file

        $count = 1

        foreach ($line in $content) {
            if ( $line | Select-String -Pattern "Error") {
                Write-Error ">> Error at line $count "
                Write-Error "$line"
            }
            $count = $count+1
        }
    }
    Set-Location $currentLocation
}

# Function Call

Delete-Logs -Directory "d:\ds\3ds\winb_64\tomee\logs"

Find-Error -Directory "d:\ds\3ds\winb_64\tomee\logs"
