#!/bin/bash

# Script to list startup applications for the current user.

list_startup_apps() {
    printf "Startup Applications:\n\n"
    osascript -e 'tell application "System Events" to get the name of every login item' | tr ',' '\n' | awk '{print NR". "$0}'
}

main() {
    list_startup_apps
}

main
