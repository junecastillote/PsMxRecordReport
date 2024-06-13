Function Get-MxRecord {
    [cmdletbinding()]
    param (
        [parameter(Mandatory)]
        [string[]]
        $Domain,

        [parameter()]
        [string[]]
        $ExcludeDomain,

        [parameter()]
        [string[]]
        $NameServer
    )

    if (!$NameServer) {
        $DNSServer = 'Computer Default'
    }
    else {
        $DNSServer = ($NameServer -join ',')
    }

    $finalResult = @()

    foreach ($iDomain in ($Domain | Sort-Object)) {
        ## Check if domain is excluded
        if ($ExcludeDomain -contains $iDomain) {
            Write-Information "$(Get-Date -Format 'yyyy-MMM-dd hh:mm:ss tt') : $($iDomain) --> EXCLUDE"
        }

        # If domain is not excluded
        if ($ExcludeDomain -notcontains $iDomain ) {
            ## Build DNS Query Parameters
            $queryParams = @{
                name        = $iDomain
                type        = "MX"
                NoHostsFile = $true
                DnsOnly     = $true
            }
            ## If NameServer parameter value is present
            if ($nameServer) { $queryParams += @{Server = $nameServer } }

            ## Try to resolve each domain's MX record
            ## If DNS record resolution passed
            try {
                $mxRecords = Resolve-DnsName @queryParams -ErrorAction Stop | Where-Object { $_.QueryType -eq "MX" } | Sort-Object -Property Preference
                if ($mxRecords) {
                    foreach ($mxRecord in $mxRecords) {
                        $temp = [pscustomobject][ordered]@{
                            PSTypeName   = 'LazyExchangeAdmin.PSMXRecord'
                            Name         = $iDomain
                            NameExchange = $mxRecord.NameExchange
                            Preference   = $mxRecord.Preference
                            IPAddress    = ((Resolve-DnsName ($mxRecord.NameExchange) -ErrorAction SilentlyContinue).IPAddress | Where-Object { $_ -notmatch ":" }) -join ","
                            NameServer   = $DNSServer
                            Status       = 'Pass'
                            Error        = ''
                        }
                        $finalResult += $temp
                    }
                    Write-Information "$(Get-Date -Format 'yyyy-MMM-dd hh:mm:ss tt') : $($iDomain) --> PASS"
                }
                else {
                    $temp = [pscustomobject][ordered]@{
                        PSTypeName   = 'LazyExchangeAdmin.PSMXRecord'
                        Name         = $iDomain
                        NameExchange = ''
                        Preference   = ''
                        IPAddress    = ''
                        NameServer   = $DNSServer
                        Status       = 'Fail'
                        Error        = "The domain exists but without an MX record"
                    }
                    $finalResult += $temp
                    Write-Information "$(Get-Date -Format 'yyyy-MMM-dd hh:mm:ss tt') : $($iDomain) --> FAIL"
                }
            }
            ## If DNS record resolution failed
            Catch {
                $temp = [pscustomobject][ordered]@{
                    PSTypeName   = 'LazyExchangeAdmin.PSMXRecord'
                    Name         = $iDomain
                    NameExchange = ''
                    Preference   = ''
                    IPAddress    = ''
                    NameServer   = $DNSServer
                    Status       = 'Fail'
                    Error        = $_.Exception.Message
                }
                $finalResult += $temp
                Write-Information "$(Get-Date -Format 'yyyy-MMM-dd hh:mm:ss tt') : $($iDomain) --> FAIL"
            }
        }
    }
    return $finalResult
}