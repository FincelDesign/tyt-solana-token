#!/bin/bash

# Update dependencies
sudo apt update
sudo apt upgrade -y
sudo apt install -y curl build-essential pkg-config libssl-dev libudev-dev

# Install Solana CLI
sh -c "$(curl -sSfL https://release.anza.xyz/v1.18.22/install)"
echo 'export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"' >> ~/.bashrc
export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"

# Verify installation
solana --version

# Install Anchor
cargo install --git https://github.com/coral-xyz/anchor avm --force
avm install 0.30.0
avm use 0.30.0
anchor --version

# Install SPL Token CLI
cargo install spl-token-cli
