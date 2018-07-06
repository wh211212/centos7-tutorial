# 使用kubeadm工具箱创建kubernetes集群

- https://kubernetes.io/docs/setup/independent/install-kubeadm

## 安装kubeadm

- 环境准备：CentOS 7 16G Memory 16 CPUs （笔者服务器配置）

- 每个节点的唯一主机名，MAC地址和product_uuid
- 必须禁用swap为了使kubelet正常工作

```
swapoff 
# 修改/ets/fatab,注释swap的挂载配置/重要
```

- 验证每个节点的MAC地址和product_uuid是唯一的

```bash
# 可以使用命令下面检查product_uuid：
sudo cat /sys/class/dmi/id/product_uuid
```

- 检查网络适配器

> 如果您有多个网络适配器，并且您的Kubernetes组件在默认路由上无法访问，我们建议您添加IP路由，以便Kubernetes集群地址通过适当的适配器

- 检查所需端口

> Master node(s)

| Protocol   | Direction|  Port Range | Purpose |
| --------   | -----:   | :----: | :-----: |
| TCP      | Inbound       |   	6443*   |   Kubernetes API server      |
| TCP      | Inbound       |   2379-2380    |    etcd server client API     |
| TCP      | Inbound       |   10250    |   Kubelet API      |
| TCP      | Inbound       |   10251    |    kube-scheduler    |
| TCP      | Inbound       |   10252    |    kube-controller-manager   |
| TCP      | Inbound       |   10255    |   Read-only Kubelet API      |

> Worker node(s)

| Protocol   | Direction|  Port Range | Purpose |
| --------   | -----:   | :----: | :-----: |
| TCP      | Inbound       |   	10250  |   Kubelet API      |
| TCP      | Inbound       |   10255    |    Read-only Kubelet API    |
| TCP      | Inbound       |   30000-32767    |   NodePort Services**     |

> 默认的端口范围:https://kubernetes.io/docs/concepts/services-networking/service/

## 安装Docker

> 参考：http://blog.csdn.net/wh211212/article/details/78662605
> Docker官方安装：https://docs.docker.com/engine/installation/

```bash
yum install -y docker
systemctl enable docker && systemctl start docker
# 不建议使用官网的docker-ce版本、支持性不是很好、使用epel源支持的docker即可
[root@aniu-k8s ~]# docker version
Client:
 Version:         1.12.6
 API version:     1.24
 Package version: docker-1.12.6-68.gitec8512b.el7.centos.x86_64
 Go version:      go1.8.3
 Git commit:      ec8512b/1.12.6
 Built:           Mon Dec 11 16:08:42 2017
 OS/Arch:         linux/amd64

Server:
 Version:         1.12.6
 API version:     1.24
 Package version: docker-1.12.6-68.gitec8512b.el7.centos.x86_64
 Go version:      go1.8.3
 Git commit:      ec8512b/1.12.6
 Built:           Mon Dec 11 16:08:42 2017
 OS/Arch:         linux/amd64
```

> 在每台机器上安装Docker。建议使用v1.12版本，但v1.11，v1.13和17.03版本也是可以的。版本17.06+可能有效，但尚未经过Kubernetes节点团队的测试和验证。

> 请以root身份根据您的操作系统执行以下命令。通过SSH连接到每个主机后，您可以通过执行sudo -i成为root用户

- 确保kubelet使用的cgroup驱动程序与Docker使用的相同。为了确保兼容性，您可以更新Docker，如下所示：

```bash
cat << EOF > /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF
# 这里使用官网配置启动docker报错/启用使用默认配置

```

## 安装kubeadm, kubelet and kubectl

- kubeadm：引导群集的命令
- kubelet：运行在集群中所有机器上的组件，并执行诸如启动pods和容器的组件。
- kubectl: 与集群交互

- 配置官方kubernetes源：

```bash
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
```

- 配置国内kubernetes源

```bash
# cat > /etc/yum.repo.d/kubernetes.repo <<EOF
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
EOF
```


> 禁用SELinux并关闭防火墙

```bash
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config # 需重启
setenforce 0
#关闭防火墙 
systemctl stop firewalld && systemctl disable firewalld
```

> RHEL / CentOS 7上的某些用户报告了由于iptables被绕过而导致流量被错误路由的问题。应该确保net.bridge.bridge-nf-call-iptables的sysctl配置中被设置为1，例如

```bash
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system
```

- 安装kubelet kubeadm kubectl

```bash
[root@aniu-k8s ~]# yum install -y kubelet kubeadm kubectl
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: mirrors.163.com
 * epel: mirrors.tongji.edu.cn
 * 
 extras: mirrors.163.com
 * updates: mirrors.163.com
Package kubelet-1.9.2-0.x86_64 already installed and latest version
Package kubeadm-1.9.2-0.x86_64 already installed and latest version
Package kubectl-1.9.2-0.x86_64 already installed and latest version
Nothing to do

# systemctl enable kubelet && systemctl start kubelet
```

- 初始化kubeadm，否则启动kubelet报证书错误

```
[root@aniu-k8s ~]# kubeadm init --kubernetes-version=v1.9.2
[init] Using Kubernetes version: v1.9.2
[init] Using Authorization modes: [Node RBAC]
[preflight] Running pre-flight checks.
        [WARNING FileExisting-crictl]: crictl not found in system path
[preflight] Starting the kubelet service
[certificates] Generated ca certificate and key.
[certificates] Generated apiserver certificate and key.
[certificates] apiserver serving cert is signed for DNS names [aniu-k8s kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local] and IPs [10.96.0.1 192.168.10.10]
[certificates] Generated apiserver-kubelet-client certificate and key.
[certificates] Generated sa key and public key.
[certificates] Generated front-proxy-ca certificate and key.
[certificates] Generated front-proxy-client certificate and key.
[certificates] Valid certificates and keys now exist in "/etc/kubernetes/pki"
[kubeconfig] Wrote KubeConfig file to disk: "admin.conf"
[kubeconfig] Wrote KubeConfig file to disk: "kubelet.conf"
[kubeconfig] Wrote KubeConfig file to disk: "controller-manager.conf"
[kubeconfig] Wrote KubeConfig file to disk: "scheduler.conf"
[controlplane] Wrote Static Pod manifest for component kube-apiserver to "/etc/kubernetes/manifests/kube-apiserver.yaml"
[controlplane] Wrote Static Pod manifest for component kube-controller-manager to "/etc/kubernetes/manifests/kube-controller-manager.yaml"
[controlplane] Wrote Static Pod manifest for component kube-scheduler to "/etc/kubernetes/manifests/kube-scheduler.yaml"
[etcd] Wrote Static Pod manifest for a local etcd instance to "/etc/kubernetes/manifests/etcd.yaml"
[init] Waiting for the kubelet to boot up the control plane as Static Pods from directory "/etc/kubernetes/manifests".
[init] This might take a minute or longer if the control plane images have to be pulled.
[apiclient] All control plane components are healthy after 75.502276 seconds
[uploadconfig] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[markmaster] Will mark node aniu-k8s as master by adding a label and a taint
[markmaster] Master aniu-k8s tainted and labelled with key/value: node-role.kubernetes.io/master=""
[bootstraptoken] Using token: d9b013.26c2f690632cbef9
[bootstraptoken] Configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
[bootstraptoken] Configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
[bootstraptoken] Configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
[bootstraptoken] Creating the "cluster-info" ConfigMap in the "kube-public" namespace
[addons] Applied essential addon: kube-dns
[addons] Applied essential addon: kube-proxy

Your Kubernetes master has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

You can now join any number of machines by running the following on each node
as root:

  kubeadm join --token d9b013.26c2f690632cbef9 192.168.10.10:6443 --discovery-token-ca-cert-hash sha256:887a2ea3fccca1dec2caa12ad2e54f5baf806f29becf548a3b098ee3a869b518
```

## 使用kubeadm创建群集

> 参考：https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/

> kubeadm是一个工具包，可帮助您以简单，合理安全和可扩展的方式引导最佳实践Kubernetes群集。它还支持为您管理Bootstrap令牌并升级/降级群集。

> 它在设计上并不为您安装网络解决方案，这意味着您必须使用kubectl apply自行安装第三方符合CNI的网络解决方案

- 初始化master

```bash
[root@aniu-k8s ~]# kubeadm init --kubernetes-version=v1.9.2
```
> 要让kubectl为非root用户工作，您可能需要运行以下命令（这也是kubeadm init输出的一部分）：

```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

- 查看集群状态

```bash
[root@aniu-k8s ~]# kubectl get cs
NAME                 STATUS    MESSAGE              ERROR
controller-manager   Healthy   ok                   
scheduler            Healthy   ok                   
etcd-0               Healthy   {"health": "true"} 
```

## 安装pod network

> 仅在Master节点执行，网络必须在任何应用程序之前部署。而且，kube-dns是一个内部帮助服务，在安装网络之前不会启动。 kubeadm仅支持基于容器网络接口（CNI）的网络（并且不支持kubenet）

- 安装Flannel

```bash
# 将桥接的IPv4流量传递给iptables的链
sysctl net.bridge.bridge-nf-call-iptables=1
#
[root@aniu-k8s ~]# kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.9.1/Documentation/kube-flannel.yml
# kubectl apply -f   https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
clusterrole "flannel" created
clusterrolebinding "flannel" created
serviceaccount "flannel" created
configmap "kube-flannel-cfg" created
daemonset "kube-flannel-ds" created
```

> 一旦安装了pod网络，就可以通过在kubectl get pods --all-namespaces的输出中检查kube-dns pod是否正在运行来确认它正在工作。 一旦kube-dns吊舱启动并运行，您可以继续加入您的节点

```bash
[root@aniu-k8s ~]# kubectl get pods --all-namespaces
NAMESPACE     NAME                               READY     STATUS              RESTARTS   AGE
kube-system   etcd-aniu-k8s                      1/1       Running             0          1h
kube-system   kube-apiserver-aniu-k8s            1/1       Running             0          1h
kube-system   kube-controller-manager-aniu-k8s   1/1       Running             0          1h
kube-system   kube-dns-6f4fd4bdf-2428k           0/3       ContainerCreating   0          1h
kube-system   kube-flannel-ds-2h2c6              0/1       CrashLoopBackOff    3          1m
kube-system   kube-proxy-wt74z                   1/1       Running             0          1h
kube-system   kube-scheduler-aniu-k8s            1/1       Running             0          1h
```

- 注意：笔者安装pod network采用flannel有问题，故换成Weave Net

```
export kubever=$(kubectl version | base64 | tr -d '\n')
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$kubever"
```


- Master Isolation

> 使用kubeadm初始化的集群，出于安全考虑Pod不会被调度到Master Node上，可使用如下命令使Master节点参与工作负载。：

```bash
[root@aniu-k8s ~]# kubectl taint nodes --all node-role.kubernetes.io/master-
node "aniu-k8s" untainted
```

- 查看节点状态

```
[root@aniu-k8s ~]# kubectl get pod --all-namespaces -o wide
NAMESPACE     NAME                                    READY     STATUS    RESTARTS   AGE       IP              NODE
kube-system   etcd-aniu-k8s                           1/1       Running   0          49m       192.168.10.10   aniu-k8s
kube-system   kube-apiserver-aniu-k8s                 1/1       Running   0          49m       192.168.10.10   aniu-k8s
kube-system   kube-controller-manager-aniu-k8s        1/1       Running   0          49m       192.168.10.10   aniu-k8s
kube-system   kube-dns-6f4fd4bdf-n4ctn                3/3       Running   0          50m       10.32.0.2       aniu-k8s
kube-system   kube-proxy-s5pnl                        1/1       Running   0          47m       192.168.0.209   aniu-saas-4
kube-system   kube-proxy-szs7k                        1/1       Running   0          50m       192.168.10.10   aniu-k8s
kube-system   kube-scheduler-aniu-k8s                 1/1       Running   0          49m       192.168.10.10   aniu-k8s
kube-system   weave-net-bkbs2                         2/2       Running   0          49m       192.168.10.10   aniu-k8s
kube-system   weave-net-cwvdk                         2/2       Running   0          47m       192.168.0.209   aniu-saas-4
# 可以看到全部的pod已经全部running
```

- 向K8s集群中加入节点

> 节点是工作负载（containers and pods）运行的地方。要将新节点添加到群集，请为每台机器执行以下操作：

```bash
# 节点需要安装 yum install -y kubelet kubeadm kubectl

[root@aniu-saas-4 ~]# kubeadm join --token dc2313.9e3daddc83109625 192.168.10.10:6443 --discovery-token-ca-cert-hash sha256:8fe62dea8e88ff957dcd712f3c5948cc43f940abb3f34e8823576434d216ed5a
[preflight] Running pre-flight checks.
        [WARNING FileExisting-crictl]: crictl not found in system path
[preflight] Starting the kubelet service
[discovery] Trying to connect to API Server "192.168.10.10:6443"
[discovery] Created cluster-info discovery client, requesting info from "https://192.168.10.10:6443"
[discovery] Requesting info from "https://192.168.10.10:6443" again to validate TLS against the pinned public key
[discovery] Cluster info signature and contents are valid and TLS certificate validates against pinned roots, will use API Server "192.168.10.10:6443"
[discovery] Successfully established connection with API Server "192.168.10.10:6443"

This node has joined the cluster:
* Certificate signing request was sent to master and a response
  was received.
* The Kubelet was informed of the new secure connection details.

Run 'kubectl get nodes' on the master to see this node join the cluster.

```


- 查看节点信息

```bash
[root@aniu-k8s ~]# kubectl get nodes
NAME          STATUS     ROLES     AGE       VERSION
aniu-k8s      Ready      master    1h        v1.9.2
aniu-saas-4   NotReady   <none>    17s       v1.9.2
```

- 从其他机器或者笔记本终端操作集群

```bash
scp root@<master ip>:/etc/kubernetes/admin.conf .
kubectl --kubeconfig ./admin.conf get nodes
```

- 将API服务器代理到本地主机

```bash
scp root@<master ip>:/etc/kubernetes/admin.conf .
kubectl --kubeconfig ./admin.conf proxy
```

- 删除Kubernetes集群节点

```bash
kubectl drain <node name> --delete-local-data --force --ignore-daemonsets
kubectl delete node <node name>
```


## 注意事项

- 如果kubeadm出错，修改完成之后需要 kubeadm reset在重启初始化
- 官网文档只有修改docker配置哪一步，笔者没有操作，其他步骤和官网一致


### 错误

- 查看系统日志仍存在相关错误：

```bash
# 
Error adding network: open /run/flannel/subnet.env: no such file or directory
#
oci-systemd-hook[12470]: systemdhook <debug>: Skipping as container command is /pause, not init or systemd
# 后面继续学习排查故障
  
```

## 部署Dashboard插件

- 下载Dashboard配置文件

```
mkdir ~/k8s
cd ~/k8s
wget https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
```

- 修改Dashboard Service，编辑kubernetes-dashboard.yaml文件，在Dashboard Service中添加type: NodePort，暴露Dashboard服务

```
# ------------------- Dashboard Service ------------------- #

kind: Service
apiVersion: v1
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard
  namespace: kube-system
spec:
  type: NodePort # 添加
  ports:
    - port: 443
      targetPort: 8443
  selector:
    k8s-app: kubernetes-dashboard
```
- 安装Dashboard插件

```bash
[root@aniu-k8s k8s]# kubectl create -f kubernetes-dashboard.yaml 
secret "kubernetes-dashboard-certs" created
serviceaccount "kubernetes-dashboard" created
role "kubernetes-dashboard-minimal" created
rolebinding "kubernetes-dashboard-minimal" created
deployment "kubernetes-dashboard" created
service "kubernetes-dashboard" created
```

- Dashboard账户集群管理权限

> 创建一个kubernetes-dashboard-admin的ServiceAccount并授予集群admin的权限，创建kubernetes-dashboard-admin.rbac.yaml

```bash
---
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard-admin
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: kubernetes-dashboard-admin
  labels:
    k8s-app: kubernetes-dashboard
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: kubernetes-dashboard-admin
  namespace: kube-system
```

> 执行命令：

```
[root@aniu-k8s ~]#  kubectl create -f kubernetes-dashboard-admin.rbac.yaml
serviceaccount "kubernetes-dashboard-admin" created
clusterrolebinding "kubernetes-dashboard-admin" created
```

- 查看kubernete-dashboard-admin的token

```
[root@aniu-k8s ~]# kubectl -n kube-system get secret | grep kubernetes-dashboard-admin
kubernetes-dashboard-admin-token-c9sq2           kubernetes.io/service-account-token   3         12s
[root@aniu-k8s ~]# kubectl describe -n kube-system secret/kubernetes-dashboard-admin-token-c9sq2
Name:         kubernetes-dashboard-admin-token-c9sq2
Namespace:    kube-system
Labels:       <none>
Annotations:  kubernetes.io/service-account.name=kubernetes-dashboard-admin
              kubernetes.io/service-account.uid=04821fef-061f-11e8-a2bc-d4ae528a3fba

Type:  kubernetes.io/service-account-token

Data
====
ca.crt:     1025 bytes
namespace:  11 bytes
token:      eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJrdWJlcm5ldGVzLWRhc2hib2FyZC1hZG1pbi10b2tlbi1jOXNxMiIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50Lm5hbWUiOiJrdWJlcm5ldGVzLWRhc2hib2FyZC1hZG1pbiIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6IjA0ODIxZmVmLTA2MWYtMTFlOC1hMmJjLWQ0YWU1MjhhM2ZiYSIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDprdWJlLXN5c3RlbTprdWJlcm5ldGVzLWRhc2hib2FyZC1hZG1pbiJ9.csPOFxpLHxj-btcmUpOEUFO4MgL5wVL_lSuECALt9aLlb6x72lBRIQZfXnu8MbchhUlDBEX-i4dNU6_nyTKTokbiLwtCbKM12g7wG44aw1c-RjmFRvVxe9tMjjQXEN4ZExHoqtrcU5qTHrXo9qQOy5fyPBc6rbnS7YuPwp6tpofMO9WHdHCp0PejveAKSk6V6f-rPCZuh6ScfCYNF9ytLW-SGY4Kly9DXPR1AYgSdi7y1pu61iqWPgWUMqCzd5qsQ8ml4avOgK-jM-StqoG5_Rftk0sCVoVqfiN4toQhoC28_9TGBu0IKPiM-e1Fo6J4bZ8MrDULHnzs8lMWz1c0lQ

```

- 查看Dashboard服务端口

```
[root@aniu-k8s ~]# kubectl get svc -n kube-system
NAME                   TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)         AGE
kube-dns               ClusterIP   10.96.0.10     <none>        53/UDP,53/TCP   14h
kubernetes-dashboard   NodePort    10.96.219.54   <none>        443:30760/TCP   2m
```


## 参考链接

- https://www.centos.bz/2017/12/%E4%BD%BF%E7%94%A8kubeadm%E5%9C%A8centos-7%E4%B8%8A%E5%AE%89%E8%A3%85kubernetes-1-8/
- https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/
- https://github.com/kubernetes/dashboard/wiki/Installation
















