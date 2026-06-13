FROM ubuntu:24.04

ARG AGENT
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    sudo \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -d /home/agent -s /bin/bash agent \
    && echo "agent ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/agent \
    && chmod 0440 /etc/sudoers.d/agent \
    && mkdir -p /workspace \
    && chown agent:agent /workspace

USER agent

ENV HOME=/home/agent
ENV PATH="/home/agent/.local/bin:${PATH}"

RUN set -eux; \
    case "$AGENT" in \
      claude) \
        curl -fsSL https://claude.ai/install.sh -o /tmp/install.sh; \
        bash /tmp/install.sh ;; \
      codex) \
        curl -fsSL https://chatgpt.com/codex/install.sh -o /tmp/install.sh; \
        CODEX_NON_INTERACTIVE=1 sh /tmp/install.sh ;; \
      antigravity) \
        curl -fsSL https://antigravity.google/cli/install.sh | bash ;; \
      *) \
        echo "Invalid AGENT: use 'claude', 'codex', or 'antigravity'" >&2; \
        exit 1 ;; \
    esac; \
    rm -f /tmp/install.sh

WORKDIR /workspace

CMD ["sleep", "infinity"]