#!/bin/bash
#################################################
#  --Info
#         Initialization CentOS 7.x script
#################################################
#   Auther: shaonbean@qq.com
#   Changelog:
#   20180710   wanghui  initial create
#################################################
# Check if user is root
#
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to initialization OS."
    exit 1
fi

echo "+------------------------------------------------------------------------+"
echo "|       To initialization the system for security and performance        |"
echo "+------------------------------------------------------------------------+"

# add yunwei user
user_add()
{
  # add yunwei for jumpserver
  id -u yunwei
  if [ $? -eq 0 ];then
    useradd -s /bin/bash -d /home/yunwei -m yunwei && echo password | passwd --stdin yunwei && echo "yunwei ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/yunwei
    else
    echo "yunwei user is exist."
  fi    
}

# update system & install pakeage
system_update(){
    echo "nameserver 114.114.114.114" >> /etc/resolv.conf
    mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.back
    wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo &> /dev/null
    echo "*** Starting update system && install tools pakeage... ***"
    yum install epel-release -y && yum -y update
    yum clean all && yum makecache
    yum -y install rsync wget vim openssh-clients iftop htop iotop sysstat lsof telnet traceroute tree man iptraf lrzsz lynx net-tools dstat tree ntpdate dos2unix net-tools git
    yum -y install  gcc gcc-c++ cmake lbzip2 bzip2 bzip2-devel pcre pcre-devel zlib-devel python-devel
    [ $? -eq 0 ] && echo "System upgrade && install pakeages complete."
}

# Set timezone synchronization
timezone_config()
{
    echo "Setting timezone..."
    /usr/bin/timedatectl | grep "Asia/Shanghai"
    if [ $? -eq 0 ];then
       echo "System timezone is Asia/Shanghai."
       else
       timedatectl set-local-rtc 0 && timedatectl set-timezone Asia/Shanghai
    fi 
    # config chrony
    yum -y install chrony && systemctl start chronyd.service && systemctl enable chronyd.service
    [ $? -eq 0 ] && echo "Setting timezone && Sync network time complete."
}

# disable selinux
selinux_config()
{
       sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
       setenforce 0
       echo "Dsiable selinux complete."
}

# ulimit comfig
ulimit_config()
{
echo "Starting config ulimit..."
cat >> /etc/security/limits.conf <<EOF
* soft nproc 8192
* hard nproc 8192
* soft nofile 8192
* hard nofile 8192
EOF

[ $? -eq 0 ] && echo "Ulimit config complete!"

}

# sshd config
sshd_config(){
    echo "Starting config sshd..."
    #sed -i '/^#Port/s/#Port 22/Port 21212/g' /etc/ssh/sshd_config
    #sed -i "$ a\ListenAddress 0.0.0.0:21212\nListenAddress 0.0.0.0:22 " /etc/ssh/sshd_config
    sed -i '/^#UseDNS/s/#UseDNS yes/UseDNS no/g' /etc/ssh/sshd_config
    systemctl restart sshd
    #sed -i 's/#PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
    #sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords no/g' /etc/ssh/sshd_config
    [ $? -eq 0 ] && echo "SSH config complete."
}

# firewalld config
disable_firewalld(){
   echo "Starting disable firewalld..."
   rpm -qa | grep firewalld >> /dec/null
   if [ $? -eq 0 ];then
      systemctl stop firewalld  && systemctl disable firewalld
      [ $? -eq 0 ] && echo "Dsiable firewalld complete."
      else
      echo "Firewalld not install." 
   fi
}

# vim config 
vim_config() {
    echo "Starting vim config..."
    /usr/bin/egrep pastetoggle /etc/vimrc >> /dev/null 
    if [ $? -eq 0 ];then
       echo "vim already config"
       else
       sed -i '$ a\set bg=dark\nset pastetoggle=<F9>' /etc/vimrc 
    fi

}

# sysctl config

config_sysctl() {
    echo "Staring config sysctl..."
    /usr/bin/cp -f /etc/sysctl.conf /etc/sysctl.conf.bak
    cat > /etc/sysctl.conf << EOF
vm.swappiness = 0
vm.dirty_ratio = 80
vm.dirty_background_ratio = 5
fs.file-max = 2097152
fs.suid_dumpable = 0
net.core.somaxconn = 65535
net.core.netdev_max_backlog = 262144
net.core.optmem_max = 25165824
net.core.rmem_default = 31457280
net.core.rmem_max = 67108864
net.core.wmem_default = 31457280
net.ipv4.tcp_syncookies = 1
net.ipv4.conf.all.rp_filter = 1
net.ipv4.icmp_echo_ignore_all = 1
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.conf.all.log_martians = 1
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.all.accept_redirects = 0
EOF

# eg：https://www.vultr.com/docs/securing-and-hardening-the-centos-7-kernel-with-sysctl
# set kernel parameters work
    /usr/sbin/sysctl -p
    [ $? -eq 0 ] && echo "Sysctl config complete."
}

# ipv6 config
disable_ipv6() {
    echo "Starting disable ipv6..."
    sed -i '$ a\net.ipv6.conf.all.disable_ipv6 = 1\nnet.ipv6.conf.default.disable_ipv6 = 1' /etc/sysctl.conf
    sed -i '$ a\AddressFamily inet' /etc/ssh/sshd_config
    systemctl restart sshd
    /usr/sbin/sysctl -p
}

# password config
password_config() {
    # /etc/login.defs
    sed -i 's/PASS_MIN_LEN    5/PASS_MIN_LEN    8/g' /etc/login.defs
    authconfig --passminlen=8 --update
    authconfig --enablereqlower --update
    [ $? -eq 0 ] && echo "Config password rule complete."
}

# disable no use service
disable_serivces() {
    systemctl stop postfix && systemctl enable postfix
    [ $? -eq 0 ] && echo "Disable postfix service complete."
}

#main function
main(){
    user_add
    system_update
    timezone_config
    selinux_config
    ulimit_config
    sshd_config
    disable_firewalld
    vim_config
    config_sysctl
    disable_ipv6
    password_config
    disable_serivces
}
# execute main functions
main
echo "+------------------------------------------------------------------------+"
echo "|            To initialization system all completed !!!                  |"
echo "+------------------------------------------------------------------------+"

