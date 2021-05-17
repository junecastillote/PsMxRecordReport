# Remove Module from session
Remove-Module PSMXRecordReport -ErrorAction SilentlyContinue

# Import Local Module
Import-Module .\PSMXRecordReport.psd1

# Domain list
$domain = @('domain1','domain2','domain3','domain4','domain5')

# Get Mx Record
$MxRecord = Get-MXRecord -Domain $domain

# Write HTML report and out to file
# Report output file
# ReportType options: All (Default), Pass, Fail
$MxRecord | Write-MxRecordReport -ReportType All | Out-File "c:\temp\MxRecordRport.html"

# Send via email
# $smtpCredential = Get-Credential
$emailSplat = @{
    Subject = 'MX Record Lookup Report'
    SMTPServer = 'smtp.office365.com'
    Port = '587'
    From = 'sender@domain.com'
    To = 'recipient@domain.com'
    UseSSL = $true
    BodyAsHtml = $true
    Body = ($MxRecord | Write-MxRecordReport -ReportType All)
    Credential = $smtpCredential
}
Send-MailMessage @emailSplat