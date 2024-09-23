FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-net9.0-crossdeps-builder AS builder

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-net9.0-crossdeps

# Install LLVM that we built from source
COPY --from=builder /usr/local /usr/local
