# 清理ovirt环境

- 清理ovirt相关服务（包括HA,engine）,停用并卸载ovirt,vdsm,libvirt相关的服务：

yum remove *ovirt* *vdsm* *libvirt* *rhev* *glusterfs* *postgresql* -y

rm -rf /etc/ovirt* /etc/vdsm /etc/libvirt* /etc/pki/vdsm /etc/pki/libvirt /etc/pki/CA/cacert.pem*  /var/run/vdsm /var/run/libvirt /var/lib/vdsm /var/lib/libvirt /var/lib/ovirt* /var/lib/pgsql /var/log/*ovirt* /var/log/vdsm /var/log/libvirt

