FROM mcr.microsoft.com/devcontainers/python:3.12-trixie

RUN apt-get update
RUN apt-get install --no-install-recommends -y gdal-bin python3-gdal \
    gettext postgresql-client

RUN mkdir -p /workspace \
    && mkdir -p /home/vscode/.ssh \
    && chown vscode:vscode /workspace /home/vscode/.ssh \
    && chmod 700 /home/vscode/.ssh
