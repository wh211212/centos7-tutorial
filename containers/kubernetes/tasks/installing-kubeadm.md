# 安装kubeadm

- 参考：https://kubernetes.io/docs/tasks/tools/install-kubeadm

## 实验环境

OS：CentOS7.5 Memory: 8GB Vcpu:2 ,禁用swap、节点之间网络互通,禁用selinux


- 验证MAC地址和product_uuid对于每个节点都是唯一的

```
swapoff -a
# 修改/ets/fatab,注释swap的挂载配置/重要
ansible k8 -a "sed -i '/swap/d' /etc/fstab"

# 使用 ip link or ifconfig -a 查看 MAC地址

# 可以使用命令下面检查product_uuid：
sudo cat /sys/class/dmi/id/product_uuid
```

## 安装docker

使用操作系统的捆绑软件包安装Docker
```
yum install -y docker && systemctl enable docker && systemctl start docker
```


