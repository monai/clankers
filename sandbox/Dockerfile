ARG UV_VERSION=0.12.23

FROM ghcr.io/astral-sh/uv:${UV_VERSION} AS uv

# ---- base: core tooling, runs as root, no agents ----
FROM debian:trixie-slim AS base

ARG DEBIAN_FRONTEND=noninteractive

COPY rootfs/ /

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    fd-find \
    gh \
    git \
    jq \
    less \
    locales \
    nodejs \
    openssh-client \
    procps \
    python-is-python3 \
    python3 \
    ripgrep \
    unzip \
    xz-utils \
    && rm -rf /var/lib/apt/lists/* \
    && sed -i 's/^# *en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && locale-gen en_US.UTF-8

COPY --from=uv /uv /uvx /usr/local/bin/

ENV LANG=en_US.UTF-8

# ---- slim-root: agent user, coding agents and everyday shell tools (root) ----
FROM base AS slim-root

ARG DEBIAN_FRONTEND=noninteractive
ARG AGENT_UID=1000
ARG AGENT_GID=1000
ARG CLAUDE_CODE_VERSION=2.1.288
ARG CODEX_VERSION=0.160.0
ARG PI_CODING_AGENT_VERSION=1.0.1

RUN apt-get update && apt-get install -y --no-install-recommends \
    apparmor \
    bash-completion \
    bind9-dnsutils \
    docker-cli \
    docker.io \
    file \
    iproute2 \
    iputils-ping \
    lsof \
    make \
    netcat-openbsd \
    patch \
    rsync \
    shellcheck \
    shfmt \
    socat \
    strace \
    sudo \
    time \
    tmux \
    vim \
    xxd \
    zip \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd --gid "$AGENT_GID" agent \
    && useradd --uid "$AGENT_UID" --gid "$AGENT_GID" --groups docker --create-home --shell /bin/bash agent \
    && mkdir -p /home/agent/.local/bin /workspace \
    && chown -R agent:agent /home/agent /workspace \
    && echo "agent ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/agent \
    && chmod 0440 /etc/sudoers.d/agent

RUN npm install -g \
    "@anthropic-ai/claude-code@${CLAUDE_CODE_VERSION}" \
    "@earendil-works/pi-coding-agent@${PI_CODING_AGENT_VERSION}" \
    "@openai/codex@${CODEX_VERSION}" \
    && npm cache clean --force

ENV PATH="/home/agent/.local/bin:$PATH" \
    TERM=xterm-256color \
    COLORTERM=truecolor \
    LESS=-R \
    DISABLE_AUTOUPDATER=1

# ---- full-root: everything else (root) ----
FROM slim-root AS full-root

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    chromium \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

RUN sed -i 's/^CHROMIUM_FLAGS=""/CHROMIUM_FLAGS="--no-sandbox"/' /usr/bin/chromium

ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

# ---- published targets ----
FROM slim-root AS slim
USER agent
WORKDIR /workspace
CMD ["bash"]

FROM full-root AS full
USER agent
WORKDIR /workspace
CMD ["bash"]
