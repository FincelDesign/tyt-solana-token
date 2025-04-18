#!/bin/bash

# Verify installation
rustc --version
anchor --version
node --version
yarn --version
solana --version

# Install latest SPL Token CLI
cargo install spl-token-cli --locked --force
spl-token --version

# Update Solana CLI config (optional)
solana config set --url http://localhost:8899

# Restore Solana Wallet from GitHub Secrets
mkdir -p ~/.config/solana
echo "$SOLANA_DEVNET_WALLET" > ~/.config/solana/id.json

# Configure Solana Devnet
solana config set --url https://api.devnet.solana.com
solana balance