FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-16.04-coredeps

# Install the base toolchain we need to build anything (clang, cmake, make and the like).
RUN apt-get update \
    && apt-get install -y \
        apt-transport-https \
        ca-certificates \
        gnupg \
        software-properties-common \
        wget \
    && wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc | apt-key add - \
    && apt-add-repository 'deb https://apt.kitware.com/ubuntu/ xenial main' \
    && apt-get update \
    && apt-get install -y \
        binfmt-support \
        binutils-arm-linux-gnueabihf \
        build-essential \
        cmake \
        debootstrap \
        gdb \
        make \
        qemu \
        qemu-user-static \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt-add-repository 'deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-9 main' \
    && wget -O - http://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - \
    && apt-get update \
    && apt-get install -y \
        clang-9 \
        liblldb-6.0-dev \
        lldb-6.0 \
        llvm-9 \
        python-lldb-6.0 \
    && rm -rf /var/lib/apt/lists/*

# rebuild curl with OpenSSL backend to avoid build issues with GnuTLS.
RUN echo "deb-src http://archive.ubuntu.com/ubuntu/ xenial main restricted" >> /etc/apt/sources.list \
    && echo "deb-src http://archive.ubuntu.com/ubuntu/ xenial-updates multiverse" >>  /etc/apt/sources.list \
    && echo "deb-src http://security.ubuntu.com/ubuntu/ xenial-security universe" >> /etc/apt/sources.list \
    && echo "deb-src http://us.archive.ubuntu.com/ubuntu/ xenial-updates main restricted" >>  /etc/apt/sources.list \
    && apt-get update \
    && mkdir /tmp/curl && cd  /tmp/curl \
    && apt-get source -y curl && apt-get build-dep -y curl &&  apt install -y devscripts \
    && sed -i.ORI -e 's/dh_install\ -pcurl /dh_install /' -e 's/dh_install -plibcurl3/dh_install -pcurl -plibcurl3/'  curl*/debian/rules \
    && (cd curl* && DEB_BUILD_OPTIONS=nocheck debuild -b -uc -us) \
    && dpkg --force-all -i curl_*.deb \
    && curl --version | grep OpenSSL \
    && rm -rf /var/lib/apt/lists/* /tmp/curl

