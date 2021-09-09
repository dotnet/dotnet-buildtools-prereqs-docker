FROM mcr.microsoft.com/dotnet-buildtools/prereqs:alpine-3.13

RUN apk update && \
    apk add --no-cache \
        yarn

# We need to pin node.js to v10.24.1, because ExtractFiles AzDO task is currently failing with ENOBUFS
# see https://github.com/microsoft/azure-pipelines-tasks/issues/15261
ARG NODEJS_VERSION=10.24.1

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.1/install.sh | bash; \
    echo 'export NVM_NODEJS_ORG_MIRROR=https://unofficial-builds.nodejs.org/download/release;' >> $HOME/.profile; \
    echo 'nvm_get_arch() { nvm_echo "x64-musl"; }' >> $HOME/.profile; \
    NVM_DIR="$HOME/.nvm"; source $HOME/.nvm/nvm.sh; source $HOME/.profile; \
    nvm install $NODEJS_VERSION

# Add label for bring your own node in azure devops
LABEL "com.azure.dev.pipelines.agent.handler.node.path"="/root/.nvm/versions/node/v$NODEJS_VERSION/bin/node"

# Set node as a default command
CMD [ "node" ]
