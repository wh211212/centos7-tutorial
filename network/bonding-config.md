# C7配置双网卡

## 创建网卡bond0

```
[root@localhost ~]# cd /etc/sysconfig/network-scripts/
[root@localhost network-scripts]# cat ifcfg-bond0 
DEVICE=bond0
NAME=bond0
TYPE=Bond
BONDING_MASTER=yes
IPADDR=192.168.0.123
NETMASK=255.255.255.0
GATEWAY=192.168.0.1
DNS1=114.114.114.114
#PREFIX=24
ONBOOT=yes
BOOTPROTO=none
BONDING_OPTS="mode=5 miimon=100"
```

- 参考：https://www.linuxtechi.com/configure-nic-bonding-in-centos-7-rhel-7/


- 修改网卡em1
```
[root@localhost network-scripts]# cat ifcfg-em1 
TYPE=Ethernet
BOOTPROTO=none
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
NAME=em1
UUID=2314586b-95a0-4d69-a466-1bf2e9da2e17
DEVICE=em1
ONBOOT=yes

MASTER=bond0
SLAVE=yes
```


- 修改网卡em2
```
[root@localhost network-scripts]# cat ifcfg-em1 
TYPE=Ethernet
BOOTPROTO=none
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
NAME=em1
UUID=2314586b-95a0-4d69-a466-1bf2e9da2e17
DEVICE=em1
ONBOOT=yes

MASTER=bond0
SLAVE=yes

```