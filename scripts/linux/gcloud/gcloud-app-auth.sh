#!/bin/bash
set -e
# Prompt for environment

# Function to install gcloud CLI
install_gcloud() {
    echo "Installing gcloud CLI..."
    # Install gcloud for Debian/Ubuntu; customize as needed for other OSes
    curl -sSL https://sdk.cloud.google.com | bash
    exec -l $SHELL
    echo "gcloud installed successfully."
}

# Check if gcloud CLI is installed
if ! command -v gcloud &> /dev/null; then
    echo "gcloud CLI is not installed."
    read -p "Would you like to install gcloud CLI? (y/n): " install_gcloud_answer
    if [[ $install_gcloud_answer == "y" ]]; then
        install_gcloud
    else
        echo "gcloud CLI is required. Exiting."
        exit 1
    fi
else
    echo "gcloud CLI is already installed."
fi

# Check if gcloud is already authenticated
if gcloud auth list --filter=status:ACTIVE --format="value(account)" | grep -q '@'; then
    echo "gcloud is already authenticated. Skipping 'gcloud init'."
else
    # Initialize gcloud if not already authenticated
    echo "Initializing gcloud..."
    gcloud init
fi

# Check if application default credentials file exists
if [[ -f ~/.config/gcloud/application_default_credentials.json ]]; then
    echo "Application default credentials are already set. Skipping 'gcloud auth application-default login'."
else
    echo "Setting up application default credentials..."
    gcloud auth application-default login --quiet
fi

# Capture project ID from gcloud config
project_id=$(gcloud config list --format="value(core.project)")
if [ -z "$project_id" ]; then
    echo "Failed to retrieve the project ID from gcloud config. Exiting."
    exit 1
fi
echo "Using project ID from gcloud config: $project_id"


