# Centos7下通过virt-v2v将libvirt管理下的vm迁移至ovirt

## 实验环境

> CentOS7、ovirt4.2

- 实验背景：

> 生产环境一台kvm宿主机：192.168.0.201，上面有三台vm，需要将一台vm迁移到ovirt虚拟化平台

- ovirt环境

```
ovirt-engine: 192.168.0.210
ovirt-node: 192.168.0.123
ovirt-storage: 192.168.0.124(nfs) :export路径为：192.168.0.124:/ovirt/export
```

## 实验步骤

- 1、在ovirt管理界面配置export存储域，如下：

- 2、查看kvm宿主机中的vm，选择一台vm进行迁移，笔者以kvm-2为例：

```
[root@sh-kvm-2 ~]# virsh list --all
 Id    Name                           State
----------------------------------------------------
 1     kvm-1                          running
 2     kvm-3                          running
 6     kvm-2                          running
# 迁移虚拟机前需要先shutdown
[root@sh-kvm-2 ~]# virsh shutdown kvm-2
```

- 3、迁移报错

```
# This could be because the volume doesn't exist, or because the volume exists but is not contained in a storage pool
```
