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

Set-Location d:\
