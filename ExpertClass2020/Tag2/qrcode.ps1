
Install-Module -name qrcodegenerator -Scope CurrentUser -Force

New-QRCodeWifiAccess -SSID internetcafe -Password topsecret -Show
New-PSOneQRCodeGeolocation -Address 'Jonathanweg, Hannover' -Show
New-PSOneQRCodeVCard