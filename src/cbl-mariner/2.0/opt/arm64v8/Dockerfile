FROM mcr.microsoft.com/dotnet-buildtools/prereqs:cbl-mariner-2.0-opt-amd64-local as dep

FROM --platform=linux/arm64 mcr.microsoft.com/cbl-mariner/base/core:2.0

COPY --from=dep /test.txt /test.txt

RUN cat test.txt

RUN uname -a