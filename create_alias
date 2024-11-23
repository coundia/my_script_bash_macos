#!/bin/bash

# Script to create a shell alias if it does not already exist.

create_alias() {
    local alias_name=$1
    local alias_command=$2
    local shell_config

    # Determine the shell configuration file based on the user's default shell
    case "$SHELL" in
        */bash)
            shell_config="$HOME/.bashrc"
            ;;
        */zsh)
            shell_config="$HOME/.zshrc"
            ;;
        *)
            printf "Unsupported shell: %s\n" "$SHELL" >&2
            return 1
            ;;
    esac

    # Ensure both alias name and command are provided
    if [[ -z "$alias_name" || -z "$alias_command" ]]; then
        printf "Usage: %s <alias_name> <alias_command>\n" "$(basename "$0")" >&2
        return 1
    fi

    # Check if the alias already exists in the configuration file
    if grep -q "^alias $alias_name=" "$shell_config" 2>/dev/null; then
        printf "Alias '%s' already exists in %s.\n" "$alias_name" "$shell_config"
        return 0
    fi

    # Add the alias to the shell configuration file
    printf "alias %s='%s'\n" "$alias_name" "$alias_command" >> "$shell_config"
    printf "Alias '%s' added to %s.\n" "$alias_name" "$shell_config"
    printf "Run 'source %s' to apply changes to the current session.\n" "$shell_config"
    
}

main() {
    create_alias "$1" "$2"
}

main "$@"
