# ovirt镜像管理

## 镜像上传

# 使用命令
先把镜像文件上传到服务器上，执行上传命令
engine-iso-uploader --nfs-server=nfs.aniu.so:/export/iso upload /usr/local/src/CentOS-7-x86_64-Minimal-1611.iso

# 或者通过filezilla上传到服务的 data存储域目录下。然后到移动到正确的位置


engine-iso-uploader --nfs-server=nfs1.aniu.so:/ovirt/iso upload /usr/local/src/CentOS-7-x86_64-Minimal-1611.iso
