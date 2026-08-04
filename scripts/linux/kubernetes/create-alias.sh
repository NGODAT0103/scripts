#!/bin/bash

# Define aliases and their corresponding commands
declare -A ALIASES=(
    ["ksetns"]='alias ksetns="kubectl config set-context --current --namespace"'
    ["kgp"]='alias kgp="kubectl get pod"'
    ["klogs"]='alias klogs="kubectl logs -f"'
)

# Path to the .bashrc file
BASHRC_FILE="$HOME/.bashrc"

# Loop through each alias and add it if it doesn't already exist
for ALIAS_NAME in "${!ALIASES[@]}"; do
    ALIAS_COMMAND=${ALIASES[$ALIAS_NAME]}
    if grep -q "$ALIAS_NAME=" "$BASHRC_FILE"; then
        echo "Alias '$ALIAS_NAME' already exists in $BASHRC_FILE."
    else
        echo "$ALIAS_COMMAND" >> "$BASHRC_FILE"
        echo "Alias '$ALIAS_NAME' added to $BASHRC_FILE."
    fi
done

# Reload the .bashrc file to apply changes
source "$BASHRC_FILE"
echo "Aliases have been updated and are now available."
