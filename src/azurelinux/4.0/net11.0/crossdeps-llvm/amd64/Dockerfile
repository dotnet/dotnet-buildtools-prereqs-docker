FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-4.0-net11.0-crossdeps-builder-amd64 AS builder

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-4.0-net11.0-crossdeps-amd64

# Install LLVM that we built from source
COPY --from=builder /opt/llvm /usr/local
