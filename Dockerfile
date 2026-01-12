# syntax=docker/dockerfile:1
FROM docker.io/debian:trixie

ARG DEBIAN_FRONTEND="noninteractive"

RUN <<EOT
    set -o errexit && \
    apt-get update && \
    apt-get install --yes --no-install-recommends \
        bc \
        bzip2 \
        ca-certificates \
        curl \
        dnsutils \
        gh \
        git \
        jq \
        less \
        libxcb1 \
        lsof \
        man-db \
        procps \
        psmisc \
        ripgrep \
        rsync \
        socat \
        tree \
        unzip \
        vim \
        zip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
EOT

COPY --from=mikefarah/yq /usr/bin/yq /usr/local/bin/
COPY --from=denoland/deno:bin-2.6.4 /deno /usr/local/bin/
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /usr/local/bin/
COPY --from=oven/bun:1 /usr/local/bin/bun /usr/local/bin/

ARG APP_UID="2000"
ARG APP_GID="2000"
ARG APP_USER="goose"

RUN \
    groupadd \
      --gid "${APP_GID}" "${APP_USER}" && \
    useradd \
      --gid "${APP_GID}" \
      --uid "${APP_UID}" \
      --comment "" \
      --shell /bin/bash \
      --create-home \
      "${APP_USER}"

WORKDIR /workspace

RUN chown --recursive "${APP_USER}:${APP_USER}" /workspace

USER "${APP_USER}"

RUN <<EOT
    set -o errexit -o pipefail && \
    curl \
        --fail \
        --silent \
        --show-error \
        --location \
        "https://github.com/block/goose/releases/download/stable/download_cli.sh" | \
    CONFIGURE=false bash
EOT

ENV HOME="/home/${APP_USER}"
ENV PATH="${HOME}/.local/bin:${PATH}"
ENV GOOSE_HOME="${HOME}"
ENV EDITOR="vim"
ENV GOOSE_DISABLE_KEYRING="1"

ENTRYPOINT ["goose"]
