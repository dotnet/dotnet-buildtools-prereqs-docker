FROM fedora:29

# Install the base toolchain we need to build anything (clang, cmake, make and the like)
# this does not include libraries that we need to compile different projects, we'd like
# them in a different layer.
RUN dnf install -y \
        clang \
        cmake \
        findutils \
        gdb \
        lldb-devel \
        llvm-devel \
        make \
        python \
        python2-devel \
        python2-lldb \
        which \
    && dnf clean all

# Install tools used by build automation.
RUN dnf install -y \
        git \
        tar \
        procps \
        zip \
    && dnf clean all

# Dependencies of CoreCLR and CoreFX.
RUN dnf install -y \
        compat-openssl10-devel \
        glibc-locale-source \
        krb5-devel \
        libcurl-devel \
        libgdiplus \
        libicu-devel \
        libunwind-devel \
        libuuid-devel \
        lttng-ust-devel \
        uuid-devel \
        redhat-rpm-config \
    && dnf clean all

# Until official packages are available, we have to restore the ubuntu ones instead.
ENV __PUBLISH_RID=ubuntu.14.04-x64

# Install Helix Dependencies

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
