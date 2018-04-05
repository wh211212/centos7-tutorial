# C7配置NFS服务

## 实验环境

> 笔者借用安装ovirt的实验环境

| Hostname      | Role             | IP            |
| ------------- |:----------------:| -------------:|
| ovirt.aniu.so | NFS server       | 192.168.1.115 |
| aniu-ops      | NFS clinet       | 192.168.1.134 |


## 配置NFS 服务

```
[root@ovirt ~]# yum -y install nfs-utils
[root@ovirt ~]# vi /etc/idmapd.conf
# 第五行 5: 取消注释更改域名后缀
Domain = aniu.so
[root@ovirt ~]# vi /etc/exports
# 配置nfs挂载目录详情
/home 192.168.1.1/24(rw,no_root_squash)

[root@ovirt ~]# systemctl start rpcbind nfs-server 
[root@ovirt ~]# systemctl enable rpcbind nfs-server 
```
