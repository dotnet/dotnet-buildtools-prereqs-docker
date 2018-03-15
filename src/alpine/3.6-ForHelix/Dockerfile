FROM alpine:3.6

RUN apk update

RUN apk add --no-cache \
        autoconf \
        bash \
        build-base \
        clang \
        clang-dev \
        cmake \
        coreutils \
        curl-dev \
        gcc \
        gettext-dev \
        git \
        icu-dev \
        krb5-dev \
        libtool \
        libunwind-dev \
        libffi \
        linux-headers \
        llvm \
        make \
        openssl \
        openssl-dev \
        paxctl \
        py-cffi \
        python \
        python-dev \
        sudo \
        util-linux-dev \
        zlib-dev

RUN apk -X https://dl-cdn.alpinelinux.org/alpine/edge/main add --no-cache \
        userspace-rcu-dev \
        lttng-ust-dev

RUN apk -X https://dl-cdn.alpinelinux.org/alpine/edge/testing add --no-cache \
        lldb-dev

RUN /usr/sbin/adduser -D -G adm -s /bin/sh helixbot

# Restore pip and set environment
ADD https://bootstrap.pypa.io/get-pip.py /home/helixbot/get-pip.py
RUN /usr/bin/python /home/helixbot/get-pip.py
ENV pkgmgr apk
ENV HELIX_SCRIPT_ROOT /home/helixbot/dotnetbuild/scripts
ENV HELIX_WORK_ROOT /home/helixbot/dotnetbuild/work
ENV HELIX_LOG_ROOT /home/helixbot/dotnetbuild/logs
ENV HELIX_CONFIG_ROOT /home/helixbot/dotnetbuild/config
ENV PYTHONPATH /usr/bin/python:/home/helixbot/dotnetbuild/scripts
ENV HELIX_PYTHONPATH /usr/bin/python
WORKDIR /home/helixbot/

# Write and run script that generates starttestrunner.sh
RUN mkdir /home/src/
RUN echo -e "#!/bin/bash \n\
user_name=helixbot \n\
rootdir=/home/\$user_name \n\
script_root=\$rootdir/dotnetbuild/scripts \n\
work_root=\$rootdir/dotnetbuild/work \n\
log_root=\$rootdir/dotnetbuild/logs \n\
config_root=\$rootdir/dotnetbuild/config \n\
python_path=/usr/bin/python \n\
mkdir -p \$script_root \n\
mkdir -p \$work_root \n\
mkdir -p \$log_root \n\
mkdir -p \$config_root \n\
chown \$user_name \$script_root \n\
chown \$user_name \$work_root \n\
chown \$user_name \$log_root \n\
chown \$user_name \$config_root \n\
chown \$user_name /home/helixbot/get-pip.py \n\
echo \"fs.inotify.max_user_instances=1024\" >> /etc/sysctl.conf \n\
echo cd \\\$HELIX_SCRIPT_ROOT >> /home/\$user_name/starttestrunner.sh \n\
# LANG will be un-set on some Linux OSes, leading to inability to unzip files with unicode content \n\
echo export LANG=en_US.UTF-8 >> /home/\$user_name/starttestrunner.sh \n\
echo sudo -H -u \$user_name \\\$HELIX_PYTHONPATH /home/\$user_name/get-pip.py --user >> /home/\$user_name/starttestrunner.sh \n\
echo sudo -H -u \$user_name \\\$HELIX_PYTHONPATH -m pip install -r \$rootdir/dotnetbuild/scripts/runtime_python_requirements.txt --user >> /home/\$user_name/starttestrunner.sh \n\
echo \"\\\$HELIX_PYTHONPATH start_helix.py | tee -a \\\$HELIX_LOG_ROOT/test_runner.log\" >> /home/\$user_name/starttestrunner.sh \n\
echo \"\\\$HELIX_PYTHONPATH -c \\\"from helix.platformutil import reboot_machine; reboot_machine()\\\" \" >> /home/\$user_name/starttestrunner.sh \n\
chmod 755 /home/\$user_name/starttestrunner.sh \n\
# comment out the line in the /etc/sudoers file if present that requires tty  to sudo. \n\
sed -i -e \"s/Defaults.*requiretty.*/#Defaults    requiretty/g\" /etc/sudoers \n\
# For now, we will let DotNetBot sudo whatever it wants. \n\
echo \"\$user_name ALL=(ALL)       NOPASSWD: ALL\" | (EDITOR=\"tee -a\" visudo)" > /home/src/setup-Alpine.sh

RUN /bin/sh /home/src/setup-Alpine.sh
