#!/bin/bash
#!/bin/bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <GPG_KEY_ID>"i
    gpg --list-secret-keys --keyid-format LONG
    exit 1
fi

KEY_ID="$1"

# Set Git to use the provided GPG key ID
git config --global user.signingkey "$KEY_ID"
git config --global commit.gpgsign true
git config --global gpg.program gpg

echo "✅ Git is now configured to sign commits with GPG key: $KEY_ID"

