Function Write-MxRecordReport {
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline
        )]
        [PSTypeNameAttribute('LazyExchangeAdmin.PSMXRecord')]
        $InputObject,

        [Parameter()]
        [String]
        $Title = 'MX Record Validity Report',

        # Parameter help description
        [Parameter()]
        [ValidateSet('All', 'Fail', 'Pass')]
        [string]
        $ReportType = 'All'
    )
    begin {
        $ModuleInfo = Get-Module PSMXRecordReport
        $css_string = Get-Content (($ModuleInfo.ModuleBase.ToString()) + '\source\style.css') -Raw
        $now = (Get-Date -Format ("yyyy-MMM-dd hh:mm tt")) + " " + (Get-TimeZone).ToString().Split(" ")[0]
        $temp = @()
    }
    process {
        $temp += $InputObject
    }
    end {
        $failedResults = $temp | Where-Object { $_.Status -eq "Fail" }
        $passedResults = $temp | Where-Object { $_.Status -eq "Pass" } | Group-Object Name

        ## Heading
        $HtmlBody = "<html><head><title>$($Title)</title><meta http-equiv=""Content-Type"" content=""text/html; charset=ISO-8859-1"" /><style type=""text/css"">$($css_string) </style></head>"
        $HtmlBody += "<hr>"
        $HtmlBody += '<table id="HeadingInfo">'
        $HtmlBody += "<tr><th>$($Title)<br />$($now)</th></tr>"
        $HtmlBody += "</table>"
        $HtmlBody += "<hr>"

        $TempHtmlBody = @()

        ## Failed Results
        if ($ReportType -eq 'Fail' -or $ReportType -eq 'All') {
            if ($failedResults) {
                $TempHtmlBody += '<table id="SectionLabels"><tr><th class="data">Failed MX Record Lookup</th></tr></table>'
                $TempHtmlBody += '<table id="data">'
                $TempHtmlBody += "<tr><th>Domain</th><th>Error</th></tr>"
                foreach ($result in $failedResults) {
                    $TempHtmlBody += "<tr><td>$($result.Name)</td><td class = ""bad"">$($result.error) <a href=https://intodns.com/$($result.Name) target=""_blank""> > Analyze</a></td></tr>"
                }
                $TempHtmlBody += '</table>'
            }
        }

        if ($ReportType -eq 'Pass' -or $ReportType -eq 'All') {
            ## Passed Results
            if ($passedResults) {
                $TempHtmlBody += '<table id="SectionLabels"><tr><th class="data">Successful MX Record Lookup</th></tr></table>'
                $TempHtmlBody += '<table id="data">'
                $TempHtmlBody += "<tr><th>Domain</th><th>Mail Exchange | Preference</th></tr>"
                foreach ($result in $passedResults) {
                    $mx = @()
                    foreach ($item in $result.Group) {
                        $mx += "$($item.NameExchange) | $($item.Preference)"
                    }
                    $TempHtmlBody += "<tr><td>$($result.Name)</td><td>" + ($mx -join "<br />") + "</td></tr>"
                }
                $TempHtmlBody += '</table>'
            }
        }

        if ($TempHtmlBody.Count -eq 0) {
            return $null
        }

        $HtmlBody += $TempHtmlBody
        $HtmlBody += "<hr>"
        $HtmlBody += '<p><table id="SectionLabels">'
        $HtmlBody += '<tr><th>----END of REPORT----</th></tr></table></p>'
        $HtmlBody += '<p><font size="2" face="Tahoma"><b>[SETTINGS]</b><br />'
        $HtmlBody += 'DNS Server: ' + ($InputObject[0].NameServer) + '<br />'
        $HtmlBody += 'Report Host: ' + $env:COMPUTERNAME + '<br />'
        $HtmlBody += 'Report Type: ' + ($ReportType) + '<br />'
        $HtmlBody += '</p><p>'
        $HtmlBody += "<a href=""$($ModuleInfo.ProjectURI)"">$($ModuleInfo.Name) v$($ModuleInfo.version)</a></p>"
        $HtmlBody += '</body></html>'
        return ($HtmlBody -join "`n")
        [System.GC]::Collect()
    }
}