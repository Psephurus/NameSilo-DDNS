# NameSilo DDNS PowerShell

# 域名与API信息
$APIkey = "n0d1vn2v2aaetfudk0a12t”
$domain = "mydomain.xyz"
$record = "subdomain"

# 获取IP位址
$listdomains = irm -Uri "https://www.namesilo.com/api/dnsListRecords?version=1&type=xml&key=$APIkey&domain=$domain"
$CurrentIP = (ipconfig|findstr "IPv6")[0].split()[-1]
$RecordIP = ($listdomains.namesilo.reply.resource_record|where {$_.host -eq "$record.$domain"}).value
$RecordID = ($listdomains.namesilo.reply.resource_record|where {$_.host -eq "$record.$domain"}).record_id
$listdomains.namesilo.reply

# 更新IP位址
if ($CurrentIP -ne $RecordIP){
$update = irm -Uri "https://www.namesilo.com/api/dnsUpdateRecord?version=1&type=xml&key=$APIkey&domain=$Domain&rrid=$RecordID&rrhost=$record&rrvalue=$CurrentIP&rrttl=3600"
$update.namesilo.reply
}