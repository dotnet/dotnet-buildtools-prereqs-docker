FROM mcr.microsoft.com/dotnet-buildtools/prereqs:fedora-32

# Add MS package repo
RUN dnf config-manager --add-repo https://packages.microsoft.com/fedora/32/prod/ && \
    echo > /tmp/microsoft.asc && \
    echo "-----BEGIN PGP PUBLIC KEY BLOCK-----" > /tmp/microsoft.asc && \
    echo "Version: GnuPG v1.4.7 (GNU/Linux)" >> /tmp/microsoft.asc && \
    echo >> /tmp/microsoft.asc && \
    echo "mQENBFYxWIwBCADAKoZhZlJxGNGWzqV+1OG1xiQeoowKhssGAKvd+buXCGISZJwT" >> /tmp/microsoft.asc && \
    echo "LXZqIcIiLP7pqdcZWtE9bSc7yBY2MalDp9Liu0KekywQ6VVX1T72NPf5Ev6x6DLV" >> /tmp/microsoft.asc && \
    echo "7aVWsCzUAF+eb7DC9fPuFLEdxmOEYoPjzrQ7cCnSV4JQxAqhU4T6OjbvRazGl3ag" >> /tmp/microsoft.asc && \
    echo "OeizPXmRljMtUUttHQZnRhtlzkmwIrUivbfFPD+fEoHJ1+uIdfOzZX8/oKHKLe2j" >> /tmp/microsoft.asc && \
    echo "H632kvsNzJFlROVvGLYAk2WRcLu+RjjggixhwiB+Mu/A8Tf4V6b+YppS44q8EvVr" >> /tmp/microsoft.asc && \
    echo "M+QvY7LNSOffSO6Slsy9oisGTdfE39nC7pVRABEBAAG0N01pY3Jvc29mdCAoUmVs" >> /tmp/microsoft.asc && \
    echo "ZWFzZSBzaWduaW5nKSA8Z3Bnc2VjdXJpdHlAbWljcm9zb2Z0LmNvbT6JATUEEwEC" >> /tmp/microsoft.asc && \
    echo "AB8FAlYxWIwCGwMGCwkIBwMCBBUCCAMDFgIBAh4BAheAAAoJEOs+lK2+EinPGpsH" >> /tmp/microsoft.asc && \
    echo "/32vKy29Hg51H9dfFJMx0/a/F+5vKeCeVqimvyTM04C+XENNuSbYZ3eRPHGHFLqe" >> /tmp/microsoft.asc && \
    echo "MNGxsfb7C7ZxEeW7J/vSzRgHxm7ZvESisUYRFq2sgkJ+HFERNrqfci45bdhmrUsy" >> /tmp/microsoft.asc && \
    echo "7SWw9ybxdFOkuQoyKD3tBmiGfONQMlBaOMWdAsic965rvJsd5zYaZZFI1UwTkFXV" >> /tmp/microsoft.asc && \
    echo "KJt3bp3Ngn1vEYXwijGTa+FXz6GLHueJwF0I7ug34DgUkAFvAs8Hacr2DRYxL5RJ" >> /tmp/microsoft.asc && \
    echo "XdNgj4Jd2/g6T9InmWT0hASljur+dJnzNiNCkbn9KbX7J/qK1IbR8y560yRmFsU+" >> /tmp/microsoft.asc && \
    echo "NdCFTW7wY0Fb1fWJ+/KTsC4=" >> /tmp/microsoft.asc && \
    echo "=J6gs" >> /tmp/microsoft.asc && \
    echo "-----END PGP PUBLIC KEY BLOCK-----"  >> /tmp/microsoft.asc && \
    rpm --import /tmp/microsoft.asc

# Install Helix Dependencies

RUN dnf install -y \
        python3 \
        python3-devel \
        libffi-devel \
        libmsquic \
        redhat-rpm-config \
        sudo \
    && dnf clean all

RUN ln -sf /usr/bin/python3 /usr/bin/python && \
    curl https://bootstrap.pypa.io/get-pip.py -o ./get-pip.py --fail --silent --show-error && \
    python ./get-pip.py && rm ./get-pip.py && \
    python -m pip install --upgrade pip==20.2 && \
    python -m pip install virtualenv==16.6.0 && \
    pip download --no-deps helix-scripts --index-url https://dnceng.pkgs.visualstudio.com/public/_packaging/helix-client-prod/pypi/simple && \
    pip install ./helix_scripts-*-py3-none-any.whl

# Needed for .NET corefx tests to pass
ENV LANG=en-US.UTF-8

# create helixbot user and give rights to sudo without password
# Fedora does not have all options as other Linux systems
RUN /usr/sbin/adduser --uid 1000 --shell /bin/bash --group adm helixbot && \
    chmod 755 /root && \
    echo "helixbot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers

USER helixbot

RUN python -m virtualenv --no-site-packages /home/helixbot/.vsts-env
