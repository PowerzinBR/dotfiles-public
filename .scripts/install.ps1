# Some code belongs to this repository, thanks for your contribution!
# <! --- github/harshv5094/dotfiles-public/scripts/install.ps1 --- !>

function checkScoop {
    if (Test-Path -Path "$env:USERPROFILE\scoop") {
        Write-Output "Scoop is installed..."
    } else {
        Write-Output "Scoop is not installed, want to install it now? (required for continue)"
        Write-Host "1. Yes"
        Write-Host "2. No, I want to cancel installation"

        $choice = Read-Host "Enter your choice (1 or 2)"

        switch ($choice) {
            1 {
                Write-Output "Installing scoop by scoop.sh"
                Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
		        Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
                Write-Output "The installation was completed. Please start the install script"
                scoop bucket add extras
            }
            2 {
                Write-Output "FATAL - Installation failed due to previous cancel."
                break
            }
            default {
                Write-Output "Invalid choice. Please select 1 or 2."
                break
            }
        }
    }
}

checkScoop
