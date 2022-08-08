FROM mcr.microsoft.com/dotnet-buildtools/prereqs:ubuntu-20.04-crossdeps

ADD rootfs.riscv64.tar crossrootfs

# Install llvm 15 so we get the 'Relax R_RISCV_ALIGN' fix 
#   * https://github.com/llvm/llvm-project/issues/44181
#   * https://github.com/llvm/llvm-project/commit/6611d58f5bbcbec77262d392e2923e1d680f6985
#
# Use installation script from llvm.org and cleanup apt lists because
# it uses apt's update and install commands.
RUN wget -O- https://apt.llvm.org/llvm.sh | bash -s -- 15 all \
    && rm -rf /var/lib/apt/lists/*
