FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-net10.0-build-aot-test-amd64

# Host-native NativeAOT and Nginx tests only. Deployment artifacts require a cross-build image and compatibility sysroot.
# Node.js 26 requires libatomic, and Java builds require a JDK.
RUN tdnf update -y && \
    tdnf install -y \
        libgcc-atomic \
        msopenjdk-25 \
        nginx \
    && tdnf clean all

ENV JAVA_HOME=/usr/lib/jvm/msopenjdk-25
ENV PATH=$JAVA_HOME/bin:$PATH

# Nginx opens its default error log before loading the tests' non-root configuration.
RUN ln -s /dev/stderr /var/log/nginx/error.log
