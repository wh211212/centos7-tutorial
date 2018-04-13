# lvm创建使用

- 安装软件包

yum install xfsprogs -y  # 重新格式化 resiize分区的时候使用


```
umount /dev/mapper/centos-home
lvremove /dev/centos/home
# 编辑fstab 删除挂载home的配置文件,笔者安装的时候让其自动创建lvm卷组并自动挂载，想在这里自定义
```

## 创建pv

pvcreate /dev/sdb1 

pvcreate --setphysicalvolumesize 50G /dev/sdb1 

- 查看 pv

pvdisplay /dev/sdb1 

- 改变pv的大小

pvresize --setphysicalvolumesize 50G /dev/sdb1 

- 显示物理卷的报告

pvs /dev/sdb1 

- 扫描 pv

pvscan

- 删除pv

pvremove /dev/sdb1 

## 创建vg组，添加硬盘，新加硬盘前提

- 创建volume group

vgcreate vg_name /dev/sdb1 

vgcreate vg_name /dev/sdb1 /dev/sdc1

- 展示卷组

vgdisplay vg_dlp 

- 重命名卷组

vgrename vg_name vg_newname 

vgdisplay vg_newname  # 对比  vg_name

- vg查看 扫描

 vgs 

 vgscan 

 ## 笔者建议熟练使用--help以及 man

 - 扩展卷组

 vgextend vg_data /dev/sdd1 

 - 缩减卷组

 vgreduce vg_data /dev/sdd1 

- 删除卷组

先禁用目标卷组并将其删除

vgchange -a n vg_data 

vgremove vg_data 


## 管理 物理卷

lvcreate -L 50G -n lv_name vg_name

lvcreate -l 100%FREE -n lv_name vg_name  # 使用全部空闲区域


- 显示lv

lvdisplay /dev/vg_name/lv_name 

- 展示 扫描 lv

lvs
lvscan

- 拍摄逻辑卷的快照

lvcreate -s -L 50G -n snap-lv_name /dev/vg_name/lv_name

lvdisplay /dev/vg_name/lv_name /dev/vg_name/snap-lv_name

- 扩展卷组

lvextend -L 50G /dev/vg_name/lv_name # 扩展到50G

lvextend -L +50G /dev/vg_name/lv_name # 添加50G

lvdisplay /dev/vg_name/lv_name

- 对于扩展xfs文件系统的情况（指定挂载点）

xfs_growfs /mnt

# resize2fs /dev/vg_name/lv_name

mkfs.xfs -f /dev/vg_name/lv_name

xfs_growfs /dev/vg_name/lv_name

## 缩减lv前需要先卸载

# 针对

e2fsck -f /dev/vg_name/lv_name 50G 
resize2fs /dev/vg_name/lv_name 50G

lvreduce -L 50G /dev/vg_name/lv_name 50G # 缩减到50G # 先卸载

- 删除卷组
lvchange -an /dev/vg_name/lv_name

lvremove /dev/vg_name/lv_name 


## 创建镜像卷

vgcreate vg_mirror /dev/sdb1 /dev/sdc1 

lvcreate -L 50G -m1 -n lv_mirror vg_mirror 

lvdisplay /dev/vg_mirror/lv_mirror 

vgextend vg_name /dev/sdc1 

- 设置镜像卷
lvconvert -m1 /dev/vg_name/lv_name /dev/sdc1 

- 指定-m0以取消设置

lvconvert -m0 /dev/vg_name/lv_name

lvs -a -o vg_name,name,devices,size

## 创建带区卷

vgcreate vg_striped /dev/sdb1 /dev/sdc1 

lvcreate -L 50G -i2 -I 64 -n lv_striped vg_striped 

lvdisplay /dev/vg_striped/lv_striped 

lvs -a -o vg_name,name,devices,size 