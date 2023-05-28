#requires -RunAsAdministrator
#requires -PSEdition Core
#requires -Version 7.1.3

<#
TODO: make it work for linux
TODO: symlinks to c:\users\partho,parthapdas, vs community vs enterprise
TODO: git-credential-manager-core
#>

$filesRoot = Join-Path $PSScriptRoot "f"
$files = @(
  #
  # Common
  #
  @{
    "name" = "PowerShell Core Profile"
    "target" = Join-Path $env:USERPROFILE "Documents/PowerShell/Microsoft.PowerShell_profile.ps1"
    "platform" = "all"
  },
  @{
    "name" = "Git settings"
    "target" = Join-Path $env:USERPROFILE ".gitconfig"
    "platform" = "all"
  }

  #
  # Windows only
  #
  @{
    "name" = "PowerShell Profile"
    "target" = Join-Path $env:USERPROFILE "Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1"
    "platform" = "win"
  },
  @{
    "name" = "VSCode PowerShell Profile"
    "target" = Join-Path $env:USERPROFILE "Documents/WindowsPowerShell/Microsoft.VSCode_profile.ps1"
    "platform" = "win"
  },
  @{
    "name" = "Microsoft Terminal settings"
    "target" = Join-Path $env:LOCALAPPDATA "Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"
    "platform" = "win"
  }
  @{
    "name" = "Git Extensions settings"
    "target" = Join-Path $env:USERPROFILE "scoop/apps/gitextensions/current/GitExtensions.settings"
    "platform" = "win"
  }
)

function Test-ReparsePoint {
  param (
    [Parameter(ValueFromPipeline = $true)]
    [string]
    $Path
  )

  $file = Get-Item $Path -Force -ErrorAction SilentlyContinue
  [bool]($file.Attributes -band [IO.FileAttributes]::ReparsePoint)
}

function New-UniqueName {
  param (
    [Parameter(ValueFromPipeline = $true)]
    [string]
    $BasePath
  )

  $extension = [IO.Path]::GetExtension($BasePath)
  $candidatePath = $BasePath
  $i = 0
  while (Test-Path $candidatePath) {
    $candidatePath = [IO.Path]::ChangeExtension($BasePath, ".$i$extension")
    $i += 1
  }

  $candidatePath
}

function Install-SettingsFile {
  param (
    $Platform,
    [Parameter(ValueFromPipeline = $true)]
    $SettingsInfo
  )

  Process {
    Write-Host -ForegroundColor Green "Installing $($SettingsInfo.name) [$($SettingsInfo.target)]..."

    $source = $filesRoot | Join-Path -ChildPath (Split-Path $SettingsInfo.target -Leaf)
    Write-Host -ForegroundColor Gray "... Checking local file exists. " -NoNewline
    if (-not (Test-Path $source)) {
      Write-Host -ForegroundColor Red "$source does not exist. Aborting installation of this setting!"
      return
    } else {
      Write-Host -ForegroundColor Green "done!"
    }

    $targetFolder = Split-Path $SettingsInfo.target
    Write-Host -ForegroundColor Gray "... Checking target folder exists. " -NoNewline
    if (-not (Test-Path $targetFolder)) {
      Write-Host -ForegroundColor Yellow "$targetFolder does not exist. Creating..."
      mkdir $targetFolder
    } else {
      Write-Host -ForegroundColor Green "done!"
    }

    Write-Host -ForegroundColor Gray "... Checking if target is a file. " -NoNewline
    if ((Test-Path $SettingsInfo.target) -and (-not (Test-ReparsePoint $SettingsInfo.target))) {
      $backupPath = $SettingsInfo.target | New-UniqueName
      Write-Host -ForegroundColor Yellow "It is, backing it up to $backupPath... " -NoNewline
      Move-Item $SettingsInfo.target $backupPath -ErrorAction Continue
      Write-Host -ForegroundColor Green "done!"
    } else {
      Write-Host -ForegroundColor Green "done!"
    }

    Write-Host -ForegroundColor Gray "... Checking if target exists. " -NoNewline
    if ((Test-Path $SettingsInfo.target) -and (Test-ReparsePoint $SettingsInfo.target)) {
      Write-Host -ForegroundColor Yellow "It does, deleting... " -NoNewline
      del $SettingsInfo.target -ErrorAction Continue
      Write-Host -ForegroundColor Green "done!"
    } else {
      Write-Host -ForegroundColor Green "done!"
    }

    if (Test-Path $SettingsInfo.target) {
      Write-Host -ForegroundColor Red "$($SettingsInfo.target) should not exist. Something went wrong. Aborting installation of this setting!"
    }

    Write-Host -ForegroundColor Gray "... Installing setting. " -NoNewline
    $s = New-Item -Path $SettingsInfo.target -ItemType SymbolicLink -Value $source -ErrorAction Continue
    Write-Host -ForegroundColor Green "$($s.Name) done!"
  }
}

$files | Install-SettingsFile

if ($IsWindows) {
  Write-Host -ForegroundColor Gray "Installing windows startup scripts... " -NoNewline
  Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Run -Name AHK -Value "`"$env:USERPROFILE\scoop\apps\autohotkey\current\UX\AutoHotkeyUX.exe`" D:\src\p2d\.cfg\f\autohotkey.ahk" -Force
  Write-Host -ForegroundColor Green "done!"
}
