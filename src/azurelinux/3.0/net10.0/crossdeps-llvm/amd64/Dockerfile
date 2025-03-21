FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-net10.0-crossdeps-builder-amd64 AS builder

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-net10.0-crossdeps-amd64

# dummy change to trigger cross/ images build after llvm update

# Install LLVM that we built from source
COPY --from=builder /opt/llvm /usr/local
