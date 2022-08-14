# Originally Created for Azure File Shares
Add-Type -AssemblyName System.Web
$key = "<your access key>" # this is one of the "access keys" from the storage account page. No decoding required.

$signedPermissions = "rl"
$signedStart = "2022-08-14T05:00:00Z"
$signedExpiry = "2040-08-14T05:00:00Z"
$canonicalizedResource = "/file/myshare/pictures"
$signedIdentifier = ""
$signedIP = ""
$signedProtocol = ""
$signedVersion = "2021-04-10"
$signedResource = "s"
$signedSnapshotTime = ""
$signedEncryptionScope = ""
$rscc = ""
$rscd = ""
$rsce = ""
$rscl = ""
$rsct = "image/jpeg" # return image content-type so the browser doesn't attempt to download the file (defaults to returning octet-stream)

$stringToSign = $signedPermissions + "`n"
$stringToSign += $signedStart + "`n"
$stringToSign += $signedExpiry + "`n"
$stringToSign += $canonicalizedResource + "`n"
$stringToSign += $signedIdentifier + "`n"
$stringToSign += $signedIP + "`n"
$stringToSign += $signedProtocol + "`n"
$stringToSign += $signedVersion + "`n"
#$stringToSign += $signedResource + "`n"           # exclude this from signing
#$stringToSign += $signedSnapshotTime + "`n"       # exclude this from signing
#$stringToSign += $signedEncryptionScope + "`n"    # exclude this from signing
$stringToSign += $rscc + "`n"
$stringToSign += $rscd + "`n"
$stringToSign += $rsce + "`n"
$stringToSign += $rscl + "`n"
$stringToSign += $rsct
    
$stringToSign = [System.Web.HttpUtility]::UrlDecode($stringToSign)

#Generate the signature
$hmacsha = New-Object System.Security.Cryptography.HMACSHA256
$hmacsha.key = [System.Convert]::FromBase64String($key)

$signature = $hmacsha.ComputeHash([Text.Encoding]::ASCII.GetBytes($stringToSign))
$signature = [Convert]::ToBase64String($signature)

$url = "https://myshare.file.core.windows.net/pictures/0000000007.jpg?"
$url += "&sv=" + $signedVersion
$url += "&st=" + $signedStart
$url += "&se=" + $signedExpiry
$url += "&sr=" + $signedResource
$url += "&sp=" + $signedPermissions
$url += "&rsct=" + $rsct
$url += "&sig=" + [System.Web.HttpUtility]::UrlEncode($signature)

$url



