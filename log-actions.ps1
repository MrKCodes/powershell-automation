<#
    this script will have multiple functions:
    one will delete all the older logs
    other will find the erros and print the line as well as the error description

#>



# Function 1 - Delete-Log   - delete log older than 7 days


function Delete-Logs {
    param (
        # Parameter help description
        [Parameter()]
        [string] $Directory
    )
    
    Get-ChildItem $Directory -Force -ea 0 |
    ? { $_.LastWriteTime -lt (Get-Date).AddDays(-7)} |
    ForEach-Object {
        $_ | del -Force
        $_.FullName | Out-File .\deletelog.txt -Append
    }
}