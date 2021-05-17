# PsMxRecordReport PowerShell Module <!-- omit in toc -->

[![GitHub issues](https://img.shields.io/github/issues/junecastillote/PsMxRecordReport)](https://github.com/junecastillote/PsMxRecordReport/issues)

[![GitHub forks](https://img.shields.io/github/forks/junecastillote/PsMxRecordReport)](https://github.com/junecastillote/PsMxRecordReport/network)

[![GitHub license](https://img.shields.io/github/license/junecastillote/PsMxRecordReport)](https://github.com/junecastillote/PsMxRecordReport/blob/main/LICENSE)

- [Overview](#overview)
- [Requirement](#requirement)
- [Getting The Module](#getting-the-module)
- [Included Functions](#included-functions)
  - [Get-MxRecord](#get-mxrecord)

## Overview

If you manage an email organization, one of the important configuration items you need to monitor is your organization's MX records. Missing or problematic MX records result in email deliverability problems.

This PowerShell module can help you setup a regular MX record lookup interval. You can choose to save the results to file (CSV) and/or create a pre-formatted HTML report. Depending on your requirement, you can also use the HTML output as an email report.

## Requirement

There are no special requirements to run this module. You only need Windows PowerShell 5.1 or [PowerShell 7](https://github.com/PowerShell/powershell/releases/latest).

## Getting The Module

Similar to any GitHub sources, you can choose among these options:

- [Clone](https://docs.github.com/en/github/creating-cloning-and-archiving-repositories/cloning-a-repository) the [PsMxRecordReport](https://github.com/junecastillote/Ms365UsageReport) repository.
- [Download the module](https://github.com/junecastillote/Ms365UsageReport/archive/refs/heads/main.zip) as a Zip file.

## Included Functions

### Get-MxRecord

```PowerShell
Get-MxRecord
    [-Domain] <string[]>
    [[-ExcludeDomain] <string[]>]
    [[-NameServer] <string[]>]
    [<CommonParameters>]
```
