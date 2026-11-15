ARG BASE_TAG
FROM mcr.microsoft.com/dotnet-buildtools/prereqs:$BASE_TAG

USER root

RUN apk add --no-cache \
        build-base \
        clang \
        compiler-rt \
        lld22 \
        lldb \
        py3-lldb

USER helixbot
