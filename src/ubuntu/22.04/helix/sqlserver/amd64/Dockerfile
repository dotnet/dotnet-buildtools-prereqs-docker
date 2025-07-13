FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-22.04-helix-amd64

USER root

# Install SQL Server and FTS.
RUN apt-get update \
    && apt-get install -qq -y \
        software-properties-common \
    && curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft-prod.gpg \
    && curl -fsSL https://packages.microsoft.com/config/ubuntu/22.04/mssql-server-2022.list | tee /etc/apt/sources.list.d/mssql-server-2022.list \
    && apt-get update \
    && apt-get install -y \
        mssql-server \
        mssql-server-fts \
    && rm -rf /var/lib/apt/lists/*

# Create new user group and add helixbot to it. This user group will have permission to folders which are needed for SQL Server.
RUN groupadd -g 1000 sqlserver_users \
    && usermod -a -G sqlserver_users helixbot \
    # Create required directory to avoid giving permission to /.
    && mkdir /var/opt/mssql/.system/system \
    && chgrp -R sqlserver_users /var/opt/mssql \
    && chmod -R 770 /var/opt/mssql

CMD ["/opt/mssql/bin/sqlservr", "--accept-eula"]

USER helixbot