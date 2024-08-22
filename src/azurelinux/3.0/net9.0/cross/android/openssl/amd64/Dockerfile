FROM mcr.microsoft.com/dotnet-buildtools/prereqs:azurelinux-3.0-net9.0-cross-android-amd64-local

# Copy the OpenSSL headers and libs from the x64 rootfs into the Anroid NDK so dotnet/runtime's
# OpenSSL headers hack can find them for the linux-bionic build.
RUN mkdir -p /usr/local/android-ndk/usr/local/include && \
    mkdir /usr/local/android-ndk/usr/local/lib && \
    cp -r /crossrootfs/x64/usr/include/openssl  /usr/local/android-ndk/usr/local/include/openssl && \
    cp -r /crossrootfs/x64/usr/include/x86_64-linux-gnu/openssl  /usr/local/android-ndk/usr/local/include && \
    cp -r $(readlink -f /crossrootfs/x64/usr/lib/x86_64-linux-gnu/libssl.so)  /usr/local/android-ndk/usr/local/lib/libssl.so && \
    cp -r $(readlink -f /crossrootfs/x64/usr/lib/x86_64-linux-gnu/libcrypto.so)  /usr/local/android-ndk/usr/local/lib/libcrypto.so
