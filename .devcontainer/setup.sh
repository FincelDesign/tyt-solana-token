#!/bin/bash

# Update and install essential dependencies
sudo apt update
sudo apt upgrade -y
sudo apt install -y curl git build-essential pkg-config libssl-dev libudev-dev protobuf-compiler

# Install latest stable Solana CLI (as recommended by official Solana docs)
sh -c "$(curl -sSfL https://release.solana.com/stable/install)"
export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"
echo 'export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"' >> ~/.bashrc

# Verify Solana CLI installation
solana --version

# Install Rust latest stable version (officially recommended)
curl https://sh.rustup.rs -sSf | sh -s -- -y
source $HOME/.cargo/env
rustup update stable
rustup default stable

# Verify Rust installation
rustc --version

# Install AVM & latest stable Anchor CLI
cargo install --git https://github.com/coral-xyz/anchor avm --force --locked
avm install latest
avm use latest
anchor --version

# Install latest SPL Token CLI (compatible with latest stable Rust)
cargo install spl-token-cli --locked --force
spl-token --version

# Restore Solana Wallet from GitHub Secrets
mkdir -p ~/.config/solana
echo "$SOLANA_DEVNET_WALLET" > ~/.config/solana/id.json

# Configure Solana Devnet
solana config set --url https://api.devnet.solana.com