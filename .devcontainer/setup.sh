#!/bin/bash

# Update essentials
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl git build-essential pkg-config libssl-dev libudev-dev protobuf-compiler

# Ensure rustup and cargo bin directories are accessible
source "$HOME/.cargo/env"

# Install Solana CLI v2.2.12
sh -c "$(curl -sSfL https://release.solana.com/v2.2.12/install)"

# Add Solana to PATH permanently
echo 'export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"' >> ~/.bashrc
export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"

# Verify Solana CLI installation
solana --version

# Install Anchor CLI v0.31.1
cargo install --git https://github.com/coral-xyz/anchor --tag v0.31.1 anchor-cli --locked --force

# Verify Anchor CLI installation
anchor --version

# Install Yarn v1.22.1 explicitly
npm uninstall -g yarn
npm install -g yarn@1.22.1

# Verify Yarn installation
yarn --version

# Install SPL Token CLI latest stable version
cargo install spl-token-cli --locked --force
spl-token --version

# Restore Solana Wallet from GitHub Secrets
mkdir -p ~/.config/solana
echo "$SOLANA_DEVNET_WALLET" > ~/.config/solana/id.json

# Configure Solana Devnet
solana config set --url https://api.devnet.solana.com
solana balance

# Final check of installations
echo "Installation completed. Checking versions..."
rustc --version && cargo --version && solana --version && anchor --version && node --version && yarn --version
