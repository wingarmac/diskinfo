#!/bin/bash

# Set WORKING_DIR to the directory where this script resides
WORKING_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$WORKING_DIR" || { echo "Cannot change to $WORKING_DIR"; exit 1; }

# Define ANSI color codes
LIGHT_BLUE="\033[1;94m"
LIGHT_GREEN="\033[1;32m"
RED="\033[1;31m"
RESET="\033[0m"

# Check for dialog and offer to install, but only if the user wants to use dialog
read -r -p "Use dialog for the menu? [y/N] " response
if [[ "$response" =~ ^[yY]$ ]]; then
    if ! command -v dialog &> /dev/null; then
        read -r -p "dialog is not installed. Install it now? [y/N] " response
        if [[ "$response" =~ ^[yY]$ ]]; then
            # Privilege check only if installation is required
            if [[ $EUID -ne 0 ]]; then
                echo "This script requires root privileges to install dialog. Please run with sudo."
                exit 1
            fi
            apt update && apt install -y dialog
        else
            echo "Switching to basic menu."
            response="n" # Use basic menu if dialog is not installed
        fi
    fi
fi

if [[ "$response" =~ ^[yY]$ ]]; then
    # Dialog-based menu
    choice=$(dialog --menu "Select Disk Information:" 12 50 5 \
        "1" "All Information" \
        "2" "Standard Disks" \
        "3" "RAID Information" \
        "4" "LVM Information" \
        "5" "Exit" \
        2>&1 >/dev/tty)

    case "$choice" in
        1)
            clear  # Clear the screen
            ./combined.sh
            ;;
        2)
            clear  # Clear the screen
            ./diskinfo.sh
            ;;
        3)
            clear  # Clear the screen
            ./raidinfo.sh
            ;;
        4)
            clear  # Clear the screen
            ./lvm2info.sh
            ;;
        5)
            clear  # Clear the screen before exiting
            exit 0
            ;;
    esac
else
    # Fallback to basic menu
    options=("All Information" "Standard Disks" "RAID Information" "LVM Information" "Exit")
    echo "Select Disk Information:"
    select opt in "${options[@]}"; do
        case $opt in
            "All Information")
                ./combined.sh
                ;;
            "Standard Disks")
                ./diskinfo.sh
                ;;
            "RAID Information")
                ./raidinfo.sh
                ;;
            "LVM Information")
                ./lvm2info.sh
                ;;
            "Exit")
                exit 0
                ;;
            *)
                echo "Invalid option"
                ;;
        esac
        exit 0  # Exit after each selection
    done
fi

