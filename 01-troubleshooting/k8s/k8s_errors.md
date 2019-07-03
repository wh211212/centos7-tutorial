# k8s 常见报错处理

- [WARNING IsDockerSystemdCheck]: detected "cgroupfs" as the Docker cgroup driver. The recommended driver is "systemd". Please follow the guide at https://kubernetes.io/docs/setup/cri/
error execution phase preflight: [preflight] Some fatal errors occurred:

```
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}
EOF

mkdir -p /etc/systemd/system/docker.service.d

# Restart Docker
systemctl daemon-reload
systemctl restart docker
```

- [ERROR FileContent--proc-sys-net-ipv4-ip_forward]: /proc/sys/net/ipv4/ip_forward contents are not set to 1

echo "1" > /proc/sys/net/ipv4/ip_forward

- [ERROR DirAvailable--var-lib-etcd]: /var/lib/etcd is not empty

rm -rf /var/lib/etcd

- failed to load Kubelet config file /var/lib/kubelet/config.yaml
- unable to load client CA file /etc/kubernetes/pki/ca.crt
- failed to run Kubelet: unable to load bootstrap kubeconfig: stat /etc/kubernetes/bootstrap-kubelet.conf: no such file or directory

背景：node 节点 kubeadm reset 后 重新kubeadm join失败

- Failed to execute iptables-restore: exit status 1（invalid option -- '5'）
  
  解决：降低iptables版本，当前iptables-1.4.21-28.el7.x86_64，回滚为iptables-1.4.21-24.el7.x86_64 （centos7.5）

-  Error from server (Forbidden): secrets is forbidden: User "system:node:master" cannot create resource "secrets" in API group "" in the namespace "kube-system": can only read resources of this type

export KUBECONFIG=/etc/kubernetes/admin.conf

- Error from server (AlreadyExists): secrets "kubernetes-dashboard-certs" already exists

kubectl delete -f kubernetes-dashboard.yaml

- The Service "kubernetes-dashboard" is invalid: spec.ports[0].nodePort: Forbidden: may not be used when `type` is 'ClusterIP'

kubectl -n kube-system describe $(kubectl -n kube-system get secret -n kube-system -o name | grep namespace) | grep token





