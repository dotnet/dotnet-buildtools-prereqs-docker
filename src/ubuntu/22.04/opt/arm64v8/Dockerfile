FROM ubuntu.azurecr.io/ubuntu:22.04

# Use the approved Azure-hosted Ubuntu mirror (per Network Isolation team guidance).
RUN find /etc/apt -type f \( -name '*.sources' -o -name '*.list' \) -exec sed -i 's|//archive\.ubuntu\.com|//azure.archive.ubuntu.com|g' {} +

RUN apt-get update \
    && apt-get install -y sudo \
    && rm -rf /var/lib/apt/lists/*
