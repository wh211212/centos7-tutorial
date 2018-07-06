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

