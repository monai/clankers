FROM debian:trixie-slim

ARG AGENT_UID=1000
ARG AGENT_GID=1000
ARG CLAUDE_CODE_VERSION=2.1.241
ARG CODEX_VERSION=0.149.0
ARG PI_CODING_AGENT_VERSION=0.84.2
ARG UV_VERSION=0.12.5

COPY rootfs/ /

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash-completion \
    build-essential \
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

RUN set -eux; \
    case "$(dpkg --print-architecture)" in \
      amd64) uv_arch="x86_64" ;; \
      arm64) uv_arch="aarch64" ;; \
      *) echo "unsupported uv architecture: $(dpkg --print-architecture)" >&2; exit 1 ;; \
    esac; \
    uv_asset="uv-${uv_arch}-unknown-linux-gnu.tar.gz"; \
    uv_url="https://github.com/astral-sh/uv/releases/download/${UV_VERSION}/${uv_asset}"; \
    curl -fsSLo "/tmp/${uv_asset}" "$uv_url"; \
    curl -fsSLo "/tmp/${uv_asset}.sha256" "${uv_url}.sha256"; \
    cd /tmp; \
    sha256sum -c "${uv_asset}.sha256"; \
    tar -xzf "$uv_asset"; \
    install -m 0755 "uv-${uv_arch}-unknown-linux-gnu/uv" /usr/local/bin/uv; \
    install -m 0755 "uv-${uv_arch}-unknown-linux-gnu/uvx" /usr/local/bin/uvx; \
    rm -rf "/tmp/${uv_asset}" "/tmp/${uv_asset}.sha256" "/tmp/uv-${uv_arch}-unknown-linux-gnu"

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
    DISABLE_AUTOUPDATER=1

RUN groupadd --gid "$AGENT_GID" agent \
    && useradd --uid "$AGENT_UID" --gid "$AGENT_GID" --create-home --shell /bin/bash agent \
    && mkdir -p /home/agent/.local/bin /workspace \
    && chown -R agent:agent /home/agent /workspace \
    && echo "agent ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/agent \
    && chmod 0440 /etc/sudoers.d/agent

USER agent
WORKDIR /workspace
CMD ["bash"]
