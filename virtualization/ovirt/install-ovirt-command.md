# C7安装ovirt 4.2 步骤

yum -y install http://resources.ovirt.org/pub/yum-repo/ovirt-release42.rpm

yum -y install ovirt-engine

engine-setup


yum -y groups install "GNOME Desktop"  

startx 

yum -y install tigervnc-server


vncpasswd 

vncserver :1 -geometry 1920x1080 -depth 24

yum -y install qemu-kvm libvirt virt-install bridge-utils

systemctl start libvirtd 

systemctl enable libvirtd 

yum -y install vdsm


