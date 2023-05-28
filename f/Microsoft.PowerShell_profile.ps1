#requires -Modules PSReadLine, posh-git

if ($host.Name -ne 'ConsoleHost') {
  # TODO: Implement stuff we want for all hosts.
  return
}

$modules = @('PSReadLine', 'posh-git')

$modules | ForEach-Object {
  if (-not (Get-Module -ListAvailable -Name $_)) {
    Write-Host -ForegroundColor White "Installing module $_..."
    Install-Module $_ -Force -Scope CurrentUser
  }

  Write-Host -ForegroundColor White "Loading module $_..."
  Import-Module $_
}

Set-Location d:\src
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Run -Name AHK -Value "`"$env:USERPROFILE\scoop\apps\autohotkey\current\UX\AutoHotkeyUX.exe`" D:\src\p2d\.cfg\f\autohotkey.ahk" -Force
Set-PSReadLineOption -PredictionSource History
gpgconf.exe --launch gpg-agent
