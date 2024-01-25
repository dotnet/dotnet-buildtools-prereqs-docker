FROM mcr.microsoft.com/dotnet-buildtools/prereqs:fedora-38-local

# Install Helix Dependencies

RUN dnf install -y \
        openssl \
        python3 \
        python3-devel \
        libatomic \
        libffi-devel \
        libmsquic \
        llvm \
        redhat-rpm-config \
        sudo && \
    dnf clean all

RUN dnf remove -y  python3-pip && \
    ln -sf /usr/bin/python3 /usr/bin/python && \
    curl https://bootstrap.pypa.io/get-pip.py -o ./get-pip.py --fail --silent --show-error && \
    python ./get-pip.py && rm ./get-pip.py && \
    python -m pip install --upgrade pip==22.0.4 && \
    python -m pip install virtualenv==20.14.0 && \
    pip download --no-deps helix-scripts --index-url https://dnceng.pkgs.visualstudio.com/public/_packaging/helix-client-prod/pypi/simple && \
    pip install ./helix_scripts-*-py3-none-any.whl

# Add MsQuic 1.9 in addition to 2+
# MsQuic did not publish 1.9 x64 package for Fedora 38
# Use direct link to signed binary from Fedora 34
RUN curl -LO https://packages.microsoft.com/fedora/34/prod/Packages/l/libmsquic-1.9.1-1.x86_64.rpm && \
    rpm -i --force libmsquic-1.9* && \
    rm -f libmsquic-1.9*

# Needed for .NET corefx tests to pass
ENV LANG=en-US.UTF-8

# create helixbot user and give rights to sudo without password
# Fedora does not have all options as other Linux systems
RUN /usr/sbin/adduser --uid 1000 --shell /bin/bash --group adm helixbot && \
    chmod 755 /root && \
    echo "helixbot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers && \
    chmod +s /usr/bin/ping

USER helixbot

RUN python -m virtualenv /home/helixbot/.vsts-env
