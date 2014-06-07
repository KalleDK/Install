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

	echo "Creating $((Get-Item "Env:ProgramFiles(x86)").Value)\Putty\"
	New-Item -ItemType Directory -Force -Path "$((Get-Item "Env:ProgramFiles(x86)").Value)\Putty\" | out-null 

	# Download Putty
	echo "Downloading Putty"
	$download = "http://the.earth.li/~sgtatham/putty/latest/x86/putty.exe"
	$location = "$((Get-Item "Env:ProgramFiles(x86)").Value)\Putty\putty.exe"
	(new-object Net.WebClient).DownloadFile($download,$location)

	# Download Plink
	echo "Downloading Plink"
	$download = "http://the.earth.li/~sgtatham/putty/latest/x86/plink.exe"
	$location = "$((Get-Item "Env:ProgramFiles(x86)").Value)\Putty\plink.exe"
	(new-object Net.WebClient).DownloadFile($download,$location)

	# Download Pageant
	echo "Downloading Pageant"
	$download = "http://the.earth.li/~sgtatham/putty/latest/x86/pageant.exe"
	$location = "$((Get-Item "Env:ProgramFiles(x86)").Value)\Putty\pageant.exe"
	(new-object Net.WebClient).DownloadFile($download,$location)

	
	echo "Creating $((Get-Item "Env:ProgramFiles(x86)").Value)\PSbins\"
	New-Item -ItemType Directory -Force -Path "$((Get-Item "Env:ProgramFiles(x86)").Value)\PSbins\" | out-null 
	cmd /c mklink "$((Get-Item "Env:ProgramFiles(x86)").Value)\PSbins\putty.exe" "$((Get-Item "Env:ProgramFiles(x86)").Value)\Putty\putty.exe"
	cmd /c mklink "$((Get-Item "Env:ProgramFiles(x86)").Value)\PSbins\plink.exe" "$((Get-Item "Env:ProgramFiles(x86)").Value)\Putty\plink.exe"
	cmd /c mklink "$((Get-Item "Env:ProgramFiles(x86)").Value)\PSbins\pageant.exe" "$((Get-Item "Env:ProgramFiles(x86)").Value)\Putty\pageant.exe"
}

function DoStandardOperations
{
	LaunchElevated

	echo "Creating C:\Users\$env:username\Documents\WindowsPowerShell\"
	New-Item -ItemType Directory -Force -Path "C:\Users\$env:username\Documents\WindowsPowerShell\"
	
	# Add Plink to GIT_SSH
	echo "Adding Plink to GIT_SSH"
	$plink_env = "`r`n" + '$env:GIT_SSH=(Get-Item "Env:ProgramFiles(x86)").Value + "\Putty\plink.exe"'
	echo $plink_env | Out-File -encoding ASCII $PROFILE -Append

	# Start Putty and login to Github
	echo "Running Putty to cache github key"
	$PuttyProcess = Start-Process "$((Get-Item "Env:ProgramFiles(x86)").Value)\Putty\putty.exe" -ArgumentList "git@github.com"
		
	# Getting Path to RSA file
	$RSA = Read-Host 'Path to RSA?'

	# Start Page Ant
	echo "Running pageant to load key"
	start "$((Get-Item "Env:ProgramFiles(x86)").Value)\Putty\pageant.exe" $RSA
 
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
