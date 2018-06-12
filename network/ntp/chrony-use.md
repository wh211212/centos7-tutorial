# CentOS7使用Chrony设置时间同步

yum install chrony -y

- chrony配置

[root@aniu-saas ~]# egrep -v "^#|^$" /etc/chrony.conf 
server 0.pool.ntp.org
server 1.pool.ntp.org
server 2.pool.ntp.org
server 3.pool.ntp.org
server times.aliyun.com iburst
server time1.aliyun.com iburst
server time2.aliyun.com iburst
driftfile /var/lib/chrony/drift
makestep 1.0 3
rtcsync
allow 192.168.0.1/24
allow 172.16.1.1/24
allow 192.168.31.1/24
logdir /var/log/chrony


# systemctl enable chronyd.service
# systemctl restart chronyd.service
# systemctl status chronyd.service

- 查看时间同步源状态

```
[root@aniu-saas ~]# chronyc sourcestats -v
210 Number of sources = 6
                             .- Number of sample points in measurement set.
                            /    .- Number of residual runs with same sign.
                           |    /    .- Length of measurement set (time).
                           |   |    /      .- Est. clock freq error (ppm).
                           |   |   |      /           .- Est. error in freq.
                           |   |   |     |           /         .- Est. offset.
                           |   |   |     |          |          |   On the -.
                           |   |   |     |          |          |   samples. \
                           |   |   |     |          |          |             |
Name/IP Address            NP  NR  Span  Frequency  Freq Skew  Offset  Std Dev
==============================================================================
time5.aliyun.com            4   3   194     +1.061    103.339   +188us   385us
85.199.214.100              4   3   195     +3.504     82.387    +31ms   325us
118.122.35.10               3   3   130     +3.885   2096.379  +4650us   228us
85.199.214.101              4   3   195     -1.286    124.915    +26ms   412us
120.25.115.19               7   3   200     +0.859     17.221  +1983us   572us
203.107.6.88                7   4   200     -2.721     53.192  -1270us  1299us
```


## 客户端设置

```
# yum install chrony -y
编辑 /etc/chrony.conf 文件，修改server NTP_SERVER iburst，更改更准备的NTP_SERVER，第26行 取消注释更改自己网段 allow 192.168.1.1/24
[root@ovirt ~]# systemctl enable chronyd.service
[root@ovirt ~]# systemctl start chronyd.service
[root@ovirt ~]# systemctl status chronyd.
```

- ops ntp server

