
#Download putty.ps1
$download = "https://raw.githubusercontent.com/KalleDK/Install/master/putty.ps1"
$location = $tempFile = [IO.Path]::GetTempFileName() + ".ps1"
(new-object Net.WebClient).DownloadFile($download,$location)
$putty = Start-Process "$PsHome\PowerShell.exe" $location
 while (!($putty.HasExited))
 {
	Start-Sleep -Seconds 2
}
Remove-Item $location