FROM almalinux:8

# Install dependencies

RUN dnf install -y 'dnf-command(config-manager)' && \
    dnf config-manager --set-enabled powertools && \
     yum install -y \
        "perl(Time::HiRes)" \
        autoconf \
        automake \
        cmake \
        gdb \
        git \
        glibc-langpack-en \
        jq \
        krb5-devel \
        libcurl-devel \
        libicu-devel \
        libtool \
        libuuid-devel \
        libxml2-devel \
        llvm-toolset \
        lttng-ust-devel \
        make \
        ncurses-devel \
        numactl-devel \
        openssl-devel \
        readline-devel \
        python3 \
        sudo \
        swig \
        wget \
        which \
        xz \
        zlib-devel \
    && \
    yum clean all

ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8  