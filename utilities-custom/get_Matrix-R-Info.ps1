$ComputersList = Get-Content "D:\ds\admin\Rohit\PowerShell\ListOfMachines.txt"
$matrixRfile = "d$\ds\3ds\MATRIX-R"
$3dxVersionfile = "d$\ds\3ds\VersionString.txt"

$csvreportfile = "D:\ds\admin\Rohit\PowerShell\Report-Matrix-R.csv"
$htmlreportfile = "D:\ds\admin\Rohit\PowerShell\Report-MATRIX-R.html"
$htmlreporttitle = "Matrix-R Information"
$ReportTitle = "Matrix-R Information"

# Delete Csv report if it already exists
if (Test-Path -Path $csvreportfile) {
	Remove-Item $csvreportfile
}

# Delete Html report if it already exists
if (Test-Path -Path $htmlreportfile) {
	Remove-Item $htmlreportfile
}

$SerialNumber="Sr.No."
$HostName="Host Name"
$3dxVersionStr="VersionString"
$username=""
$pwd=""
$connectstr=""
$Driver=""
$Encryp=""

$SerialNumberValue=1
$usernameValue=""
$pwdValue=""
$connectstrValue=""
$DriverValue=""
$EncrypValue=""

# Generate a new Csv report
foreach ($computer in $ComputersList) {
	
	# Collect data	
	
	$ComputerNameValue = (Get-WmiObject -Class Win32_ComputerSystem -ComputerName $computer).Name
	$DomainNameValue = (Get-WmiObject -Class Win32_ComputerSystem -ComputerName $computer).Domain
	$ComputerFQDN = $ComputerNameValue+"."+$DomainNameValue
	
	$3dxVersion = Get-Content "\\$computer\$3dxVersionfile" -First 1
		
	$matrixRstreamreader = New-Object System.IO.StreamReader("\\$computer\$matrixRfile")
	while (($readeachline = $matrixRstreamreader.ReadLine()) -ne $null)
	{
		$line = $readeachline.ToString();
		
		$linelength = $line.Length
		
		$Index = $line.IndexOf('=')
		
		$key = $line.Substring(0,$Index);
		#$key
		
		$strlength=$linelength-($Index+1)
		
		$value = $line.Substring(($Index+1),$strlength);	
		#$value
		
		if($key -eq "Username")
		{
			$username = "Username"
			$usernameValue = $value
		}
		
		if($key -eq "Password")
		{
			$pwd = "Password"
			$pwdValue = $value
		}
		
		if($key -eq "ConnectString")
		{
			$connectstrValue = $value
			
			$linelength = $connectstrValue.Length
					
			$Index = $connectstrValue.IndexOf('=')
					
			$strlength=$linelength-($Index+1)
					
			$value = $connectstrValue.Substring(($Index+1),$strlength);
			
			$connectstr = "ConnectString"
			$connectstrValue = $value
		}
		
		if($key -eq "Driver")
		{
			$Driver = "Driver"
			$DriverValue = $value
		}
		
		if($key -eq "EncryptionVersion")
		{	
			$Encryp = "EncryptionVersion"
			$EncrypValue = $value
		}	
	}
	$matrixRstreamreader.Dispose()

	#echo $username $pwd $connectstr $Driver $Encryp
	#echo $usernameValue $pwdValue $connectstrValue $DriverValue $EncrypValue
	
	# Manage CSV report	
	$properties = [ordered]@{
		
		$SerialNumber=$SerialNumberValue
		$HostName=$ComputerFQDN
		$3dxVersionStr=$3dxVersion	
		$username=$usernameValue
		$pwd=$pwdValue
		$connectstr=$connectstrValue
		$Driver=$DriverValue
		$Encryp=$EncrypValue

	}
	$o = New-Object psobject -Property $properties;

	if (Test-Path -Path $csvreportfile) {
	write-host "CSV file is already created we have to append object"
	Export-Csv $csvreportfile -inputobject $o -append -Force
	}
	else
	{
		write-host "Creating a new CSV file"
		$o | Export-Csv -Path $csvreportfile -NoTypeInformation
	}
	
	$SerialNumberValue=$SerialNumberValue+1
	
	$o
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

$ResultSet = Import-Csv $csvreportfile |  ConvertTo-Html -Head $Header -Title $htmlreporttitle -Body "<h1>$ReportTitle</h1>`n<h5>Updated: on $(Get-Date)</h5>"

# Add content to report
Add-Content $htmlreportfile $ResultSet

# Open report
Invoke-Item $htmlreportfile
