FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-18.04-helix-amd64

USER root

# Install SqlServer 2019 and FTS
RUN apt-get update && \
    apt-get install -qq -y \
        software-properties-common \
        wget \
    && wget -qO- https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    add-apt-repository "$(wget -qO- https://packages.microsoft.com/config/ubuntu/18.04/mssql-server-2019.list)" && \
    apt-get update && \
    apt-get install -qq -y \
        mssql-server \
        mssql-server-fts \
    && rm -rf /var/lib/apt/lists/*

CMD [ "/opt/mssql/bin/sqlservr" ]

USER helixbot