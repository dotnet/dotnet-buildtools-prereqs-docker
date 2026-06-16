# Dockerfile for binlog-mcp: a Model Context Protocol (MCP) server that exposes
# MSBuild binary log (binlog) inspection tools to AI agents. Intended for use by
# the .NET engineering team's gh-aw agentic CI workflows (build-failure analysis,
# binlog diagnosis). See: https://github.com/dotnet/dotnet-buildtools-prereqs-docker/issues/1659
#
# Usage:  docker run --rm -i -v /path/to/binlogs:/binlogs \
#             mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-binlog-mcp-amd64

ARG BINLOG_MCP_VERSION=1.0.0

# Stage 1: Use the .NET SDK to install the tool. The SDK is required because
# `dotnet tool install` is not available in distroless runtime images.
# The SDK TFM must match the tool's `tools/netX.Y/` folder — the published
# Microsoft.AITools.BinlogMcp package targets net10.0.
FROM mcr.microsoft.com/dotnet/sdk:10.0-azurelinux3.0 AS builder

ARG BINLOG_MCP_VERSION

RUN dotnet tool install \
        --tool-path /tools \
        Microsoft.AITools.BinlogMcp \
        --version ${BINLOG_MCP_VERSION}

# Stage 2: Copy the installed tool into a distroless runtime image to minimise
# attack surface (no shell, no package manager). Per maintainer guidance on #1659.
FROM mcr.microsoft.com/dotnet/runtime:10.0-azurelinux3.0-distroless

COPY --from=builder /tools /tools

ENV PATH="/tools:${PATH}"

ENTRYPOINT ["binlog-mcp"]
