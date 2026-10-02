ARG UV_VERSION=0.12.21

FROM ghcr.io/astral-sh/uv:${UV_VERSION} AS uv

FROM debian:trixie-slim

ARG AGENT_UID=1000
ARG AGENT_GID=1000
ARG CLAUDE_CODE_VERSION=2.1.287
ARG CODEX_VERSION=0.159.3
ARG PI_CODING_AGENT_VERSION=1.0.0

COPY rootfs/ /

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash-completion \
    build-essential \
    chromium \
    curl \
    dnsutils \
    fd-find \
    file \
    gh \
    git \
    gnupg \
    iproute2 \
    iputils-ping \
    jq \
    less \
    locales \
    lsof \
    make \
    netcat-openbsd \
    nodejs \
    openssh-client \
    patch \
    pkg-config \
    procps \
    python-is-python3 \
    python3 \
    ripgrep \
    rsync \
    shellcheck \
    shfmt \
    socat \
    sqlite3 \
    strace \
    sudo \
    time \
    tmux \
    tree \
    unzip \
    vim \
    xxd \
    xz-utils \
    yq \
    zip \
    && rm -rf /var/lib/apt/lists/* \
    && sed -i 's/^# *en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && locale-gen en_US.UTF-8

RUN sed -i 's/^CHROMIUM_FLAGS=""/CHROMIUM_FLAGS="--no-sandbox"/' /usr/bin/chromium

COPY --from=uv /uv /uvx /usr/local/bin/

RUN npm install -g \
    "@anthropic-ai/claude-code@${CLAUDE_CODE_VERSION}" \
    "@earendil-works/pi-coding-agent@${PI_CODING_AGENT_VERSION}" \
    "@openai/codex@${CODEX_VERSION}" \
    && npm cache clean --force

ENV PATH="/usr/local/bin:/home/agent/.local/bin:$PATH" \
    TERM=xterm-256color \
    COLORTERM=truecolor \
    LESS=-R \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    DISABLE_AUTOUPDATER=1 \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

RUN groupadd --gid "$AGENT_GID" agent \
    && useradd --uid "$AGENT_UID" --gid "$AGENT_GID" --create-home --shell /bin/bash agent \
    && mkdir -p /home/agent/.local/bin /workspace \
    && chown -R agent:agent /home/agent /workspace \
    && echo "agent ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/agent \
    && chmod 0440 /etc/sudoers.d/agent

USER agent
WORKDIR /workspace
CMD ["bash"]
