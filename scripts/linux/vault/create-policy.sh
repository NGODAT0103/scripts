#!/bin/bash

echo "Vault Policy Creation Script"

# Prompt for the secret path
read -p "Enter the secret path [default: secrets/data/se347/backend]: " secret_path
secret_path=${secret_path:-"secrets/data/se347/backend"}

# Display available capabilities
echo -e "\nSupported capabilities:"
echo "1. read     - Read data from the path."
echo "2. create   - Write data to the path."
echo "3. update   - Update data at the path."
echo "4. delete   - Delete data at the path."
echo "5. list     - List keys at the path."
echo "6. sudo     - Perform superuser operations at the path."
echo "7. deny     - Explicitly deny all actions at the path."

# Prompt for capabilities (comma-separated values)
read -p "Enter the capabilities (comma-separated, e.g., read,update): " capabilities

# Validate capabilities
IFS=',' read -ra CAP_ARRAY <<< "$capabilities"
valid_capabilities=("read" "create" "update" "delete" "list" "sudo" "deny")
for cap in "${CAP_ARRAY[@]}"; do
  if [[ ! " ${valid_capabilities[*]} " =~ " ${cap} " ]]; then
    echo "Error: Invalid capability '$cap'. Please use only supported capabilities."
    exit 1
  fi
done


# Define policy name
policy_name="custom_policy_${RANDOM}"

# Create the policy
vault policy write "$policy_name" - <<EOF
path "$secret_path" {
  capabilities = [${capabilities//,/ }]
}
EOF

if [ $? -ne 0 ]; then
  echo "Failed to create policy. Please check your Vault token or configuration."
  exit 1
fi

echo "Policy '$policy_name' created successfully with the following capabilities: $capabilities"
echo "You can use this policy name to generate tokens in the next step."

