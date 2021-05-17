[cmdletbinding()]
param (
    [parameter(Mandatory)]
    [string[]]
    $Domain,

    [parameter()]
    [string]
    $NameServer
)

$errorFlag = $false

$finalResult = @()
foreach ($iDomain in $Domain) {

    ## Build DNS Query Parameters
    $queryParams = @{
        name = $iDomain
        type = "MX"
    }
    if ($nameServer) { $queryParams += @{Server = $nameServer } }

    ## Try to resolve each domain's MX record
    try {
        $mxRecords = Resolve-DnsName @queryParams -ErrorAction Stop | Where-Object { $_.QueryType -eq "MX" } | Sort-Object -Property Preference
        if ($mxRecords) {
            foreach ($mxRecord in $mxRecords) {

                $x = "" | Select-Object Name, NameExchange, Preference, IPAddress, Status, Error
                $x.Name = $iDomain
                $x.NameExchange = $mxRecord.NameExchange
                $x.Preference = $mxRecord.Preference
                $queryParams = @{
                    name = $mxRecord.NameExchange
                }
                if ($nameServer) { $queryParams += @{Server = $nameServer } }

                $x.IPAddress = ((Resolve-DnsName @queryParams -ErrorAction SilentlyContinue).IPAddress | Where-Object { $_ -notmatch ":" }) -join ";"
                $x.Status = "Passed"
                #$x.Error = ""
                $finalResult += $x
            }
            Write-Host (Get-Date -Format "dd-MMM-yyyy hh:mm:ss tt") ": $($iDomain): OK" -ForegroundColor Green
        }
    }
    Catch {
        $errorFlag = $true
        $x = "" | Select-Object Name, NameExchange, Preference, IPAddress, Status, Error
        $x.Name = $iDomain
        $x.NameExchange = "Error"
        $x.Preference = "Error"
        $x.IPAddress = "Error"
        $x.Status = "Failed"
        $x.Error = $_.Exception.Message
        $finalResult += $x
        Write-Host (Get-Date -Format "dd-MMM-yyyy hh:mm:ss tt") ": $($iDomain): NOT OK" -ForegroundColor Red
    }
}
return $finalResult