#!/usr/bin/env bash
# DATE: 2016-06-07
# MODIFIED: 2017-11-23
# AUTHOR: Jeremy Cade <me@jeremycade.com> (http://www.jeremycade.com)
# DESCRIPTION: Setup script for Infrastructure workspace on OS X and Linux.

# Tools that we use to setup our Infrastructure
Tools[0]='terraform'
Tools[1]='packer'
Tools[2]='aws;awscli'

# Get operating system Name
OS=`uname -s`

###################################################
# Test that a Command exists
# Install with Homebrew if it does not exist.
###################################################
function brew_test_and_install {
    IFS=';' read -ra PARSED <<< "$1"
    len=${#PARSED[@]}

    cmd=$PARSED
    install=$PARSED

    if [ "$len" -eq "2" ]; then
        install=$PARSED[1]
    fi

    if ! command -v $cmd >/dev/null; then
        echo "> Installing $cmd"
        brew install $install
    else
        echo "> $cmd is already installed"
    fi
}

###################################################
# Presentation is important.
###################################################
function ascii_header {
    echo "----------------------------------------"
    echo "-             (___)                    -"
    echo "-             (o o)_____/              -"
    echo "-              @@\`     \\               -"
    echo "-               \\ ____, /              -"
    echo "-               //    //               -"
    echo "-              ^^    ^^                -"
    echo "-           Cattle Not Pets!           -"
    echo "-      Infrastructure Automation       -"
    echo "----------------------------------------"
}

###################################################
# Presentation is important.
###################################################
function ascii_footer {
    echo "----------------------------------------"
    echo "          _ __ ___   ___   ___          "
    echo "         | '_ \` _ \\ / _ \\ / _ \\     "
    echo "         | | | | | | (_) | (_) |        "
    echo "         |_| |_| |_|\___/ \___/         "
    echo "----------------------------------------"
}

###################################################
# Main Entry Function.
###################################################
function main {
    ascii_header

    if [ "$OS" = Darwin ]; then
        if command -v brew >/dev/null; then
            echo "---- Using Homebrew Package Manager ----"
            echo "----------------------------------------"

            # Ensure we have the latest package list
            brew update;

            # Iterate over our tool list and install
            for i in "${Tools[@]}"
            do
                brew_test_and_install $i
            done
        else
            (>&2 echo "Error: Please install homebrew from https://brew.sh/")
            exit
        fi
    fi

    ascii_footer
}

# Execute Setup Script
main