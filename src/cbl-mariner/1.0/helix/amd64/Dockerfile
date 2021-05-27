FROM cblmariner.azurecr.io/cblmariner:1.0

# Install Helix Dependencies

ENV LANG=en_US.utf8

RUN tdnf install -y python3-pip

RUN ln -sf /usr/bin/python3 /usr/bin/python && \
    python -m pip install --upgrade pip==21.1.2 && \
    python -m pip install virtualenv==16.6.0 && \
    python -m pip install --upgrade setuptools && \
    pip download --no-deps helix-scripts --index-url https://dnceng.pkgs.visualstudio.com/public/_packaging/helix-client-prod/pypi/simple && \ 
    pip install ./helix_scripts-*-py3-none-any.whl

# create helixbot user and give rights to sudo without password
RUN /usr/sbin/useradd -c '' --uid 1000 --shell /bin/bash --groups adm helixbot && \
    chmod 755 /root && \
    echo "helixbot ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers && \
    mkdir /home/helixbot/ && chown -R helixbot /home/helixbot/

USER helixbot

RUN python -m virtualenv --no-site-packages /home/helixbot/.vsts-env
