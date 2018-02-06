<#
.SYNOPSIS
Setup Infrastructure workspace on a Windows machine.
#>

# Tools that we use to setup our Infrastructure
$tools = @("terraform", "packer", "aws;awscli")

###################################################
# Chocoltey needs Adminstator Elevation
###################################################
function CheckAdministator {
    If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
                [Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Warning "You do not have Administrator rights to run this script!`nPlease re-run this script as an Administrator!"

        # Set Exit Code!
        exit 1
    }
}

###################################################
# Test that a Command exists
# Install with Chocolatey if it does not exist.
###################################################
Function Choco_test_and_install ([string] $tool) {
    $parsed = $tool -split ';'
    $cmd = $parsed[0]
    $install = $parsed[0]

    if ($parsed.length -eq 2) {
        $install = $parsed[1]
    }

    if ((Get-Command "$cmd" -ErrorAction SilentlyContinue) -eq $null) {
        choco install $install --yes
    }
    else {
        Write-Host "> $cmd is already installed"
    }
}

###################################################
# Presentation is important.
###################################################
Function Ascii_header {
    Write-Host "----------------------------------------"
    Write-Host "-             (___)                    -"
    Write-Host "-             (o o)_____/              -"
    Write-Host "-              @@`       \              -"
    Write-Host "-               \\ ____,/              -"
    Write-Host "-               //    //               -"
    Write-Host "-              ^^    ^^                -"
    Write-Host "-          Cattle Not Pets!            -"
    Write-Host "-      Infrastructure Automation       -"
    Write-Host "----------------------------------------"
}

###################################################
# Main Entry Function.
###################################################
Function Main {
    Ascii_header
    CheckAdministator

    if ((Get-Command "choco" -ErrorAction SilentlyContinue) -ne $null) {
        Write-Host "-   Using Chocolatey Package Manager   -"
        Write-Host "----------------------------------------"

        foreach ($tool in $tools) {
            Choco_test_and_install $tool
        }

        Write-Host "----------------------------------------"
        Write-Host "-               MOOO!!!!               -"
        Write-Host "----------------------------------------"
    }
    else {
        Write-Error "Error: Please install Chocolatey from https://chocolatey.org/"

        # Set Exit Code!
        exit 1
    }
}

# Execute Setup Script
Main