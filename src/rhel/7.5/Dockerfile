FROM registry.access.redhat.com/rhel7.5

# Disable repository with undesired packages.
RUN yum-config-manager --disable rhel-7-server-rt-beta-rpms

# Install the base toolchain we need to build anything (clang, cmake, make and the like)
# this does not include libraries that we need to compile different projects, we'd like
# them in a different layer.

# --- Toolchain from RHEL-7 software collection ---
RUN yum updateinfo \
    && yum-config-manager --enable rhel-7-server-devtools-rpms \
    && yum install -y rh-dotnet20-jsoncpp --enablerepo=rhel-7-server-dotnet-rpms \
        cmake \
        llvm-toolset-7-clang.x86_64 \
        llvm-toolset-7-clang-libs.x86_64 \
        llvm-toolset-7-lldb.x86_64 \
        llvm-toolset-7-lldb-devel.x86_64 \
        llvm-toolset-7-llvm.x86_64 \
        llvm-toolset-7-llvm-libs.x86_64 \
        wget \
        which \
        make \
    && yum clean all

# Needed by coreclr build to discover llvm-toolset-7 clang, and includes.
ENV PATH="/opt/rh/llvm-toolset-7/root/usr/bin:${PATH}" \
    CMAKE_INCLUDE_PATH="/opt/rh/llvm-toolset-7/root/usr/include"

# Install tools used by the VSO build automation.  We use NodeJS from nodesource.com.
RUN yum install -y https://rpm.nodesource.com/pub_0.10/el/7/x86_64/nodesource-release-el7-1.noarch.rpm \
    && yum updateinfo \
    && yum install -y git \
        zip \
        tar \
        nodejs \
        patch \
    && yum clean all \
    && npm install -g azure-cli

# Dependencies of CoreCLR and CoreFX.  Everything except lttng is present in RHEL, for lttng we
# get the development packages from EfficiOS.
RUN wget -P /etc/yum.repos.d/ https://packages.efficios.com/repo.files/EfficiOS-RHEL7-x86-64.repo \
    && rpmkeys --import https://packages.efficios.com/rhel/repo.key \
    && yum updateinfo \
    && yum install --enablerepo=rhel-7-server-optional-rpms -y \
        libicu-devel \
        libuuid-devel \
        libcurl-devel \
        openssl-devel \
        libunwind-devel \
        lttng-ust-devel \
    && yum clean all

# Define the en_US.UTF-8 locale.  (Without this, processes MSBuild tries to launch complain about
# being unable to use the en_US.UTF-8 locale which can cause downstream failures if you capture
# the output of a run.)
RUN localedef -c -i en_US -f UTF-8 en_US.UTF-8
