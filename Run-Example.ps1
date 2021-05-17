
# Remove Module from session
Remove-Module PSMXRecordReport -ErrorAction SilentlyContinue

# Import Installed Module
# Import-Module PsMxReport

# Import Local Module
Import-Module .\PSMXRecordReport.psd1

# Report output file
$ReportFile = "c:\temp\MxRecordRport.html"
# Report Type (All, PAss, Fail)
$ReportType = "Fail"

# Domain list
$domain = @('gmail.com','lzex.ml','poshlab.ml','lazyexchangeadmin.cyou','nomailrecord.xyz')

# Get MX Record and write HTML report
Get-MXRecord -Domain $domain | Write-MxRecordReport -ReportType $ReportType | Out-File $ReportFile

# Open the report
Invoke-Item $ReportFile

