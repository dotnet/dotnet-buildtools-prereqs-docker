FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-crossdeps-builder-net8.0-local AS builder

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-crossdeps-local

# Install LLVM that we built from source
COPY --from=builder /usr/local /usr/local
