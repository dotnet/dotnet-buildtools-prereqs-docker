FROM mcr.microsoft.com/dotnet-buildtools/prereqs:cbl-mariner-2.0-cross-amd64-alpine-local AS crossrootbiarch

FROM mcr.microsoft.com/dotnet-buildtools/prereqs:cbl-mariner-2.0-cross-amd64

# Copy crossrootfs from Alpine build image, so we can build and cross-compile
# cross compilers within the same build system (e.g. required for Node.js)
COPY --from=crossrootbiarch /crossrootfs/x64 /crossrootfs/x64-alpine
