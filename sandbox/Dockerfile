FROM nixos/nix:2.35.1-arm64 AS builder

ENV NIX_CONFIG="experimental-features = nix-command flakes" \
    DISABLE_AUTOUPDATER=1

COPY flake.nix /tmp/sandbox-nix/flake.nix

RUN set -eux; \
    cd /tmp/sandbox-nix; \
    nix flake lock; \
    nix profile add --profile /nix/var/nix/profiles/sandbox .#sandbox-tools; \
    /nix/var/nix/profiles/sandbox/bin/node --version; \
    /nix/var/nix/profiles/sandbox/bin/python --version; \
    /nix/var/nix/profiles/sandbox/bin/uv --version; \
    /nix/var/nix/profiles/sandbox/bin/pi --version; \
    /nix/var/nix/profiles/sandbox/bin/codex --version; \
    /nix/var/nix/profiles/sandbox/bin/claude --version; \
    cd /; \
    nix-store --query --requisites /nix/var/nix/profiles/sandbox > /tmp/nix-store-paths; \
    mkdir -p /tmp/final-root/nix/var/nix/profiles; \
    xargs -a /tmp/nix-store-paths -r cp -a --parents -t /tmp/final-root; \
    cp -a /nix/var/nix/profiles/sandbox* /tmp/final-root/nix/var/nix/profiles/; \
    rm -rf /tmp/sandbox-nix /root/.cache

FROM debian:trixie-slim

ARG AGENT_UID=1000
ARG AGENT_GID=1000

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    fd-find \
    file \
    gh \
    git \
    jq \
    less \
    openssh-client \
    patch \
    procps \
    ripgrep \
    rsync \
    shellcheck \
    shfmt \
    sqlite3 \
    sudo \
    tmux \
    tree \
    unzip \
    vim \
    xxd \
    xz-utils \
    yq \
    zip \
    && rm -rf /var/lib/apt/lists/*

ENV PATH="/nix/var/nix/profiles/sandbox/bin:/usr/local/bin:/home/agent/.local/bin:$PATH" \
    LD_LIBRARY_PATH=/nix/var/nix/profiles/sandbox/lib \
    NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt \
    TERM=xterm-256color \
    COLORTERM=truecolor \
    LESS=-R \
    DISABLE_AUTOUPDATER=1

COPY --from=builder /tmp/final-root/ /

RUN groupadd --gid "$AGENT_GID" agent \
    && useradd --uid "$AGENT_UID" --gid "$AGENT_GID" --create-home --shell /bin/bash agent \
    && mkdir -p /home/agent/.local/bin /workspace \
    && chown -R agent:agent /home/agent /workspace \
    && echo "agent ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/agent \
    && chmod 0440 /etc/sudoers.d/agent

USER agent
WORKDIR /workspace
CMD ["bash"]
