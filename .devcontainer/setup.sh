#!/bin/bash

# Update dependencies
sudo apt update
sudo apt upgrade -y
sudo apt install -y curl build-essential pkg-config libssl-dev libudev-dev

# Install Solana CLI
sh -c "$(curl -sSfL https://release.anza.xyz/v1.18.22/install)"
export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"
echo 'export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"' >> ~/.bashrc

# Verify installation
solana --version

# Install Rust 1.75.0 (Stable and Anchor-compatible)
rustup install 1.75.0
rustup default 1.75.0

# Install Anchor
cargo install --git https://github.com/coral-xyz/anchor avm --force
avm install 0.30.0
avm use 0.30.0
anchor --version

# Install SPL Token CLI
cargo install spl-token-cli

# Restore Solana Wallet from GitHub Secrets
mkdir -p ~/.config/solana
echo "$SOLANA_DEVNET_WALLET" > ~/.config/solana/id.json

# Startup Devnet
solana config set --url https://api.devnet.solana.com