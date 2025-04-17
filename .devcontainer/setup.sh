#!/bin/bash

# Update and install essential dependencies
sudo apt update
sudo apt upgrade -y
sudo apt install -y curl git build-essential pkg-config libssl-dev libudev-dev protobuf-compiler

# Install Rust 1.85.0
curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain 1.85.0
source $HOME/.cargo/env
rustup default 1.85.0
rustup update 1.85.0
rustc --version

# Install Anchor CLI explicitly from source at v0.31.0 (GLIBC compatible)
cargo install --git https://github.com/coral-xyz/anchor --tag v0.31.0 anchor-cli --locked --force
anchor --version

# Install latest stable Solana CLI (official new Anza.xyz method)
sh -c "$(curl -sSfL https://release.anza.xyz/stable/install)"
# Explicitly set PATH for current and future shell sessions
echo 'export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"' >> ~/.bashrc
echo 'export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"' >> ~/.profile
export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"
solana --version

# Install latest SPL Token CLI (compatible with latest stable Rust)
cargo install spl-token-cli --locked --force
spl-token --version

# Restore Solana Wallet from GitHub Secrets
mkdir -p ~/.config/solana
echo "$SOLANA_DEVNET_WALLET" > ~/.config/solana/id.json

# Configure Solana Devnet
solana config set --url https://api.devnet.solana.com
solana balance