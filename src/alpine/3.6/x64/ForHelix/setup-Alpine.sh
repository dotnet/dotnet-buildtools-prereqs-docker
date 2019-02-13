#!/bin/bash

# Set environment
user_name=helixbot
rootdir=/home/$user_name
script_root=$rootdir/dotnetbuild/scripts
work_root=$rootdir/dotnetbuild/work
log_root=$rootdir/dotnetbuild/logs
config_root=$rootdir/dotnetbuild/config
python_path=/usr/bin/python

#Create directories if they don't exist
mkdir -p $script_root
mkdir -p $work_root
mkdir -p $log_root
mkdir -p $config_root
chown $user_name $script_root
chown $user_name $work_root
chown $user_name $log_root
chown $user_name $config_root
chown $user_name /home/helixbot/get-pip.py

# Allow multiple instances and write starttestrunner.sh
echo "fs.inotify.max_user_instances=1024" >> /etc/sysctl.conf
echo cd \$HELIX_SCRIPT_ROOT >> /home/$user_name/starttestrunner.sh
echo export LANG=en_US.UTF-8 >> /home/$user_name/starttestrunner.sh
echo sudo -H -u $user_name \$HELIX_PYTHONPATH /home/$user_name/get-pip.py --user >> /home/$user_name/starttestrunner.sh
echo sudo -H -u $user_name \$HELIX_PYTHONPATH -m pip install -r $rootdir/dotnetbuild/scripts/runtime_python_requirements.txt --user >> /home/$user_name/starttestrunner.sh
echo "\$HELIX_PYTHONPATH start_helix.py | tee -a \$HELIX_LOG_ROOT/test_runner.log" >> /home/$user_name/starttestrunner.sh
echo "\$HELIX_PYTHONPATH -c \"from helix.platformutil import reboot_machine; reboot_machine()\" " >> /home/$user_name/starttestrunner.sh
chmod 755 /home/$user_name/starttestrunner.sh

# Give permissions to helixbot
sed -i -e "s/Defaults.*requiretty.*/#Defaults    requiretty/g" /etc/sudoers
echo "$user_name ALL=(ALL)       NOPASSWD: ALL" | (EDITOR="tee -a" visudo)
