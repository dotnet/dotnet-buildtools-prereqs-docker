FROM mcr.microsoft.com/dotnet-buildtools/prereqs:alpine-3.14
RUN apk update && apk add --no-cache \
    cargo \
    iputils \
    libffi-dev \
    rust

# Install Helix Dependencies

RUN ln -sf /usr/bin/python3 /usr/bin/python && \
    curl https://bootstrap.pypa.io/get-pip.py -o ./get-pip.py --fail --silent --show-error && \
    python ./get-pip.py && rm ./get-pip.py && \
    python -m pip install --upgrade pip==21.2.4 && \
    python -m pip install virtualenv==16.6.0 && \
    pip download --no-deps helix-scripts --index-url https://dnceng.pkgs.visualstudio.com/public/_packaging/helix-client-prod/pypi/simple && \
    pip install ./helix_scripts-*-py3-none-any.whl

# build MsQuic as we don't have packages
RUN cd /tmp && \
    mkdir pwsh && \
    cd pwsh && \
    curl -L https://github.com/PowerShell/PowerShell/releases/download/v7.2.5/powershell-7.2.5-linux-alpine-x64.tar.gz | tar xfz - && \
    cd .. && \
    git clone --depth 1 --single-branch --branch release/7.0 --recursive https://github.com/dotnet/msquic && \
    cd msquic/src/msquic  &&  PATH=~/.dotnet/tools:$PATH /tmp/pwsh/pwsh scripts/build.ps1 -Config Release && \
    cp artifacts/bin/linux/x64_Release_openssl/libmsquic.so.2 artifacts/bin/linux/x64_Release_openssl/libmsquic.lttng.so.2.1.0 /usr/lib && \
    cd /tmp && \
    rm -r pwsh msquic

# Needed for corefx tests to pass
ENV LANG=en-US.UTF-8

# create helixbot user and give rights to sudo without password
# Alpine does not support long options
RUN /usr/sbin/adduser -D -g '' -G adm -s /bin/bash -u 1000 helixbot && \
    chmod 755 /root && \
    echo "helixbot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/helixbot

USER helixbot

RUN python -m virtualenv --no-site-packages /home/helixbot/.vsts-env
