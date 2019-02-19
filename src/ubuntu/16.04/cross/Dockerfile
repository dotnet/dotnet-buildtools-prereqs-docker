FROM microsoft/dotnet-buildtools-prereqs:ubuntu-16.04-crossdeps

ADD rootfs.x86.tar crossrootfs
ADD rootfs.arm.tar crossrootfs

# dotnet/iot repo needs libgpiod dependency installed on the arm rootfs
ADD libgpiod/libgpiod.tar /home/temp/libgpiod

RUN cp -r /home/temp/libgpiod/local/lib/* /crossrootfs/arm/usr/local/lib && \
    cp -r /home/temp/libgpiod/local/include/* /crossrootfs/arm/usr/local/include
