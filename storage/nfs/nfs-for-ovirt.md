# 配置nfs作为ovirt镜像存储

- 针对ovirt，配置nfs并创建挂载目录如下：

yum -y install nfs-utils & systemctl start rpcbind nfs-server & systemctl enable rpcbind nfs-server

mkdir -p /ovirt/{data,iso,export}

# 设置nfs挂载的目录及权限,编辑/etc/exports文件，添加下面内容：

/ovirt/data      *(rw)
/ovirt/iso      *(rw)
/ovirt/export    *(rw)

chown vdsm:kvm /ovirt/{data,iso,export}

systemctl restart rpcbind nfs-server 

[root@ovirt ~]# showmount -e localhost               
Export list for localhost:
/ovirt/export *
/ovirt/iso    *
/ovirt/data   *