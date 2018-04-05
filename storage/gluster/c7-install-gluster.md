# C7安装glusterfs服务

## 参考链接

- https://wiki.centos.org/SpecialInterestGroup/Storage/gluster-Quickstart
- https://docs.gluster.org/en/latest/Quick-Start-Guide/Quickstart/
- https://blog.csdn.net/wh211212/article/details/79412081
- http://mirror.centos.org/centos/7/storage/x86_64/ 


## 实验环境

| Hostname      | Role             | IP            |
| ------------- |:----------------:| -------------:|
| ovirt1        | glusterfs-server    | 192.168.1.131 |
| ovirt2        | glusterfs-server    | 192.168.1.132 |

# 在ovirt1，ovirt2节点上安装GlusterFS服务

```
# ovirt1,ovirt1执行下面操作
[root@ovirt1 ~]# yum -y install centos-release-gluster40 # 当前最新版
[root@ovirt1 ~]# sed -i -e "s/enabled=1/enabled=0/g" /etc/yum.repos.d/CentOS-Gluster-4.0.repo
[root@ovirt1 ~]# yum --enablerepo=centos-gluster40 -y install glusterfs-server
[root@ovirt1 ~]# systemctl start glusterd 
[root@ovirt1 ~]# systemctl enable glusterd 
```

- 笔者安装glusterfs，提供ovirt的存储，安装建议版本即可

```
[root@ovirt1 yum.repos.d]# yum install centos-release-gluster -y # 使用centos wiki提供的安装源 默认3.12版本
[root@ovirt1 ~]# yum install glusterfs-server -y
[root@ovirt1 ~]# systemctl start glusterd 
[root@ovirt1 ~]# systemctl enable glusterd 
```

## Gluster 4.0：分布式配置(Distributed)

- 在所有节点上为GlusterFS卷创建一个目录

```
[root@node01 ~]# mkdir /glusterfs/distributed 
```

- 在节点上执行下面操作，配置群集

```
# probe the node
[root@node01 ~]# gluster peer probe node02 
peer probe: success.
# show status
[root@node01 ~]# gluster peer status 
Number of Peers: 1

Hostname: node02
Uuid: 3d0b5871-6dc3-42d3-9818-6a43ef035b9f
State: Peer in Cluster (Connected)

# create volume
[root@node01 ~]# gluster volume create vol_distributed transport tcp \
node01:/glusterfs/distributed \
node02:/glusterfs/distributed 
volume create: vol_distributed: success: please start the volume to access data
# start volume
[root@node01 ~]# gluster volume start vol_distributed 
volume start: vol_distributed: success
# show volume info
[root@node01 ~]# gluster volume info 

Volume Name: vol_distributed
Type: Distribute
Volume ID: 67b86c76-6505-4fec-be35-3e79ef7c2dc1
Status: Started
Snapshot Count: 0
Number of Bricks: 2
Transport-type: tcp
Bricks:
Brick1: node01:/glusterfs/distributed
Brick2: node02:/glusterfs/distributed
Options Reconfigured:
transport.address-family: inet
nfs.disable: on
```

## Gluster 4.0：复制配置

- 在所有节点上为GlusterFS卷创建一个目录

```
[root@node01 ~]# mkdir /glusterfs/replica 
```

- 在节点上执行下面操作，配置群集

```
# probe the node
[root@node01 ~]# gluster peer probe node02 
peer probe: success.
# show status
[root@node01 ~]# gluster peer status 
Number of Peers: 1

Hostname: node02
Uuid: 0e1917c8-7cd0-4578-af65-46a1489b10b1
State: Peer in Cluster (Connected)

# create volume
[root@node01 ~]# gluster volume create vol_replica replica 2 transport tcp \
node01:/glusterfs/replica \
node02:/glusterfs/replica 
volume create: vol_replica: success: please start the volume to access data
# start volume
[root@node01 ~]# gluster volume start vol_replica 
volume start: vol_replica: success
# show volume info
[root@node01 ~]# gluster volume info 

Volume Name: vol_replica
Type: Replicate
Volume ID: f496e38f-9238-4721-92bf-78fbaace7758
Status: Started
Snapshot Count: 0
Number of Bricks: 1 x 2 = 2
Transport-type: tcp
Bricks:
Brick1: node01:/glusterfs/replica
Brick2: node02:/glusterfs/replica
Options Reconfigured:
transport.address-family: inet
nfs.disable: on
performance.client-io-threads: off
```




