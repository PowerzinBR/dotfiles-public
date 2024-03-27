# Some code belongs to harshv dotfiles repository, thanks for your contribution!
# <! --- github/harshv5094/dotfiles-public/scripts/install.ps1 --- !>

function installScoopPackages {
    $scoopPackagesFile = ".\scoopPackages.txt"
    
    if (Test-Path $scoopPackagesFile) {
        Write-Output "Installing Scoop packages listed in $scoopPackagesFile"
        $packages = Get-Content $scoopPackagesFile
        
        foreach ($package in $packages) {
            Write-Output "━━━━━━━━━━━━━━━━━━━━━━"
            scoop install $package
        }
        
        Write-Output "Scoop packages installation completed."
    } else {
        Write-Output "No scoop packages file found. Did you check if everything is correct?"
    }
}


function checkScoop {
    ('Welcome to the **craftzdog** dotfiles installation script for **Windows**!' | ConvertFrom-MarkDown -AsVt100EncodedString).VT100EncodedString

    $installOption = Read-Host "Please choose an installation option:`n1. Scoop installation`n2. None (cancel)`nEnter the number corresponding to your choice"

    switch ($installOption) {
        1 {
            installScoop
            Write-Output "━━━━━━━━━━━━━━━━━━━━━━"
        }
        2 {
            Write-Output "Installation canceled. Exiting..."
            break
        }
        default {
            Write-Output "━━━━━━━━━━━━━━━━━━━━━━"
            Write-Output "Invalid choice. Please select either 1 or 2."
        }
    }
}

function installScoop {
    if (Test-Path -Path "$env:USERPROFILE\scoop") {
        Write-Output "Scoop is already installed."
        Write-Output "━━━━━━━━━━━━━━━━━━━━━━"
        createPs
    } else {
        Write-Output "Installing Scoop by scoop.sh..."
        Write-Output "━━━━━━━━━━━━━━━━━━━━━━"
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
        Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression

        if (Test-Path -Path "$env:USERPROFILE\scoop") {
            Write-Output "Scoop installation completed successfully."
            Write-Output "━━━━━━━━━━━━━━━━━━━━━━"
            createPs
        } else {
            Write-Output "Failed to install Scoop. Exiting..."
            Write-Output "━━━━━━━━━━━━━━━━━━━━━━"
            break
        }
    }
}

function createPs {
    $psFilePath = ~\Documents\PowerShell\Microsoft.Powershell_profile.ps1
    $ompConfigPath = Join-Path $PSScriptRoot "takuya.omp.json"

    $ESC = [char]27
    $ANSI_BOLD = "${ESC}[1m"
    $ANSI_RESET = "${ESC}[0m"

    if (Test-Path $psFilePath) {
        Write-Host "${ANSI_BOLD}Fatal - The PowerShell configuration file already exists.${ANSI_RESET}" -ForegroundColor Red
        Write-Host "${ANSI_BOLD}Please make a backup of it (optional) and remove the file after backup.${ANSI_RESET}" -ForegroundColor Green
        Write-Output "Run the script again after performing these steps."
    } else {
        New-Item -Path ~\Documents\PowerShell\ -Name Microsoft.Powershell_profile.ps1
        Write-Output "PS profile file created successfully."
        
        # Escreve o conteúdo no arquivo PS
        @"
# set PowerShell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

Import-Module posh-git
\$omp_config = Join-Path \$PSScriptRoot ".\takuya.omp.json"
oh-my-posh --init --shell pwsh --config \$omp_config | Invoke-Expression

Import-Module -Name Terminal-Icons

# PSReadLine
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -BellStyle None
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
Set-PSReadLineOption -PredictionSource History

# Fzf
Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'

# Env
\$env:GIT_SSH = "C:\Windows\system32\OpenSSH\ssh.exe"

# Alias
Set-Alias -Name vim -Value nvim
Set-Alias ll ls
Set-Alias g git
Set-Alias grep findstr
Set-Alias tig 'C:\Program Files\Git\usr\bin\tig.exe'
Set-Alias less 'C:\Program Files\Git\usr\bin\less.exe'

# Utilities
function which (\$command) {
  Get-Command -Name \$command -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}
"@

        # Escreve o conteúdo no arquivo takuya.omp.json
        Set-Content -Path $ompConfigPath -Value @'
{
  "$schema": "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json",
  "final_space": false,
  "osc99": true,
  "blocks": [
    {
      "type": "prompt",
      "alignment": "left",
      "segments": [
        {
          "type": "shell",
          "style": "diamond",
          "leading_diamond": "╭─",
          "trailing_diamond": "",
          "foreground": "#ffffff",
          "background": "#0077c2",
          "properties": {
          }
        },
        {
          "type": "root",
          "style": "diamond",
          "leading_diamond": "",
          "trailing_diamond": "",
          "foreground": "#FFFB38",
          "background": "#ef5350",
          "properties": {
            "root_icon": "\uf292",
            "prefix": "<parentBackground>\uE0B0</> "
          }
        },
        {
          "type": "path",
          "style": "powerline",
          "powerline_symbol": "\uE0B0",
          "foreground": "#E4E4E4",
          "background": "#444444",
          "properties": {
            "style": "full",
            "enable_hyperlink": true
          }
        },
        {
          "type": "git",
          "style": "powerline",
          "powerline_symbol": "\uE0B0",
          "foreground": "#011627",
          "background": "#FFFB38",
          "background_templates": [
            "{{ if or (.Working.Changed) (.Staging.Changed) }}#ffeb95{{ end }}",
            "{{ if and (gt .Ahead 0) (gt .Behind 0) }}#c5e478{{ end }}",
            "{{ if gt .Ahead 0 }}#C792EA{{ end }}",
            "{{ if gt .Behind 0 }}#C792EA{{ end }}"
          ],
          "properties": {
            "branch_icon": "\ue725 ",
            "fetch_status": true,
            "fetch_upstream_icon": true,
            "template": "{{ .HEAD }} {{ if .Working.Changed }}{{ .Working.String }}{{ end }}{{ if and (.Working.Changed) (.Staging.Changed) }} |{{ end }}{{ if .Staging.Changed }}<#ef5350> \uF046 {{ .Staging.String }}</>{{ end }}"
          }
        }
      ]
    },
    {
      "type": "prompt",
      "alignment": "right",
      "segments": [
        {
          "type": "node",
          "style": "diamond",
          "leading_diamond": " \uE0B6",
          "trailing_diamond": "\uE0B4",
          "foreground": "#


checkScoop