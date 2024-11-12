FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-net10.0-cross-amd64 AS crossrootx64

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-net10.0-android

# Copy crossrootfs from AMD64 build image, so we can build Android-targeting code for that arch
COPY --from=crossrootx64 /crossrootfs/x64 /crossrootfs/x64
