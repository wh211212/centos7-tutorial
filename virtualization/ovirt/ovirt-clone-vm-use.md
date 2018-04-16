# ovirt使用克隆vm

## 更改网络配置

[root@localhost ~]# cat /etc/sysconfig/network-scripts/ifcfg-eth0 
TYPE=Ethernet
BOOTPROTO=static
DEFROUTE=yes
PEERDNS=yes
PEERROUTES=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_PEERDNS=yes
IPV6_PEERROUTES=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=eth0
DEVICE=eth0
ONBOOT=yes
IPADDR=192.168.0.21
NETMASK=255.255.255.0
GATEWAY=192.168.0.1
DNS1=114.114.114.114

- 克隆虚拟机前删除UUID，如果克隆前没删除，需要删除克隆vm上网卡配置中的UUID，重启启动网络


## ovirt克隆centos6 网络配置

配置完ip，rm -rf /etc/udev/rules.d/70-persistent-net.rules # 然后reboot重启即可