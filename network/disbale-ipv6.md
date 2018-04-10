# C7禁用IPV6

## 修改启动加载的内核参数

[root@localhost ~]# vi /etc/default/grub
# line 6: add
GRUB_CMDLINE_LINUX="ipv6.disable=1 rd.lvm.lv=fedora-server/root.....
# apply changing
[root@localhost ~]# grub2-mkconfig -o /boot/grub2/grub.cfg 
[root@localhost ~]# reboot 