FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-18.04-helix-amd64

USER root

# Install SqlServer 2019 and FTS
RUN apt-get update \
    && apt-get install -qq -y \
        software-properties-common \
        wget \
    && wget -qO- https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && add-apt-repository "$(wget -qO- https://packages.microsoft.com/config/ubuntu/18.04/mssql-server-2019.list)" \
    && apt-get update \
    && apt-get install -qq -y \
        mssql-server \
        mssql-server-fts \
    && rm -rf /var/lib/apt/lists/*

 # Create new user group and add helixbot to it. This user group will have permission to folders which are needed for SqlServer
RUN groupadd -g 1000 sqlserver_users \
    && usermod -a -G sqlserver_users helixbot \
    # Create required directory to avoid giving permission to /
    && mkdir /.system \
    && chgrp -R sqlserver_users /.system \
    && chgrp -R sqlserver_users /var/opt/mssql \
    && chmod 770 /.system \
    && chmod 770 /var/opt/mssql

CMD ["/opt/mssql/bin/sqlservr"]

USER helixbot
