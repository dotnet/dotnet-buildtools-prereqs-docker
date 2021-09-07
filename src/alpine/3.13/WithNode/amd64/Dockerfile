FROM mcr.microsoft.com/dotnet-buildtools/prereqs:alpine-3.13

RUN apk update && \
    apk add --no-cache \
        nodejs \
        yarn

# Add label for bring your own node in azure devops
LABEL "com.azure.dev.pipelines.agent.handler.node.path"="/usr/bin/node"

# Set node as a default command
CMD [ "node" ]
