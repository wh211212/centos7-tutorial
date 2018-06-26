# CentOS7上利用packstack快速部署openstack测试环境

## 环境vm centos7 16G 4 vcpu

由Packstack快速构建Openstack All-in-One环境。

- 仅限于CentOS 7 Base和Openstack Queens Repo以及EPEL Repo和Packstack软件包。其他软件包由Packstack自动安装和配置。

```
[root@packstack ~]# yum -y install centos-release-openstack-queens epel-release 
[root@packstack ~]# yum -y install openstack-packstack python-pip
```
