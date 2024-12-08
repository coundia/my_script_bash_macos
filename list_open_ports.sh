#!/bin/bash

# Script to list all open ports and their associated services on macOS
# Requires sudo for access to privileged ports

# Global variables
readonly OUTPUT_FILE="/tmp/open_ports_report.txt"

# Function to check for required permissions
check_permissions() {
    if [[ $EUID -ne 0 ]]; then
        printf "Error: This script must be run as root. Please use sudo.\n" >&2
        return 1
    fi
    return 0
}

# Function to list open ports and their associated services
list_open_ports() {
    # Get the list of ports with associated service names using lsof
    local output; output=$(lsof -iTCP -sTCP:LISTEN -P -n)

    # If no output found, return error
    if [[ -z "$output" ]]; then
        printf "No open ports found.\n"
        return 1
    fi

    # Extract port numbers and associated service names
    echo "$output" | awk '{print $9}' | grep -Eo '[0-9]+$' | sort -n | uniq | while read port; do
        # Check if there's a service name associated with the port
        local service_name; service_name=$(lsof -i :$port -sTCP:LISTEN -t | xargs -I{} ps -p {} -o comm=)
        if [[ -z "$service_name" ]]; then
            service_name="Unknown"
        fi
        printf "Port: %s - Service: %s\n" "$port" "$service_name"
    done

    return 0
}

# Function to log results to a file
log_results() {
    if ! list_open_ports > "$OUTPUT_FILE"; then
        printf "Failed to write port details to %s\n" "$OUTPUT_FILE" >&2
        return 1
    fi
    printf "Open ports and services have been logged to: %s\n" "$OUTPUT_FILE"
    return 0
}

# Main function
main() {
    if ! check_permissions; then
        return 1
    fi

    printf "Scanning for open ports and their associated services...\n\n"
    list_open_ports || return 1

    printf "\nWould you like to save the results to %s? (y/n): " "$OUTPUT_FILE"
    read -r save_choice
    if [[ $save_choice =~ ^[Yy]$ ]]; then
        log_results || return 1
    else
        printf "Results were not saved.\n"
    fi

    return 0
}

main 