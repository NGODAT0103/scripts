#!/bin/bash

# Function to check if Git is installed
check_git_installed() {
    if ! command -v git &> /dev/null
    then
        echo "Error: Git is not installed."
        
        # Ask user if they want to install Git
        read -p "Git is required. Would you like to install Git automatically? (y/n): " install_choice
        if [[ "$install_choice" == "y" || "$install_choice" == "Y" ]]
        then
            install_git
        else
            echo "Git installation aborted. Please install Git manually."
            exit 1
        fi
    fi
}

# Function to install Git using apt
install_git() {
    echo "Installing Git using apt..."
    sudo apt update
    sudo apt install git -y
    if [[ $? -ne 0 ]]; then
        echo "Error: Git installation failed."
        exit 1
    fi
    echo "Git installed successfully!"
}

# Function to validate email format
validate_email() {
    local email_regex="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
    if [[ $1 =~ $email_regex ]]
    then
        return 0
    else
        return 1
    fi
}

# Check if Git is installed, prompt user to install if not
check_git_installed

# Prompt user for Git username and email
read -p "Enter your Git username: " username
read -p "Enter your Git email: " email

# Validate the provided email
if ! validate_email "$email"; then
    echo "Error: Invalid email format. Please enter a valid email."
    exit 1
fi

# Configure Git with the provided username and email
git config --global user.name "$username"
git config --global user.email "$email"

# Check if Git credential helper is already set
if git config --global credential.helper > /dev/null; then
    echo "Git credential helper is already set."
else
    # Set Git credential helper to store credentials
    git config --global credential.helper store
    echo "Git credential helper set to store."
fi

echo "Git configuration updated successfully."

