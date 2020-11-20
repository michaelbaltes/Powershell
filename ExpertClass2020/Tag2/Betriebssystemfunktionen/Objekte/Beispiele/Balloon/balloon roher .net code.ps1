
	Add-Type -AssemblyName 'System.Windows.Forms'
	Add-Type -AssemblyName 'System.Drawing'
	
	$writeBalloonTipIcon = new-object System.Windows.Forms.NotifyIcon
	$writeBalloonTipIcon.Icon = [System.Drawing.SystemIcons]::Information
	$writeBalloonTipIcon.Visible = $true
	$writeBalloonTipIcon.ShowBalloonTip(10, 'Huch!', 'Umstieg von Win7 nicht vergessen!', 'Info')





