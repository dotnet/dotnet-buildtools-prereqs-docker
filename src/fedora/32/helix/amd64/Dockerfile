FROM mcr.microsoft.com/dotnet-buildtools/prereqs:fedora-32

# Install Helix Dependencies

RUN dnf install -y \
        python3 \
        python3-devel \
        redhat-rpm-config \
        sudo \
    && dnf clean all

RUN ln -sf /usr/bin/python3 /usr/bin/python && \
    curl https://bootstrap.pypa.io/get-pip.py -o ./get-pip.py && \
    python ./get-pip.py && rm ./get-pip.py && \
    python -m pip install --upgrade pip==20.1 && \
    python -m pip install virtualenv==20.0.20 && \
    python -m pip install helix-scripts --extra-index-url https://dnceng.pkgs.visualstudio.com/public/_packaging/helix-client-prod/pypi/simple

# Needed for .NET corefx tests to pass
ENV LANG=en-US.UTF-8

# create helixbot user and give rights to sudo without password
# Fedora does not have all options as other Linux systems
RUN /usr/sbin/adduser --uid 1000 --shell /bin/bash --group adm helixbot && \
    chmod 755 /root && \
    echo "helixbot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers

USER helixbot

RUN python -m virtualenv --no-site-packages /home/helixbot/.vsts-env