FROM mcr.microsoft.com/dotnet-buildtools/prereqs:fedora-36

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

RUN dnf remove -y  python3-pip && \
    ln -sf /usr/bin/python3 /usr/bin/python && \
    curl https://bootstrap.pypa.io/get-pip.py -o ./get-pip.py --fail --silent --show-error && \
    python ./get-pip.py && rm ./get-pip.py && \
    python -m pip install --upgrade pip==22.0.4 && \
    python -m pip install virtualenv==20.14.0 && \
    pip download --no-deps helix-scripts --index-url https://dnceng.pkgs.visualstudio.com/public/_packaging/helix-client-prod/pypi/simple && \
    pip install ./helix_scripts-*-py3-none-any.whl

# There is problem with signature on 2.0 package. --nogpgcheck should be removed once resolved.
RUN dnf install -y --nogpgcheck libmsquic && \
    dnf download libmsquic-1.9* && \
    rpm -i --force libmsquic-1.9* && \
    rm -f libmsquic-1.9* && \
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

RUN python -m virtualenv /home/helixbot/.vsts-env
