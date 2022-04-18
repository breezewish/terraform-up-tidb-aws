# This script is executed on all machines

while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done

# enable core dump
echo '* soft core unlimited' | sudo tee -a /etc/security/limits.conf
sudo sysctl -w kernel.core_pattern=core.%u.%p.%t
sudo systemctl restart apport
echo 'DefaultLimitCORE=infinity' | sudo tee -a /etc/systemd/system.conf
sudo systemctl daemon-reexec

# install zsh and other build essentials
sudo apt update
sudo apt install -y build-essential zsh gdb
sudo apt install -y linux-tools-common linux-tools-generic linux-tools-`uname -r`
wget --no-check-certificate https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh
sudo chsh -s /bin/zsh ubuntu

# tune kernel params
echo 'net.core.somaxconn=50000' | sudo tee -a /etc/sysctl.conf
echo 'net.ipv4.tcp_syncookies=0' | sudo tee -a /etc/sysctl.conf
echo '* soft nofile 1000000' | sudo tee -a /etc/security/limits.conf
echo '* hard nofile 1000000' | sudo tee -a /etc/security/limits.conf
echo '* soft stack 20480' | sudo tee -a /etc/security/limits.conf
sudo sysctl -p
