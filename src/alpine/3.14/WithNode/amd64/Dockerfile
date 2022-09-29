FROM mcr.microsoft.com/dotnet-buildtools/prereqs:alpine-3.14-local

RUN apk update && \
    apk add --no-cache \
        yarn

# We need to pin node.js to v10.24.1, because ExtractFiles AzDO task is currently failing with ENOBUFS;
# see https://github.com/microsoft/azure-pipelines-tasks/issues/15261.
ARG NODEJS_VERSION=10.24.1

# yarn has a dependency on node.js LTS version from packages, which gets installed at /usr/bin/node
# so we download and extract the desired node.js version at /usr/share/node/bin/node and symlink
# at /usr/local/bin/node. /usr/local/bin has precedence over /usr/bin in $PATH.
RUN mkdir /usr/share/node && \
    curl -sSL https://unofficial-builds.nodejs.org/download/release/v$NODEJS_VERSION/node-v$NODEJS_VERSION-linux-x64-musl.tar.gz | tar xzf - --strip-components=1 -C /usr/share/node && \
    ln -s /usr/share/node/bin/node /usr/local/bin/node

# Add label for bring your own node in azure devops
LABEL "com.azure.dev.pipelines.agent.handler.node.path"="/usr/local/bin/node"

# Set node as a default command
CMD [ "node" ]
