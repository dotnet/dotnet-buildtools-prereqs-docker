FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-net10.0-crossdeps-builder-amd64 AS builder

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-net10.0-crossdeps-amd64

# dummy change to retrigger the build for new architecture added in crossdeps-builder
# Install LLVM that we built from source
COPY --from=builder /usr/local /usr/local
