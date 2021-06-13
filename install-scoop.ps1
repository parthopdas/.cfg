if (-not $IsWindows) {
  Write-Host -ForegroundColor Red "Script must be run on windows. Quitting!"
  return
}

if (-not (Test-Path "$env:USERPROFILE/scoop/apps/scoop/current/bin/scoop.ps1")) {
  Invoke-WebRequest -useb get.scoop.sh | Invoke-Expression
}

@('7zip', 'git') | ForEach-Object { scoop install $_ }

scoop bucket add extras

$apps = @(
  'pwsh'
  , 'windows-terminal'
  , 'autohotkey'
  , 'gitextensions'
  , 'nvm'
  , 'vscode'
)

$apps | ForEach-Object { scoop install $_ }
