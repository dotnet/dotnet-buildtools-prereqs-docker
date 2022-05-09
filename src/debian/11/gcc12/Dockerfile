FROM gcc:12-bullseye

# Dependencies for dotnet/runtime native components.
RUN apt-get update && \
    apt-get install -y \
        cmake \
        curl \
        gdb \
        git \
        iputils-ping \
        libicu-dev \
        libkrb5-dev \
        liblttng-ust-dev \
        libssl-dev \
        liblldb-dev \
        lttng-tools \
        locales \
        locales-all \
        python3-dev \
        python3-pip \
        sudo \
        tzdata \
    && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG=en_US.utf8

# These symlinks are required because this docker has gcc-10 suffixed with version and gcc-12 unsuffixed in PATH.
# In the runtime repo, we (by design) give precedence to suffixed compilers before selecting unsuffixed one in PATH.
RUN ln -s $(command -v gcc) /usr/bin/gcc-12 && \
    ln -s $(command -v g++) /usr/bin/g++-12
