#!/bin/bash

# Update dependencies
sudo apt update
sudo apt upgrade -y
sudo apt install -y curl build-essential pkg-config libssl-dev libudev-dev protobuf-compiler

# Install Solana CLI
sh -c "$(curl -sSfL https://release.anza.xyz/v1.18.22/install)"
export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"
echo 'export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"' >> ~/.bashrc

# Verify Solana installation
solana --version

# Install Rust 1.81.0 (latest stable compatible with Anchor CLI v0.31.0)
rustup install 1.81.0
rustup default 1.81.0

# Install AVM & Anchor CLI explicitly at latest stable v0.31.0
cargo install --git https://github.com/coral-xyz/anchor avm --force --locked
avm install 0.31.0
avm use 0.31.0
anchor --version

# Install latest SPL Token CLI (fully Rust 1.81 compatible)
cargo install spl-token-cli --locked --force
spl-token --version

# Restore Solana Wallet from GitHub Secrets
mkdir -p ~/.config/solana
echo "$SOLANA_DEVNET_WALLET" > ~/.config/solana/id.json

# Configure Solana Devnet
solana config set --url https://api.devnet.solana.com