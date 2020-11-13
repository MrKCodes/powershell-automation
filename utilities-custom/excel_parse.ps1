<#
    Displaying the variables from Excel sheet ( Eg. Column 1 = Column 3 )
    Still need to figure out 
#>

# COM Object for Excel -- VB Script reference
$excel_obj = New-Object -ComObject Excel.Application

# Your Excel File
$workbook = $excel_obj.Workbooks.Open("E:\VoyagerPackageVariables.xlsx")

# Sheet in your Excel file
$worksheet = $workbook.sheets.item("Sheet1")


# Mapping values from different column
foreach ($item in 3..93 ) {
    [PSCustomObject][ordered]@{
        #Name = Value
       # sno = $item
        key = $worksheet.Range("A$item").Text
        value = $worksheet.Range("C$item").Text
        #$worksheet.Range("A3").Text = $worksheet.Range("C3").Text
        
    }
}
# Closin the session to save the memory or to save powershell from crashing
$workbook.Close()
$excel_obj.Quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel_obj)