#!/bin/bash

# Update and install additional dependencies
sudo apt update
sudo apt upgrade -y
sudo apt install -y build-essential pkg-config libssl-dev libudev-dev protobuf-compiler clang cmake

# Ensure Rust 1.85.0 is installed explicitly
rustup default 1.85.0
rustup update 1.85.0
rustc --version

# Install Solana CLI using the official quick install script
curl --proto '=https' --tlsv1.2 -sSfL https://solana-install.solana.workers.dev | bash

# Set PATH for current and future shell sessions
echo 'export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"' >> ~/.bashrc
echo 'export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"' >> ~/.profile
export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"
solana --version

# Install Anchor CLI explicitly at v0.31.0 (compatible with current GLIBC)
cargo install --git https://github.com/coral-xyz/anchor --tag v0.31.0 anchor-cli --locked --force
anchor --version

# Install latest SPL Token CLI
cargo install spl-token-cli --locked --force
spl-token --version

# Restore Solana Wallet from GitHub Secrets
mkdir -p ~/.config/solana
echo "$SOLANA_DEVNET_WALLET" > ~/.config/solana/id.json

# Configure Solana Devnet
solana config set --url https://api.devnet.solana.com
solana balance
