# 管理devicemapper

不要单独依靠LVM自动扩展。卷组自动扩展，但卷仍可填满,使用zabbix监控

- 要查看LVM日志，使用journalctl：

```
journalctl -fu dm-event.service
```

如果遇到精简池问题，可以将存储选项设置dm.min_free_space为一个值（表示百分比） /etc/docker.daemon.json。例如，将其设置为10在可用空间达到或接近10％时确保操作失败并发出警告。


## 调整直接LVM​​精简池的大小

要扩展direct-lvm精简池，您需要首先将新的块设备连接到Docker主机，并记下内核分配的名称。在这个例子中，新的块设备是/dev/xvdg。

- 使用此pvdisplay命令查找精简池当前正在使用的物理块设备以及卷组的名称。

```
$ sudo pvdisplay |grep 'VG Name'
PV Name               /dev/xvdf
VG Name               docker
```

- 扩展vg

```
sudo vgextend docker /dev/xvdg
```

- 扩展docker/thinpool逻辑卷。该命令立即使用100％的体积，而不会自动扩展。要扩展元数据精简池，请使用docker/thinpool_tmeta

```
$ sudo lvextend -l+100%FREE -n docker/thinpool
```

- 4、使用Data Space Available输出中的字段验证新的精简池大小docker info。如果您扩展了docker/thinpool_tmeta逻辑卷，请查找Metadata Space Available。

```
Storage Driver: devicemapper
 Pool Name: docker-thinpool
 Pool Blocksize: 524.3 kB
 Base Device Size: 10.74 GB
 Backing Filesystem: xfs
 Data file:
 Metadata file:
 Data Space Used: 212.3 MB
 Data Space Total: 212.6 GB
 Data Space Available: 212.4 GB
 Metadata Space Used: 286.7 kB
 Metadata Space Total: 1.07 GB
 Metadata Space Available: 1.069 GB
<output truncated>
```

## 激活devicemapper后重新启动

- 如果您重新启动主机并发现docker服务无法启动，请查找错误“非现有设备”。您需要使用此命令重新激活逻辑卷：

```
sudo lvchange -ay docker/thinpool
```