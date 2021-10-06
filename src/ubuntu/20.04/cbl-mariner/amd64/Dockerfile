FROM amd64/ubuntu:focal

# CBL-Mariner toolkit dependencies documented at https://github.com/microsoft/CBL-MarinerDemo/blob/main/README.md#install-tools

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        software-properties-common \
    && add-apt-repository -y ppa:longsleep/golang-backports \
    && apt-get update \
    && apt-get install -y \
        cpio \
        curl \
        genisoimage \
        git \
        golang-1.13-go \
        jq \
        make \
        pigz \
        python3 \
        qemu-utils \
        rpm \
        tar \
        wget \
    && rm -rf /var/lib/apt/lists/* \
    && ln -vs /usr/lib/go-1.13/bin/go /usr/bin/go
