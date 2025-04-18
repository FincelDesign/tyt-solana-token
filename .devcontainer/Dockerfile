FROM ubuntu:22.04

# Install basic dependencies as root
RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    pkg-config \
    libssl-dev \
    libudev-dev \
    clang \
    cmake \
    && rm -rf /var/lib/apt/lists/*

# Create the vscode user
RUN groupadd --gid 1000 vscode \
    && useradd --uid 1000 --gid 1000 -m vscode \
    && apt-get update \
    && apt-get install -y sudo \
    && echo "vscode ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/vscode \
    && chmod 0440 /etc/sudoers.d/vscode

# Switch to vscode user
USER vscode
WORKDIR /home/vscode

# Install Rust as vscode user
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/home/vscode/.cargo/bin:${PATH}"

# Install Solana CLI as vscode user
RUN sh -c "$(curl -sSfL https://release.anza.xyz/stable/install)"
ENV PATH="/home/vscode/.local/share/solana/install/active_release/bin:${PATH}"

# Install Anchor as vscode user
RUN cargo install --git https://github.com/coral-xyz/anchor avm --locked --force
RUN avm install 0.31.0
RUN avm use 0.31.0

# Install Node.js and Yarn as vscode user
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - \
    && sudo apt-get install -y nodejs \
    && npm install -g yarn

# Install Solana SPL-Token CLI as vscode user
RUN cargo install spl-token-cli

# Set working directory for the project
WORKDIR /workspaces/tyt-solana-token