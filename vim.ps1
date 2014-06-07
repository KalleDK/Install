echo "Adding VIM Profile"
$line = ""
echo $line | Out-File -encoding ASCII $PROFILE -Append
$line = "" + '#Vim Alias'
echo $line | Out-File -encoding ASCII $PROFILE -Append
$line = "" + '$VIMPATH    =  (Get-Item "Env:ProgramFiles(x86)").Value + "\Vim\vim74\vim.exe"'
echo $line | Out-File -encoding ASCII $PROFILE -Append
$line = "" + 'Set-Alias vi   $VIMPATH'
echo $line | Out-File -encoding ASCII $PROFILE -Append
$line = "" + 'Set-Alias vim  $VIMPATH'
echo $line | Out-File -encoding ASCII $PROFILE -Append
