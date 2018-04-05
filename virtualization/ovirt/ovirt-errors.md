# ovirt安装故障排查

An error has occurred during installation of Host ovirt1: Yum [u'vdsm-4.20.23-1.el7.centos.x86_64 requires glusterfs-cli >= 3.12', u'ovirt-hosted-engine-setup-2.2.15-1.el7.centos.noarch requires glusterfs-cli >= 3.12.0', u'vdsm-4.20.23-1.el7.centos.x86_64 requires glusterfs-fuse >= 3.12'].


An error has occurred during installation of Host ovirt1: Failed to execute stage 'Package installation': [u'vdsm-4.20.23-1.el7.centos.x86_64 requires glusterfs-cli >= 3.12', u'ovirt-hosted-engine-setup-2.2.15-1.el7.centos.noarch requires glusterfs-cli >= 3.12.0', u'vdsm-4.20.23-1.el7.centos.x86_64 requires glusterfs-fuse >= 3.12'].

# 故障原因是笔者的CentOS Base repo设置了优先级，默认下载安装包时从base源下载，导致版本过低

- 解决：还原CentOS Base repo的优先级

yum install centos-release-gluster  # 安装centos-release-gluster，

yum clean all

yum update


## 升级ovirt导致ovirt登录加载的时间特别久


