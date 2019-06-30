#!/bin/bash
# command from office website （https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/ && other place

# config aliyun k8s repo
setup_k8s_repo() {
cat <<EOF > /etc/yum.repos.d/aliyun-kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

# Set SELinux in permissive mode (effectively disabling it)
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=disabled/' /etc/selinux/config
systemctl stop firewalld.service && systemctl disable firewalld.service
yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
systemctl enable --now kubelet
}

# set sysctl
sysctl_config(){
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

yum -y install chrony && systemctl start chronyd.service && systemctl enable chronyd.service
}

# swapoff
swapoff(){
  /sbin/swapoff -a
  sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
  echo "vm.swappiness=0" >> /etc/sysctl.conf
  /sbin/sysctl -p
}

net_module() {
    lsmod | grep br_netfilter
if [ $? -eq 0 ];then
  echo "br_netfilter module is loaded!"
  else
  modprobe br_netfilter
fi 
}

main() {
    setup_k8s_repo
    sysctl_config
    swapoff
    net_module
}

main
