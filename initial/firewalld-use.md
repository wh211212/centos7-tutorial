# Firewalld的基本操作

服务的定义设置在Firewalld上的区域

- 使用Firewalld

```
[root@wanghui ~]# systemctl start firewalld 
[root@wanghui ~]# systemctl enable firewalld 
```

- 默认情况下，“public”区域与NIC一起应用，并且允许dhcpv6-client和ssh。当使用“firewall-cmd”命令进行操作时，如果输入不带“--zone = ***”规范的命令，则将配置设置为默认区域。

```
# display the default zone
[root@dlp ~]# firewall-cmd --get-default-zone 
public
# display current settings
[root@dlp ~]# firewall-cmd --list-all 
public (default, active)
  interfaces: eno16777736
  sources:
  services: dhcpv6-client ssh
  ports:
  masquerade: no
  forward-ports:
  icmp-blocks:
  rich rules:
  
# display all zones defined by default
[root@dlp ~]# firewall-cmd --list-all-zones 
block
  interfaces:
  sources:
  services:
  ports:
  masquerade: no
  forward-ports:
  icmp-blocks:
  rich rules:
  .....
  .....
  
# display allowed services on a specific zone
[root@dlp ~]# firewall-cmd --list-service --zone=external 
ssh
# change default zone
[root@dlp ~]# firewall-cmd --set-default-zone=external 
success
# change zone for an interface (*note)
[root@dlp ~]# firewall-cmd --change-interface=eth1 --zone=external 
success
[root@dlp ~]# firewall-cmd --list-all --zone=external
external (active)
  interfaces: eth1
  sources:
  services: ssh
  ports:
  masquerade: yes
  forward-ports:
  icmp-blocks:
  rich rules:
  
# *note : it's not changed permanently with "change-interface" even if added "--permanent" option
# if change permanently, use nmcli like follows
[root@dlp ~]# nmcli c mod eth1 connection.zone external 
[root@dlp ~]# firewall-cmd --get-active-zone 
external
  interfaces: eth1
public
  interfaces: eth0
```

- 显示默认服务

```
[root@dlp ~]# firewall-cmd --get-services 
amanda-client bacula bacula-client dhcp dhcpv6 dhcpv6-client dns ftp high-availability http https imaps ipp ipp-client ipsec kerberos kpasswd ldap ldaps libvirt libvirt-tls mdns mountd ms-wbt mysql nfs ntp openvpn pmcd pmproxy pmwebapi pmwebapis pop3s postgresql proxy-dhcp radius rpc-bind samba samba-client smtp ssh telnet tftp tftp-client transmission-client vnc-server wbem-https
# definition files are placed like follows
# if you'd like to add your original definition, add XML file on there
[root@dlp ~]# ls /usr/lib/firewalld/services 
amanda-client.xml      ipp-client.xml   mysql.xml       rpc-bind.xml
bacula-client.xml      ipp.xml          nfs.xml         samba-client.xml
bacula.xml             ipsec.xml        ntp.xml         samba.xml
dhcpv6-client.xml      kerberos.xml     openvpn.xml     smtp.xml
dhcpv6.xml             kpasswd.xml      pmcd.xml        ssh.xml
dhcp.xml               ldaps.xml        pmproxy.xml     telnet.xml
dns.xml                ldap.xml         pmwebapis.xml   tftp-client.xml
ftp.xml                libvirt-tls.xml  pmwebapi.xml    tftp.xml
high-availability.xml  libvirt.xml      pop3s.xml       transmission-client.xml
https.xml              mdns.xml         postgresql.xml  vnc-server.xml
http.xml               mountd.xml       proxy-dhcp.xml  wbem-https.xml
imaps.xml              ms-wbt.xml       radius.xml
```

- 添加或移除允许的服务

```
# for example, add http (the change will be valid at once)
[root@dlp ~]# firewall-cmd --add-service=http 
success
[root@dlp ~]# firewall-cmd --list-service 
dhcpv6-client http ssh
# for example, remove http
[root@dlp ~]# firewall-cmd --remove-service=http 
success
[root@dlp ~]# firewall-cmd --list-service 
dhcpv6-client ssh
# for example, add http permanently. (this permanent case, it's necessary to reload the Firewalld to enable the change)
[root@dlp ~]# firewall-cmd --add-service=http --permanent 
success
[root@dlp ~]# firewall-cmd --reload 
success
[root@dlp ~]# firewall-cmd --list-service 
dhcpv6-client http ssh
```

- 添加或删除允许的端口

```
# for example, add TCP 465
[root@dlp ~]# firewall-cmd --add-port=465/tcp 
success
[root@dlp ~]# firewall-cmd --list-port 
465/tcp
# for example, remove TCP 465
[root@dlp ~]# firewall-cmd --remove-port=465/tcp 
success
[root@dlp ~]# firewall-cmd --list-port 
 
# for example, add TCP 465 permanently
[root@dlp ~]# firewall-cmd --add-port=465/tcp --permanent 
success
[root@dlp ~]# firewall-cmd --reload 
success
[root@dlp ~]# firewall-cmd --list-port 
465/tcp
```

- 添加或删除禁止的ICMP类型

```
# for example, add echo-request to prohibit it
[root@dlp ~]# firewall-cmd --add-icmp-block=echo-request 
success
[root@dlp ~]# firewall-cmd --list-icmp-blocks 
echo-request
# for example, remove echo-request
[root@dlp ~]# firewall-cmd --remove-icmp-block=echo-request 
success
[root@dlp ~]# firewall-cmd --list-icmp-blocks 
 
# display ICMP types
[root@dlp ~]# firewall-cmd --get-icmptypes 
destination-unreachable echo-reply echo-request parameter-problem redirect 
router-advertisement router-solicitation source-quench time-exceeded
```