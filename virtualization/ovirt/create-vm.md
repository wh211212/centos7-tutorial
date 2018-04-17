# 使用ovirt创建vm注意事项
## 创建windows 10

- 笔者实验环境win10，安装virt-viewer：https://www.spice-space.org/download.html

- https://docs.fedoraproject.org/quick-docs/en-US/creating-windows-virtual-machines-using-virtio-drivers.html

## 需要安装virtio 驱动，不然安装系统的时候会提示找不到硬盘


- 参考：https://www.youtube.com/watch?v=ljhpX446o0Q

- https://www.ovirt.org/documentation/vmm-guide/chap-Installing_Windows_Virtual_Machines/

- https://www.ovirt.org/develop/release-management/features/integration/windows-guest-tools/


yum -y install http://resources.ovirt.org/pub/yum-repo/ovirt-release42.rpm & yum install ovirt-guest-tools-iso


- https://www.ovirt.org/documentation/vmm-guide/chap-Installing_Linux_Virtual_Machines/
