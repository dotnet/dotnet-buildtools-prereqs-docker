FROM mcr.microsoft.com/cbl-mariner/base/core:2.0

# Install Helix Dependencies

ENV LANG=en_US.utf8

RUN tdnf install --setopt tsflags=nodocs --refresh -y \
         ca-certificates-microsoft \
         gcc \
         icu \
         iputils \
         python3-pip \
         shadow-utils \
         tzdata \
         which \
    && tdnf clean all

# Install MsQuic - hack until packages are pushes to mariner repository
# When that is done, this should go to section above.
# Mariner already has MS repos and signing keys.
RUN echo '[packages.microsoft.com_centos_7_prod]' > /etc/yum.repos.d/packages.microsoft.com_centos_7_prod.repo && \
    echo 'name=Centos 7 MS repo' >>  /etc/yum.repos.d/packages.microsoft.com_centos_7_prod.repo && \
    echo 'baseurl=https://packages.microsoft.com/centos/7/prod/' >> /etc/yum.repos.d/packages.microsoft.com_centos_7_prod.repo && \
    echo 'enabled=1' >> /etc/yum.repos.d/packages.microsoft.com_centos_7_prod.repo && \
    tdnf install --setopt tsflags=nodocs --refresh -y libmsquic

RUN ln -sf /usr/bin/python3 /usr/bin/python && \
    python -m pip install --upgrade pip==21.1.2 && \
    python -m pip install virtualenv==16.6.0 && \
    python -m pip install --upgrade setuptools && \
    pip download --no-deps helix-scripts --index-url https://dnceng.pkgs.visualstudio.com/public/_packaging/helix-client-prod/pypi/simple && \
    pip install ./helix_scripts-*-py3-none-any.whl && \
    rm ./helix_scripts-*-py3-none-any.whl

# create helixbot user and give rights to sudo without password
RUN /usr/sbin/useradd -c '' --uid 1000 --shell /bin/bash --groups adm helixbot && \
    chmod 755 /root && \
    echo "helixbot ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers && \
    mkdir /home/helixbot/ && chown -R helixbot /home/helixbot/

USER helixbot

RUN python -m virtualenv --no-site-packages /home/helixbot/.vsts-env
