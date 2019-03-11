FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-16.04-arm64v8

# Install Helix Dependencies

RUN apt-get update \
    && apt-get install -qq -y \
        libunwind-dev \
        libcurl3 \
        gss-ntlmssp \
        libgdiplus \
        python-dev \
        libunwind8 \
        libssl-dev \
        unzip \
        libicu-dev \
        libffi-dev \
        python-pip \
        locales \
        locales-all \
        tzdata \
        iputils-ping \
    && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG en_US.utf8

RUN python -m pip install --upgrade pip==19.0.2 && \
    python -m pip install \ 
                  applicationinsights==0.11.7 \
                  certifi==2018.11.29 \
                  cryptography==2.5 \                  
                  docker==3.6.0 \
                  ndg-httpsclient==0.5.1  \
                  psutil==5.4.8 \
                  pyasn1==0.4.5 \
                  pyopenssl==18.0.0 \
                  requests==2.21.0 \
                  six==1.12.0 \
                  virtualenv==16.2.0