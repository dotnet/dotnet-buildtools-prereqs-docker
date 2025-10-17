FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-net11.0-cross-amd64 AS crossrootx64

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-net11.0-android-amd64

# Copy crossrootfs from AMD64 build image, so we can build Android-targeting code for that arch
COPY --from=crossrootx64 /crossrootfs/x64 /crossrootfs/x64
