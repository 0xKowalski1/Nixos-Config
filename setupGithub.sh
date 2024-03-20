#!/bin/bash

# Define key path
KEY_PATH="${HOME}/.ssh/github_rsa"

# Check if the SSH key already exists
if [ -f "$KEY_PATH" ]; then
    echo "SSH key already exists at $KEY_PATH"
else
    # Generate a new SSH key
    ssh-keygen -t rsa -b 4096 -C "0xkowalskiaudit@gmail.com" -f "$KEY_PATH" -N ""

    # Start the ssh-agent in the background.
    eval "$(ssh-agent -s)"

    # Add your SSH private key to the ssh-agent
    ssh-add "$KEY_PATH"
    
    # Output the SSH public key
    echo "SSH key generated at $KEY_PATH"
    echo "Public key:"
    cat "${KEY_PATH}.pub"
fi

echo "Please add the above SSH public key to your GitHub account."
echo "1. Copy the public key."
echo "2. Go to GitHub -> Settings -> SSH and GPG keys -> New SSH key."
echo "3. Paste your key and save."
