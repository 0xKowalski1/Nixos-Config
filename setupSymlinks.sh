#!/bin/bash

# Automatically determine the script's current directory assuming the script is placed in the root of the repo
REPO_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if the expected configuration directories exist
if [ ! -d "${REPO_PATH}/nixos" ] || [ ! -d "${REPO_PATH}/home-manager" ]; then
    echo "The required directories (nixos/ and home-manager/) were not found in ${REPO_PATH}."
    echo "Please ensure the script is located in the root of your configuration repository."
    exit 1
fi

# Create symlinks for NixOS and Home Manager configurations
sudo ln -sf "${REPO_PATH}/nixos/configuration.nix" /etc/nixos/configuration.nix
ln -sf "${REPO_PATH}/home-manager/home.nix" "${HOME}/.config/home-manager/home.nix"

echo "Symlinks for NixOS and Home Manager configurations have been created in the following locations:"
echo "NixOS: ${REPO_PATH}/nixos/configuration.nix -> /etc/nixos/configuration.nix"
echo "Home Manager: ${REPO_PATH}/home-manager/home.nix -> ${HOME}/.config/home-manager/home.nix"
