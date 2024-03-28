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
    ('Welcome to the **craftzdog** dotfiles installation script!' | ConvertFrom-MarkDown -AsVt100EncodedString).VT100EncodedString

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
    $psFilePath = Join-Path $env:USERPROFILE 'Documents\PowerShell\Microsoft.Powershell_profile.ps1'
    $ompConfigPath = Join-Path $PSScriptRoot "Documents\PowerShell\takuya.omp.json"
    $psConfigPath = Join-Path $PSScriptRoot "PSConfig.txt"
    $poshConfigPath = Join-Path $PSScriptRoot "PoshConfig.txt"

    $ESC = [char]27
    $ANSI_BOLD = "${ESC}[1m"
    $ANSI_RESET = "${ESC}[0m"

    if (Test-Path $psFilePath) {
        Write-Host "${ANSI_BOLD}Fatal - The PowerShell configuration file already exists.${ANSI_RESET}" -ForegroundColor Red
        Write-Host "${ANSI_BOLD}Please make a backup of it (optional) and remove the file after backup.${ANSI_RESET}" -ForegroundColor Green
        Write-Output "Run the script again after performing these steps."
    } else {
        New-Item -Path ~\Documents\PowerShell\ -Name Microsoft.Powershell_profile.ps1
        Write-Output "PowerShell profile file created successfully."

        $psConfigContent = Get-Content $psConfigPath -Raw
        Set-Content -Path $psFilePath -Value $psConfigContent

        $poshConfigContent = Get-Content $poshConfigPath -Raw
        Set-Content -Path $ompConfigPath -Value $poshConfigContent
    }
}

checkScoop
