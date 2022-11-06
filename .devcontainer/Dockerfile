# Note: You can use any Debian/Ubuntu based image you want. 
FROM mcr.microsoft.com/vscode/devcontainers/base:0-bullseye

# Install needed packages and setup non-root user. Use a separate RUN statement to add your
# own dependencies. A user of "automatic" attempts to reuse an user ID if one already exists.
ARG USERNAME=automatic
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Build vlmcs, it been used to check if the KMS server is running.
ARG VLMCSD_VERSION=svn1113
RUN mkdir -p /workspaces/vlmcsd && cd /workspaces/vlmcsd \
    && git clone -b ${VLMCSD_VERSION} https://github.com/Wind4/vlmcsd.git . \
    && make && mv bin/vlmcs /usr/bin/vlmcs \
    && rm -rf /workspaces/vlmcsd

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>
