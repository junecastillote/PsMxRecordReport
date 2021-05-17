# Write-MXRecordReport

Function to convert the output of the `Get-MxRecord` cmdlet into a pre-formatted HTML report.

## Syntax

```powershell
Write-MxRecordReport
 [-InputObject] <PSMXRecord>
 [[-Title] <string>]
 [[-ReportType] <string>]
 [<CommonParameters>]
```

## Parameters

**`-InputObject`**

Accepts the The LazyExchangeAdmin.PsMxRecord object output of `Get-MxRecord`. This parameter accepts input from the pipeline.

|                             |                              |
| :-------------------------- | ---------------------------- |
| Required:                   | True                         |
| Type:                       | LazyExchangeAdmin.PsMxRecord |
| Position:                   | Named                        |
| Default value:              | None                         |
| Accept pipeline input:      | True                         |
| Accept wildcard characters: | False                        |

**`-Title`**

The HTML report title you want. If not specified, this cmdlet will use the default value for this parameter.

|                             |                                                                     |
| :-------------------------- | ------------------------------------------------------------------- |
| Required:                   | False                                                               |
| Type:                       | [String](https://docs.microsoft.com/en-us/dotnet/api/system.string) |
| Position:                   | Named                                                               |
| Default value:              | 'MX Record Validity Report'                                         |
| Accept pipeline input:      | False                                                               |
| Accept wildcard characters: | False                                                               |

**`-ReportType`**

Set of limit which results you want to report. If not specified, this cmdlet will use the default value for this parameter. The valid options are:

* Pass - Report only the successful MX record lookup results.
* Fail - Report only the failed MX record lookup results.
* All - Report both successful and failed MX record lookup results.

|                             |                                                                     |
| :-------------------------- | ------------------------------------------------------------------- |
| Required:                   | False                                                               |
| Type:                       | [String](https://docs.microsoft.com/en-us/dotnet/api/system.string) |
| Position:                   | Named                                                               |
| Default value:              | 'All'                                                               |
| Accept pipeline input:      | False                                                               |
| Accept wildcard characters: | False                                                               |

## Examples

### Example 1: Lookup MX Records And Create An HTML Report File

```PowerShell
$Domain = @('poshlab.ml','lzex.ml','noemaildomain.xyz')
Get-MxRecord -Domain $Domain | Write-MxRecordReport | Out-File .\MxRecordReport-All.html
```

Result:
![wmxr-01](.\img/wmxr-01.png)