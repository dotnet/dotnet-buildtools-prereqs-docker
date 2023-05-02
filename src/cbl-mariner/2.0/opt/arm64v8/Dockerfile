FROM mcr.microsoft.com/dotnet-buildtools/prereqs:cbl-mariner-2.0-opt-amd64 as dep

FROM mcr.microsoft.com/cbl-mariner/base/core:2.0

COPY --from=dep /test.txt /test.txt

RUN cat test.txt