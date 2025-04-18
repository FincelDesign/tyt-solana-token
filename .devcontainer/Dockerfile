FROM ubuntu:22.04

# Install basic dependencies
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

# Install Rust 1.85.0
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain 1.85.0
ENV PATH="/root/.cargo/bin:${PATH}"
RUN rustup component add rustfmt

# Install Solana CLI 2.1.20
RUN sh -c "$(curl -sSfL https://release.anza.xyz/v2.1.20/install)"

# Install Anchor CLI 0.31.0 using Anchor Version Manager (AVM)
RUN cargo install --git https://github.com/coral-xyz/anchor avm --locked --force
RUN avm install 0.31.0
RUN avm use 0.31.0

# Install Node.js and Yarn (for Anchor tests)
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g yarn

# Set up user
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME
USER $USERNAME
ENV HOME=/home/$USERNAME

# Add Solana and Rust to PATH for the user
ENV PATH="/home/$USERNAME/.local/share/solana/install/active_release/bin:/home/$USERNAME/.cargo/bin:${PATH}"