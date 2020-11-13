<#
.Synopsis
This enables to check the hash value of the all the files present
In short, it checks if all the files are of same version or not.
.Description
This script takes the filename as parameter and check all the occurence of that file in 3dspace directory.
.Parameter filename
hashCheck.ps1 -filename <name of the file>
.Example
hashCheck.ps1 -filename BHPConstant.jar

#>


Param(
    [Parameter(Mandatory=$true)]
    [string]$filename
    )

Get-ChildItem -Path d:\ds\3ds -Recurse -Filter $filename -file | Get-FileHash