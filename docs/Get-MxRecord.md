# Get-MxRecord <!-- omit in toc -->

Function to lookup the MX record of a domain or a collection of domains.

- [Syntax](#syntax)
- [Parameters](#parameters)
- [Inputs](#inputs)
- [Outputs](#outputs)
- [Examples](#examples)
  - [Example 1: Lookup a Single Domain Name](#example-1-lookup-a-single-domain-name)
  - [Example 2: Lookup Multiple Domain Names](#example-2-lookup-multiple-domain-names)
  - [Example 3: Lookup Using Specific DNS Servers](#example-3-lookup-using-specific-dns-servers)
  - [Example 4: Lookup Exchange Accepted Domains](#example-4-lookup-exchange-accepted-domains)
  - [Example 5: Exclude Domains From Lookup](#example-5-exclude-domains-from-lookup)

## Syntax

```PowerShell
Get-MxRecord
    [-Domain] <string[]>
    [[-ExcludeDomain] <string[]>]
    [[-NameServer] <string[]>]
    [<CommonParameters>]
```

## Parameters

**`-Domain`**

A single domain or an array of domains to lookup.

Example:

- Single - `'poshlab.ml'`
- Array - `@('poshlab.ml','lzex.ml')`

|                             |                                                              |
| :-------------------------- | ------------------------------------------------------------ |
| Required:                   | True                                                         |
| Type:                       | [String](https://docs.microsoft.com/en-us/dotnet/api/system.string) |
| Position:                   | Named                                                        |
| Default value:              | None                                                         |
| Accept pipeline input:      | False                                                        |
| Accept wildcard characters: | False                                                        |

****

**`-ExcludeDomain`**

A single domain or an array of domains to ignore from the lookup.

|                             |                                                              |
| :-------------------------- | ------------------------------------------------------------ |
| Required:                   | False                                                        |
| Type:                       | [String](https://docs.microsoft.com/en-us/dotnet/api/system.string) |
| Position:                   | Named                                                        |
| Default value:              | None                                                         |
| Accept pipeline input:      | False                                                        |
| Accept wildcard characters: | False                                                        |

**`-NameServer`**

The DNS server IP address or FQDN to use for the name lookup. If not specified, the cmdlet will use the default DNS server address on the computer.

|                             |                                                              |
| :-------------------------- | ------------------------------------------------------------ |
| Required:                   | False                                                        |
| Type:                       | [String](https://docs.microsoft.com/en-us/dotnet/api/system.string) |
| Position:                   | Named                                                        |
| Default value:              | None                                                         |
| Accept pipeline input:      | False                                                        |
| Accept wildcard characters: | False                                                        |

## Inputs

None. This cmdlet does not accept pipeline inputs.

## Outputs

- None (if there are no results).
- An object representing the MX record lookup results with object type name of `LazyExchangeAdmin.PSMXRecord`.

## Examples

### Example 1: Lookup a Single Domain Name

This command will lookup a single domain.

```powershell
Get-MxRecord -Domain poshlab.ml
```

Result:

```PowerShell
Name         : poshlab.ml
NameExchange : poshlab-ml.mail.protection.outlook.com
Preference   : 0
IPAddress    : 104.47.126.36,104.47.125.36
NameServer   : Computer Default
Status       : Pass
Error        :
```

### Example 2: Lookup Multiple Domain Names

This example will lookup multiple domain names in an array.

```powershell
$Domain = @('poshlab.ml','lzex.ml')
Get-MxRecord -Domain $Domain
```

Result:

```PowerShell
Name         : lzex.ml
NameExchange : lzex-ml.mail.protection.outlook.com
Preference   : 0
IPAddress    : 104.47.124.36,104.47.125.36
NameServer   : Computer Default
Status       : Pass
Error        :

Name         : poshlab.ml
NameExchange : poshlab-ml.mail.protection.outlook.com
Preference   : 0
IPAddress    : 104.47.126.36,104.47.125.36
NameServer   : Computer Default
Status       : Pass
Error        :
```

### Example 3: Lookup Using Specific DNS Servers

This example will lookup the domain names using the DNS server 8.8.8.8 and 8.8.4.4.

```powershell
$Domain = @('poshlab.ml','lzex.ml')
Get-MxRecord -Domain $Domain -NameServer @('8.8.8.8','8.8.4.4')
```

Result:

```PowerShell
Name         : lzex.ml
NameExchange : lzex-ml.mail.protection.outlook.com
Preference   : 0
IPAddress    : 104.47.126.36,104.47.124.36
NameServer   : 8.8.8.8,8.8.4.4
Status       : Pass
Error        :

Name         : poshlab.ml
NameExchange : poshlab-ml.mail.protection.outlook.com
Preference   : 0
IPAddress    : 104.47.125.36,104.47.126.36
NameServer   : 8.8.8.8,8.8.4.4
Status       : Pass
Error        :
```

### Example 4: Lookup Exchange Accepted Domains

This command gets the list of Exchange organization's accepted domains and perform MX record lookup.

```powershell
# Get the Exchange org's accepted domain. You must be connected to Exchange (Online/On-Prem) PowerShell to do this.
Get-MxRecord -Domain ((Get-AcceptedDomain).DomainName)

```

### Example 5: Exclude Domains From Lookup

This example performs the MX record lookup of the specified domains while ignoring one or more domains.

```PowerShell
$Domain = @('poshlab.ml','lzex.ml','lazyexchangeadmin.cyou')
Get-MxRecord -Domain $Domain -ExcludeDomain @('poshlab.ml')
```

Result:

```PowerShell
Name         : lazyexchangeadmin.cyou
NameExchange : lazyexchangeadmin-cyou.mail.protection.outlook.com
Preference   : 1
IPAddress    : 104.47.125.36,104.47.124.36
NameServer   : Computer Default
Status       : Pass
Error        :

Name         : lzex.ml
NameExchange : lzex-ml.mail.protection.outlook.com
Preference   : 0
IPAddress    : 104.47.125.36,104.47.124.36
NameServer   : Computer Default
Status       : Pass
Error        :
```

[[Back to ReadMe]](../README.md)
