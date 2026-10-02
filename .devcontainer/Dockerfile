FROM mcr.microsoft.com/devcontainers/python:3.12-trixie

RUN apt-get update
RUN apt-get install --no-install-recommends -y gdal-bin python3-gdal \
    gettext postgresql-client

RUN mkdir -p /workspace \
    && chown vscode:vscode /workspace
