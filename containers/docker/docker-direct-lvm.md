# DOCKER配置DIRECT-LVM模式

- 参考：https://docs.docker.com/storage/storagedriver/device-mapper-driver/#configure-direct-lvm-mode-for-production

在Docker 17.06及更高版本中，Docker可以为您管理块设备，简化direct-lvm模式配置。这仅适用于新的Docker设置。只能使用一个块设备。如果您需要使用多个块设备，请手动配置direct-lvm模式。添加了以下新的配置选项：

- 编辑/etc/docker/daemon.json文件并设置适当的选项，然后重新启动Docker以使更改生效。以下daemon.json设置了上表中的所有选项。笔者着急实验，直接新建/daemon.json的方式配置的DIRECT-LVM，建议手动参考下面手动配置

```
{
  "storage-driver": "devicemapper",
  "storage-opts": [
    "dm.directlvm_device=/dev/sdb",
    "dm.thinp_percent=95",
    "dm.thinp_metapercent=1",
    "dm.thinp_autoextend_threshold=80",
    "dm.thinp_autoextend_percent=20",
    "dm.directlvm_device_force=false"
  ]
}
```

## 手动配置DIRECT-LVM模式

- 1、确定要使用的块设备。该设备位于 /dev/（例如/dev/sdb）下并且需要足够的可用空间来存储主机运行的工作负载的映像和容器层。理想的是固态硬盘。

- 2、停止docker

```
$ sudo systemctl stop docker
```
- 3、安装下面软件包

```
# RHEL / CentOS: device-mapper-persistent-data, lvm2, and all dependencies
yum install device-mapper-persistent-data lvm2 -y
```

- 4、创建pv

```
$ sudo pvcreate /dev/sdb

Physical volume "/dev/sdb" successfully created.
```

- 5、docker使用该vgcreate 命令在同一设备上创建一个卷组

```
$ sudo vgcreate docker /dev/sdb

Volume group "docker" successfully created
```
- 6、创建两个命名的逻辑卷thinpool，thinpoolmeta使用该 lvcreate命令。最后一个参数指定可用空间的大小，以便在空间不足时自动扩展数据或元数据，作为临时性缺口。这些是推荐值。

```
$ sudo lvcreate --wipesignatures y -n thinpool docker -l 95%VG

Logical volume "thinpool" created.

$ sudo lvcreate --wipesignatures y -n thinpoolmeta docker -l 1%VG

Logical volume "thinpoolmeta" created.
```

- 7、使用该lvconvert命令将卷转换为精简池和精简池元数据的存储位置。

```
$ sudo lvconvert -y \
--zero n \
-c 512K \
--thinpool docker/thinpool \
--poolmetadata docker/thinpoolmeta

WARNING: Converting logical volume docker/thinpool and docker/thinpoolmeta to
thin pool's data and metadata volumes with metadata wiping.
THIS WILL DESTROY CONTENT OF LOGICAL VOLUME (filesystem etc.)
Converted docker/thinpool to thin pool.
```

- 8、通过lvm配置文件配置精简池的自动扩展。

```
$ sudo vi /etc/lvm/profile/docker-thinpool.profile
```

- 9、指定thin_pool_autoextend_threshold和thin_pool_autoextend_percent的值。

```
thin_pool_autoextend_threshold是lvm 尝试自动扩展可用空间之前所用空间的百分比（100 =禁用，不推荐）。
thin_pool_autoextend_percent 是自动扩展时添加到设备的空间量（0 =禁用）。
# 以下示例在磁盘使用率达到80％时增加了20％的容量
activation {
  thin_pool_autoextend_threshold=80
  thin_pool_autoextend_percent=20
}
```

- 10、使用该lvchange命令应用LVM配置文件。

```
$ sudo lvchange --metadataprofile docker-thinpool docker/thinpool

Logical volume docker/thinpool changed.
```

- 11、启用对主机上逻辑卷的监视。没有这一步，即使存在LVM配置文件，也不会自动扩展。

```
$ sudo lvs -o+seg_monitor

LV       VG     Attr       LSize  Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert Monitor
thinpool docker twi-a-t--- 95.00g             0.00   0.01                             monitored
```

- 12、如果之前曾经在此主机上运行过Docker，或者/var/lib/docker/ 存在，请将其移出，以便Docker可以使用新的LVM池来存储映像和容器的内容。

```
$ mkdir /var/lib/docker.bk
$ mv /var/lib/docker/* /var/lib/docker.bk
如果以下任何步骤失败并且需要恢复，则可以删除 /var/lib/docker并替换它/var/lib/docker.bk
```

- 13、编辑/etc/docker/daemon.json并配置devicemapper存储驱动程序所需的选项 。如果该文件以前是空的，它现在应该包含以下内容：

```
{
    "storage-driver": "devicemapper",
    "storage-opts": [
    "dm.thinpooldev=/dev/mapper/docker-thinpool",
    "dm.use_deferred_removal=true",
    "dm.use_deferred_deletion=true"
    ]
}
```

- 14、重启docker并验证Docker是否正在使用新配置docker info

```
[root@vm-06 ~]# docker info
Containers: 0
 Running: 0
 Paused: 0
 Stopped: 0
Images: 0
Server Version: 18.03.1-ce
Storage Driver: devicemapper
 Pool Name: docker-thinpool
 Pool Blocksize: 524.3kB
 Base Device Size: 10.74GB
 Backing Filesystem: xfs
 Udev Sync Supported: true
 Data Space Used: 19.92MB
 Data Space Total: 204GB
 Data Space Available: 204GB
 Metadata Space Used: 266.2kB
 Metadata Space Total: 2.143GB
 Metadata Space Available: 2.143GB
 Thin Pool Minimum Free Space: 20.4GB
 Deferred Removal Enabled: true
 Deferred Deletion Enabled: true
 Deferred Deleted Device Count: 0
 Library Version: 1.02.146-RHEL7 (2018-01-22)
Logging Driver: json-file
Cgroup Driver: cgroupfs
Plugins:
 Volume: local
 Network: bridge host macvlan null overlay
 Log: awslogs fluentd gcplogs gelf journald json-file logentries splunk syslog
Swarm: inactive
Runtimes: runc
Default Runtime: runc
Init Binary: docker-init
containerd version: 773c489c9c1b21a6d78b5c538cd395416ec50f88
runc version: 4fc53a81fb7c994640722ac585fa9ca548971871
init version: 949e6fa
Security Options:
 seccomp
  Profile: default
Kernel Version: 3.10.0-862.3.2.el7.x86_64
Operating System: CentOS Linux 7 (Core)
OSType: linux
Architecture: x86_64
CPUs: 4
Total Memory: 7.637GiB
Name: vm-06
ID: RXKR:KEWO:WHKD:TLRV:6JYU:AXI2:422R:VTVS:EDGB:KAHU:2J2J:NU62
Docker Root Dir: /var/lib/docker
Debug Mode (client): false
Debug Mode (server): false
Registry: https://index.docker.io/v1/
Labels:
Experimental: false
Insecure Registries:
 127.0.0.0/8
Live Restore Enabled: false
```