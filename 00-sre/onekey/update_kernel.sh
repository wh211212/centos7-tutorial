#!/bin/bash

update_kernel()
{
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
yum --enablerepo=elrepo-kernel install -y kernel-lt kernel-lt-devel
grub2-set-default 0
reboot
}

update_kernel