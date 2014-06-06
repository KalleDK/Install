param(
    [switch]$IsRunAsAdmin = $false
)

# Get our script path
$ScriptPath = (Get-Variable MyInvocation).Value.MyCommand.Path

#
# Launches an elevated process running the current script to perform tasks
# that require administrative privileges.  This function waits until the
# elevated process terminates.
#
function LaunchElevated
{
    # Set up command line arguments to the elevated process
    $RelaunchArgs = '-ExecutionPolicy Unrestricted -file "' + $ScriptPath + '" -IsRunAsAdmin'

    # Launch the process and wait for it to finish
    try
    {
        $AdminProcess = Start-Process "$PsHome\PowerShell.exe" -Verb RunAs -ArgumentList $RelaunchArgs -PassThru
    }
    catch
    {
        $Error[0] # Dump details about the last error
        exit 1
    }

    # Wait until the elevated process terminates
    while (!($AdminProcess.HasExited))
    {
        Start-Sleep -Seconds 2
    }
}

function DoElevatedOperations
{
    New-Item -ItemType Directory -Force -Path "$((Get-Item "Env:ProgramFiles(x86)").Value)\Putty\"

	# Download Putty
	$download = "http://the.earth.li/~sgtatham/putty/latest/x86/putty.exe"
	$location = "$((Get-Item "Env:ProgramFiles(x86)").Value)\Putty\putty.exe"
	(new-object Net.WebClient).DownloadFile($download,$location)

	# Download Plink
	$download = "http://the.earth.li/~sgtatham/putty/latest/x86/plink.exe"
	$location = "$((Get-Item "Env:ProgramFiles(x86)").Value)\Putty\plink.exe"
	(new-object Net.WebClient).DownloadFile($download,$location)

	# Download Pageant
	$download = "http://the.earth.li/~sgtatham/putty/latest/x86/pageant.exe"
	$location = "$((Get-Item "Env:ProgramFiles(x86)").Value)\Putty\pageant.exe"
	(new-object Net.WebClient).DownloadFile($download,$location)

}

function DoStandardOperations
{
	LaunchElevated

    # Add Plink to GIT_SSH
	$bingit = "`r`n"+'$env:GIT_SSH=(Get-Item "Env:ProgramFiles(x86)").Value + "\Putty\plink.exe"'
	echo $bingit | Out-File -encoding ASCII C:\Users\$env:username\Documents\WindowsPowerShell\Microsoft.Powershell_profile.ps1 -Append

	# Start Putty and login to Github
	$PuttyProcess = Start-Process "$((Get-Item "Env:ProgramFiles(x86)").Value)\Putty\putty.exe" -ArgumentList "git@github.com"
	while (!($PuttyProcess.HasExited))
	{
		Start-Sleep -Seconds 2
	}
	
	# Getting Path to RSA file
	$RSA = Read-Host 'Path to RSA?'

	# Start Page Ant
	start "$((Get-Item "Env:ProgramFiles(x86)").Value)\Putty\pageant.exe" $RSA
	
	start "C:\Users\$env:username\Documents\WindowsPowerShell\Microsoft.Powershell_profile.ps1"
  
}


#
# Main script entry point
#

if ($IsRunAsAdmin)
{
    DoElevatedOperations
}
else
{
    DoStandardOperations
}