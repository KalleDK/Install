Install
=======

PowerShell as Administrator

    Set-ExecutionPolicy RemoteSigned
    
PowerShell as User

    (new-object Net.WebClient).DownloadString("https://raw.githubusercontent.com/KalleDK/Install/master/bootstrap.ps1") | iex
