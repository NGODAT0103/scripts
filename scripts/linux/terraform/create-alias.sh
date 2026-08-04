#!/bin/bash

# Define the aliases to check and add
ALIAS_LINES=(
  "alias tfplan='terraform plan -var project_id=\$project_id'"
  "alias tfapply='terraform apply --auto-approve -var project_id=\$project_id'"
  "alias tfdestroy='terraform destroy --auto-approve -var project_id=\$project_id'"
)

# File to check and modify
BASHRC_FILE="$HOME/.bashrc"

# Function to check if an alias is present
check_and_add_alias() {
  local alias_line="$1"

  # Check if the alias already exists in the .bashrc file
  if ! grep -Fxq "$alias_line" "$BASHRC_FILE"; then
    # If not, append the alias to the file
    echo "$alias_line" >> "$BASHRC_FILE"
    echo "Added: $alias_line"
  else
    echo "Already exists: $alias_line"
  fi
}

# Loop through the alias lines and ensure they're present
for alias in "${ALIAS_LINES[@]}"; do
  check_and_add_alias "$alias"
done

# Inform the user to reload .bashrc
echo "Aliases have been updated. Please run 'source ~/.bashrc' to apply changes."

