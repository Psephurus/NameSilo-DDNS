# NameSilo DDNS PowerShell script

# Domain name and API key variables
$config = Get-Content -Raw -Path "conf\config.json" | ConvertFrom-Json
$APIkey = $config.APIkey
$domain = $config.domain
$record = $config.record

function Get-IPAddress {
    # Get IPv6 address for Ethernet interface (if available)
    $ethernetIP = Get-NetIPAddress -AddressFamily IPv6 |
        Where-Object {
            $_.InterfaceAlias -like '*Ethernet*' -or
            $_.InterfaceAlias -like '*以太网*' -or
            $_.InterfaceAlias -like '*이더넷*'
        } |
        Select-Object -Last 1 -ErrorAction SilentlyContinue

    # Get IPv6 address for WLAN interface
    $wlanIP = Get-NetIPAddress -AddressFamily IPv6 |
               Where-Object {
                   $_.InterfaceAlias -like '*WLAN*' -and
                   $_.SuffixOrigin -eq 'Link' -or
                   $_.InterfaceAlias -like '*Wi-Fi*'
                } |
               Select-Object -Last 1 -ErrorAction SilentlyContinue

    # Check if Ethernet IPv6 address is available
    if ($ethernetIP.IPAddress -and $ethernetIP.IPAddress -notlike "fe80::*") {
        Write-Output $ethernetIP.IPAddress
    }
    # Check if WLAN IPv6 address is available
    elseif (
        $wlanIP.IPAddress -and 
        ($wlanIP.IPAddress -notlike "127.*" -and 
         $wlanIP.IPAddress -notlike "10.*" -and 
         $wlanIP.IPAddress -notlike "192.168.*")
    ) {
        Write-Output $wlanIP.IPAddress
    }
}

# Get IP address
$listdomains = Invoke-RestMethod -Uri `
    "https://www.namesilo.com/api/dnsListRecords?version=1&type=xml&key=$APIkey&domain=$domain"
$CurrentIP = Get-IPAddress
$RecordIP = $listdomains.namesilo.reply.resource_record |
    Where-Object { $_.host -eq "$record.$domain" } |
    Select-Object -ExpandProperty value
$RecordID = $listdomains.namesilo.reply.resource_record |
    Where-Object { $_.host -eq "$record.$domain" } |
    Select-Object -ExpandProperty record_id
$listdomains.namesilo.reply

# Update IP address
if ($CurrentIP -ne $RecordIP){
    $rrttl = $config.ttl # TTL Time
    $updateUri = "https://www.namesilo.com/api/dnsUpdateRecord?version=1&type=xml" +
        "&key=$APIkey" +
        "&domain=$Domain" +
        "&rrid=$RecordID" +
        "&rrhost=$record" +
        "&rrvalue=$CurrentIP" +
        "&rrttl=$rrttl"
    $update = Invoke-RestMethod -Uri $updateUri

    $update.namesilo.reply
}
