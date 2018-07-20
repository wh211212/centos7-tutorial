# pound安装使用

安装Pound是HTTP/HTTPS负载平衡软件

配置Pound以负载均衡到后端＃1，后端＃2，后端＃3 Web服务器

Fronted Pound：192.168.10.24
Backend1：:12.168.10.20
Backend2：:12.168.10.21
Backend3：:12.168.10.22

## 安装pound

```
# 安装epel源
yum -y install Pound
```

- 配置pound

```
[root@wanghui ~]# mv /etc/pound.cfg /etc/pound.cfg.org 
[root@wanghui ~]# cat /etc/pound.cfg
User "pound"
Group "pound"
# log level (max: 5)
LogLevel 3
# specify LogFacility
LogFacility local1
# interval of heartbeat - seconds
Alive 30

# define frontend
ListenHTTP
    Address 0.0.0.0
    Port 80
End

# define backend
Service
    BackEnd
       # backend server's IP address
        Address  192.168.10.20
       # backend server's port
        Port     80
       # set priority (value is 1-9, max 9)
        Priority 5
    End

    BackEnd
        Address  192.168.10.21
        Port     80
        Priority 5
    End

    BackEnd
        Address  192.168.10.22
        Port     80
        Priority 5
    End
End

[root@wanghui ~]# sed -i -e "s/^PIDFile/#PIDFile/" /usr/lib/systemd/system/pound.service 
[root@wanghui ~]# systemctl start pound 
[root@wanghui ~]# systemctl enable pound 
```

- 将Rsyslog设置更改为来自Pound的revord日志

```
[root@wanghui ~]# vi /etc/rsyslog.conf
# line 54: change like follows
*.info;mail.none;authpriv.none;cron.none,local1.none   /var/log/messages
 local1.*                                                /var/log/pound.log

[root@wanghui ~]# systemctl restart rsyslog 
```

- 测试

```
[root@node5 ~]# curl http://192.168.10.24
<H1>node1.aniu.so<H1>
[root@node5 ~]# curl http://192.168.10.24
<H1>node2.aniu.so<H1>
[root@node5 ~]# curl http://192.168.10.24
<H1>node3.aniu.so<H1>
```