FROM mcr.microsoft.com/dotnet-buildtools/prereqs:fedora-34

# Install Helix Dependencies

RUN dnf install -y \
        openssl \
        python3 \
        python3-devel \
        libatomic \
        libffi-devel \
        redhat-rpm-config \
        sudo && \
    dnf clean all

RUN ln -sf /usr/bin/python3 /usr/bin/python && \
    curl https://bootstrap.pypa.io/get-pip.py -o ./get-pip.py --fail --silent --show-error && \
    python ./get-pip.py && rm ./get-pip.py && \
    python -m pip install --upgrade pip==20.2 && \
    python -m pip install virtualenv==16.6.0 && \
    pip download --no-deps helix-scripts --index-url https://dnceng.pkgs.visualstudio.com/public/_packaging/helix-client-prod/pypi/simple && \
    pip install ./helix_scripts-*-py3-none-any.whl

# This is temporary until we have flow to packages.microsoft.com

RUN dnf install -y dotnet gem lttng-tools perl-FindBin rpmdevtools ruby-devel && \
    rpm -i https://github.com/PowerShell/PowerShell/releases/download/v7.0.6/powershell-lts-7.0.6-1.rhel.7.x86_64.rpm && \
    gem  install fpm && \
    git clone --depth 1 --single-branch --branch release/7.0 --recursive https://github.com/dotnet/msquic && \
    cd msquic/src/msquic  &&  PATH=~/.dotnet/tools:$PATH pwsh scripts/build.ps1 -Config Release -DisableLogs && \
    touch artifacts/bin/linux/x64_Release_openssl/libmsquic.lttng.so && ./scripts/make-packages.sh --output /tmp && \
    rpm -i /tmp/libmsquic*rpm  && \
    cd ~ ; rm -rf msquic /tmp/libmsquic* && \
    rpm -e powershell-lts dotnet lttng-tools perl-FindBin rpmdevtools ruby-devel && \
    dnf clean all

# Needed for .NET corefx tests to pass
ENV LANG=en-US.UTF-8

# create helixbot user and give rights to sudo without password
# Fedora does not have all options as other Linux systems
RUN /usr/sbin/adduser --uid 1000 --shell /bin/bash --group adm helixbot && \
    chmod 755 /root && \
    echo "helixbot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers && \
    chmod +s /usr/bin/ping

USER helixbot

RUN python -m virtualenv --no-site-packages /home/helixbot/.vsts-env
