# ovirt虚拟机最小安装初始设置

- 更新

yum update -y

- 更改主机名

hostnamectl set-hostname ecs-119

- 禁用ipv6，selinux

sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

[root@localhost ~]# vi /etc/default/grub
# line 6: add
GRUB_CMDLINE_LINUX="ipv6.disable=1 rd.lvm.lv=fedora-server/root.....
# apply changing
[root@localhost ~]# grub2-mkconfig -o /boot/grub2/grub.cfg 

- 关闭防火墙

systemctl stop firewalld && systemctl disable firewalld 

 - 添加epel源

yum -y install epel-release
