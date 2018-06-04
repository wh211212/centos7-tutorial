# ovirt虚拟机添加硬盘

## 格式化硬盘

fdisk /dev/sdb

- 创建vg

vgcreate centos /dev/sdb1

- 创建lv

lvcreate -l 100%FREE -n data centos

- 挂载并添加到fstab

yum install xfsprogs -y

mkfs.xfs /dev/mapper/centos-data

mount /dev/mapper/centos-data /data/

echo "/dev/mapper/centos-data     /data                       xfs     defaults        0 0" >> /etc/fstab

## 扩展data目录



