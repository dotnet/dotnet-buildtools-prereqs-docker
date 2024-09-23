FROM mcr.microsoft.com/dotnet-buildtools/prereqs:alpine-3.18

RUN apk add --upgrade --no-cache \
        nodejs \
        npm

# Add label for bring your own node in azure devops
LABEL "com.azure.dev.pipelines.agent.handler.node.path"="/usr/bin/node"

ENV NO_UPDATE_NOTIFIER=true

# Set node as a default command
CMD [ "node" ]
