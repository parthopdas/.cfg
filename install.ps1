<#
TODO: autohotkey at startup
TODO: make it work for linux
#>

$files = @(
  @{
    "name" = "PowerShell Profile"
    "target" = Join-Path $env:USERPROFILE "Documents/PowerShell/Microsoft.PowerShell_profile.ps1"
    "platform" = "all"
  },
  @{
    "name" = "Microsoft Terminal settings"
    "target" = Join-Path $env:LOCALAPPDATA "Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"
    "platform" = "win"
  }
)

function Test-IsPowerShellCore {
  [CmdletBinding(ConfirmImpact = 'None')]
  [OutputType([bool])]
  param ()

  process
  {
    $PSVersionTable.PSEdition -ceq "Core"
  }
}

# NOTE: From https://gist.github.com/jhochwald/46014a3de425dc21c1f1f7e31cd49cf1
function Test-IsAdmin {
  [CmdletBinding(ConfirmImpact = 'None')]
  [OutputType([bool])]
  param ()

  process
  {
    if ($PSVersionTable.PSEdition -eq 'Desktop') {
      # Fastest way on Windows
      ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')
    } elseif (($PSVersionTable.PSEdition -eq 'Core') -and ($PSVersionTable.Platform -eq 'Unix')) {
      # Ok, on macOS and Linux we use ID to figure out if we run elevated (0 means superuser rights)
      if ((id -u) -eq 0) {
        $true
      } else {
        $false
      }
    } elseif (($PSVersionTable.PSEdition -eq 'Core') -and ($PSVersionTable.Platform -eq 'Win32NT')) {
      # For PowerShell Core on Windows the same approach as with the Desktop work just fine
      # This is for future improvements :-)
      ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')
    } else {
      # Unable to figure it out!
      Write-Warning -Message 'Unknown'

      $false
    }
  }
}

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
    Write-Host -ForegroundColor Green "Installing $($SettingsInfo.name)..."

    $source = Join-Path $PSScriptRoot "f" | Join-Path -ChildPath (Split-Path $SettingsInfo.target -Leaf)
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

if (-not (Test-IsPowerShellCore)) {
  Write-Host -ForegroundColor Red "Script requires PowerShell Core. Quitting!"
  return
}

if (-not (Test-IsAdmin)) {
  Write-Host -ForegroundColor Red "Script requires elevated privileges. Quitting!"
  return
}

$files | Install-SettingsFile
