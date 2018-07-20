# haproxy安装使用

安装HAProxy以配置负载平衡服务器

- 实验环境：

HAproxy：192.168.0.111
Backend1:192.168.10.20
Backend2:192.168.10.21

## 安装haproxy

```
[root@wanghui ~]# yum -y install haproxy
```

- 配置haproxy

```
[root@wanghui ~]# mv /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.org 
[root@wanghui ~]# vi /etc/haproxy/haproxy.cfg
# create new
 global
      # for logging section
    log         127.0.0.1 local2 info
    chroot      /var/lib/haproxy
    pidfile     /var/run/haproxy.pid
      # max per-process number of connections
    maxconn     256
      # process' user and group
    user        haproxy
    group       haproxy
      # makes the process fork into background
    daemon

defaults
      # running mode
    mode               http
      # use global settings
    log                global
      # get HTTP request log
    option             httplog
      # timeout if backends do not reply
    timeout connect    10s
      # timeout on client side
    timeout client     30s
      # timeout on server side
    timeout server     30s

# define frontend ( set any name for "http-in" section )
frontend http-in
      # listen 80
    bind *:80
      # set default backend
    default_backend    backend_servers
      # send X-Forwarded-For header
    option             forwardfor

# define backend
backend backend_servers
      # balance with roundrobin
    balance            roundrobin
      # define backend servers
    server             www01 192.168.10.20:80 check
    server             www02 192.168.10.21:80 check

[root@wanghui ~]# systemctl start haproxy 
[root@wanghui ~]# systemctl enable haproxy     
```

- 配置Rsyslog以获取HAProxy的日志

```
[root@wanghui ~]# vi /etc/rsyslog.conf
# line 15,16: uncomment, lne 17: add
$ModLoad imudp
$UDPServerRun 514
$AllowedSender UDP, 127.0.0.1
# line 54: change like follows
*.info;mail.none;authpriv.none;cron.none,local2.none   /var/log/messages
local2.*                                              /var/log/haproxy.log

[root@wanghui ~]# systemctl restart rsyslog 
```

## 配置HAProxy以在Web上查看HAProxy的统计信息

- 配置HAProxy以在Web上查看HAProxy的统计信息

```
[root@wanghui ~]# vi /etc/haproxy/haproxy.cfg
# add follows in the "frontend" section
frontend  http-in
    bind *:80
      # enable statistics reports
    stats enable
      # auth info for statistics site
    stats auth admin:adminpassword
      # hide version of HAProxy
    stats hide-version
      # display HAProxy hostname
    stats show-node
      # refresh time
    stats refresh 60s
      # statistics reports' URI
    stats uri /haproxy?stats

[root@wanghui ~]# systemctl restart haproxy 
```

- 查看状态

