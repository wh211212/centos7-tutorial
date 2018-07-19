# C7安装ovirt 4.2 步骤

yum -y install http://resources.ovirt.org/pub/yum-repo/ovirt-release42.rpm

yum -y install ovirt-engine

engine-setup


## ovirt node 节点添加

配置hosts

yum -y install qemu-kvm libvirt virt-install bridge-utils

systemctl start libvirtd && systemctl enable libvirtd

yum -y install http://resources.ovirt.org/pub/yum-repo/ovirt-release42.rpm && yum -y install vdsm


## vm添加硬盘 挂载到data目录




