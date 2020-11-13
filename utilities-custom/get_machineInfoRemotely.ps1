#$ComputersList = Get-Content "D:\ds\admin\Rohit\PowerShell\ListOfMachines.txt"
#$ComputersList = Get-Content "D:\ds\admin\Rohit\PowerShell\ListOfPCSIntMachines.txt"
$ComputersList = Get-Content "D:\ds\admin\Rohit\PowerShell\ListOfCICDMachines.txt"
$csvfile = "D:\ds\admin\Rohit\PowerShell\Test.csv"

# Delete Csv report if it already exists
if (Test-Path -Path $csvfile) {
	Remove-Item $csvfile
}

# Generate a new Csv report
foreach ($computer in $ComputersList) {
	
	Write-Output $computer
	
	$Val=systeminfo /s $computer /fo csv | ConvertFrom-Csv | select OS*, System*, Host*, Domain*, Network*, "Total Physical Memory", "Available Physical Memory", "Virtual Memory*"
	
	# 1. Computer name
	$ComputerNameValue=($Val.PSObject.Properties | where-object {$_.name -eq "Host Name"}).Value

	# 2. Domain name
	$DomainNameValue=($Val.PSObject.Properties | where-object {$_.name -eq "Domain"}).Value

	# 3. FQDN for computer
	$ComputerFQDN=$ComputerNameValue+"."+$DomainNameValue

	# 4. IP Address
	$IpAddressArrValue=Invoke-Command -ComputerName $computer -ScriptBlock { ((Get-NetIPConfiguration | Where-Object InterfaceAlias -eq "ETHERNET").IPv4Address).IPAddress }
	#([System.Net.Dns]::GetHostAddresses($computer)).IPAddressToString
		
	# 5. OS Name
	$OS_Name=($Val.PSObject.Properties | where-object {$_.name -eq "OS Name"}).Value
	
	
	# 6. OS Version
	$OS_Version=($Val.PSObject.Properties | where-object {$_.name -eq "OS Version"}).Value
	
	# 7. System Manufacturer
	$Sys_Manufacturer=($Val.PSObject.Properties | where-object {$_.name -eq "System Manufacturer"}).Value
	
	# 8. System Model
	$Sys_Model=($Val.PSObject.Properties | where-object {$_.name -eq "System Model"}).Value
	
	# 9. System Type
	$Sys_Type=($Val.PSObject.Properties | where-object {$_.name -eq "System Type"}).Value
	
	# 10. Total Physical Memory
	$TotalPhysicalMemory=($Val.PSObject.Properties | where-object {$_.name -eq "Total Physical Memory"}).Value
	
	
	# 11. Available Physical Memory
	$AvailablePhysicalMemory=($Val.PSObject.Properties | where-object {$_.name -eq "Available Physical Memory"}).Value
	
	# 12. Total Virtual Memory
	$VirtualMemoryMaxSize=($Val.PSObject.Properties | where-object {$_.name -eq "Virtual Memory: Max Size"}).Value
	
	# 13. Available Virtual Memory
	$VirtualMemoryAvailable=($Val.PSObject.Properties | where-object {$_.name -eq "Virtual Memory: Available"}).Value
	
	# 14. Virtual Memory In Use
	$VirtualMemoryMaxInUse=($Val.PSObject.Properties | where-object {$_.name -eq "Virtual Memory: In Use"}).Value
	
	# 15. Total size of c: drive
	$C_Drive_TotalSize=(Get-WmiObject Win32_LogicalDisk -ComputerName $computer | where-object {$_.DeviceID -eq "C:"}).Size
	$C_Drive_TotalSize=$C_Drive_TotalSize/1GB
	$C_Drive_TotalSize=($C_Drive_TotalSize).ToString()+ " GB"


	# 16. Free space in c: drive
	$C_Drive_FreeSpace=(Get-WmiObject Win32_LogicalDisk -ComputerName $computer | where-object {$_.DeviceID -eq "C:"}).FreeSpace
	$C_Drive_FreeSpace=$C_Drive_FreeSpace/1GB
	$C_Drive_FreeSpace=($C_Drive_FreeSpace).ToString()+ " GB"

	# 17. Total size of D: drive
	$D_Drive_TotalSize=(Get-WmiObject Win32_LogicalDisk -ComputerName $computer | where-object {$_.DeviceID -eq "D:"}).Size
	$D_Drive_TotalSize=$D_Drive_TotalSize/1GB
	$D_Drive_TotalSize=($D_Drive_TotalSize).ToString()+ " GB"
	
	# 18. Free space in D: drive
	$D_Drive_FreeSpace=(Get-WmiObject Win32_LogicalDisk -ComputerName $computer | where-object {$_.DeviceID -eq "D:"}).FreeSpace
	$D_Drive_FreeSpace=$D_Drive_FreeSpace/1GB
	$D_Drive_FreeSpace=($D_Drive_FreeSpace).ToString()+ " GB"
	
	
	# 19. Total number of processors and 20. processor name
	$Processors=Get-WmiObject -ComputerName $computer -Class Win32_Processor | Select -Property Name
	$ProCount=0
	$ProName=""
	foreach ($Processor in $Processors){
		$ProCount=$ProCount+1
		$ProName=$Processor.Name;
	}
	
	# 21. Total number of cores
	$Cores=Get-WmiObject -ComputerName $computer -Class Win32_Processor | Select -Property NumberOfCores
	$CoresCount=0
	foreach ($Core in $Cores){
		$CoresCount=$CoresCount+1
	}
	
	# 22. Total number of Logical processors
	$LogicalProcessors=Get-WmiObject -ComputerName $computer -Class Win32_Processor | Select -Property NumberOfLogicalProcessors
	$LogProCount=0
	foreach ($LogicalProcessor in $LogicalProcessors){
		$LogProCount=$LogProCount+1
	}

		
	#echo $ComputerNameValue $DomainNameValue $ComputerFQDN $IpAddressArrValue $OS_Name 
	#echo $OS_Version $Sys_Manufacturer $Sys_Model $Sys_Type $TotalPhysicalMemory 
	#echo $AvailablePhysicalMemory $VirtualMemoryMaxSize $VirtualMemoryAvailable $VirtualMemoryMaxInUse $C_Drive_TotalSize
	#echo $C_Drive_FreeSpace $D_Drive_TotalSize $D_Drive_FreeSpace $ProCount $ProName
	#echo $CoresCount $LogProCount
	
	$properties = [ordered]@{
	
		ComputerName=$ComputerNameValue
		DomainName=$DomainNameValue
		ComputerFQDN=$ComputerFQDN
		IpAddressArrValue=$IpAddressArrValue
		OS_Name=$OS_Name

		OS_Version=$OS_Version
		System_Manufacturer=$Sys_Manufacturer
		System_Model=$Sys_Model
		System_Type=$Sys_Type
		Total_Physical_Memory=$TotalPhysicalMemory
		
		Available_Physical_Memory=$AvailablePhysicalMemory
		Virtual_Memory_MaxSize=$VirtualMemoryMaxSize
		Virtual_Memory_Available=$VirtualMemoryAvailable
		Virtual_Memory_InUse=$VirtualMemoryMaxInUse
		C_Drive_TotalSize=$C_Drive_TotalSize
		
		C_Drive_FreeSpace=$C_Drive_FreeSpace
		D_Drive_TotalSize=$D_Drive_TotalSize
		D_Drive_FreeSpace=$D_Drive_FreeSpace
		Total_Num_Processors=$ProCount
		Processor_Name=$ProName;
		
		Total_Num_Cores=$CoresCount
		Total_Num_Logical_Processors=$LogProCount
	}
	$o = New-Object psobject -Property $properties;

	if (Test-Path -Path $csvfile) {
	write-host "CSV file is already created we have to append object"
	Export-Csv $csvfile -inputobject $o -append -Force
	}
	else
	{
		write-host "Creating a new CSV file"
		$o | Export-Csv -Path $csvfile -NoTypeInformation
	}	
}

$Header = @"
<style>
{
  font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
  border-collapse: collapse;
  width: 100%;
}

td, th {
  border: 1px solid #ddd;
  padding: 8px;
}

tr:nth-child(even){background-color: #f2f2f2;}

tr:hover {background-color: #ddd;}

th {
  padding-top: 12px;
  padding-bottom: 12px;
  text-align: left;
  background-color: #20B2AA;
  color: white;
}
</style>
"@

#Get-PSDrive | ConvertTo-Html -Property Name,Used,Provider,Root,CurrentLocation -Head $Header | Out-File -FilePath PSDrives.html
Import-Csv $csvfile | ConvertTo-Html -Head $Header | Out-File -FilePath "D:\ds\admin\Rohit\PowerShell\Test.html"
