#!/bin/bash

set -e  # Exit on error

echo "🔧 Updating system packages..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl git build-essential pkg-config libssl-dev libudev-dev protobuf-compiler

# Ensure Rust is initialized
echo "🔧 Forcing Rust initialization..."
rustup show > /dev/null || true

# Source Rust environment if available
if [ -f "$HOME/.cargo/env" ]; then
  source "$HOME/.cargo/env"
else
  echo "⚠️  Rust env file not found. Skipping source."
fi

# Install Solana CLI using new official URL
echo "🔧 Installing latest stable Solana CLI (via Anza installer)..."
sh -c "$(curl -sSfL https://release.anza.xyz/stable/install)"

# Add Solana CLI to PATH for current and future sessions
export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"
echo 'export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"' >> ~/.bashrc

# Confirm Solana CLI install
if ! command -v solana &> /dev/null; then
  echo "❌ Solana CLI not found after install."
  exit 1
else
  echo "✅ Solana CLI installed: $(solana --version)"
fi

# Install Anchor CLI
echo "🔧 Installing Anchor CLI v0.31.1..."
cargo install --git https://github.com/coral-xyz/anchor --tag v0.31.1 anchor-cli --locked --force
echo "✅ Anchor CLI installed: $(anchor --version)"

# Install Yarn
echo "🔧 Installing Yarn v1.22.1..."
npm uninstall -g yarn || true
npm install -g yarn@1.22.1
echo "✅ Yarn installed: $(yarn --version)"

# Install SPL Token CLI
echo "🔧 Installing SPL Token CLI..."
cargo install spl-token-cli --locked --force
echo "✅ SPL Token CLI installed: $(spl-token --version)"

# Restore Solana wallet if provided
echo "🔐 Restoring Solana wallet..."
if [ -z "$SOLANA_DEVNET_WALLET" ]; then
  echo "⚠️  SOLANA_DEVNET_WALLET is not set. Skipping wallet restore."
else
  mkdir -p ~/.config/solana
  echo "$SOLANA_DEVNET_WALLET" > ~/.config/solana/id.json
  echo "✅ Wallet restored to ~/.config/solana/id.json"
fi

# Configure Solana to use Devnet
echo "🌐 Setting Solana config to Devnet..."
solana config set --url https://api.devnet.solana.com

# Confirm all key versions
echo "📦 Installed Tool Versions:"
rustc --version
cargo --version
solana --version
anchor --version
node --version
yarn --version

echo "✅ Environment setup complete."
