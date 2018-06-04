# CentOS7安装openshift集群

- OpenShift官网：https://www.openshift.com/
- Github：https://github.com/openshift/origin

开源容器应用程序平台，Origin是支持OpenShift的上游社区项目。围绕Docker容器打包和Kubernetes容器集群管理的核心构建，Origin还增加了应用程序生命周期管理功能和DevOps工具。Origin提供了一个完整的开源容器应用程序平台。

## 安装OpenShift Origin，它是Red Hat OpenShift的开源版本

- 环境CentOS7：

| Hostname      | Role             | IP            |
| ------------- |:----------------:| -------------:|
| master.aniu.so        | Master, etcd, and node | 192.168.0.111 |
| compute1.aniu.so      | Computer Node             | 192.168.0.114 |
| compute1.aniu.so      | Computer Node             | 192.168.0.115 |

> 集群配置参考：https://docs.openshift.org/latest/install_config/install/planning.html

> 配置群集的一些系统要求

- 主节点至少16G的内存
- 在所有节点上，需要物理卷上的可用空间才能为Docker Direct LVM创建新的卷组，var目录至少40G，不然检测通不过

## 主机设置

- 安装依赖包,关闭防火墙，禁用selinux，添加sysctl net.ipv4.ip_forward=1，所有节点均执行

> 详情见：https://github.com/openshift/origin/blob/master/docs/cluster_up_down.md#prerequisites
> 参考：https://docs.openshift.org/latest/install_config/install/host_preparation.html#install-config-install-host-preparation

```
yum install wget git net-tools bind-utils yum-utils iptables-services bridge-utils bash-completion kexec-tools sos psacct -y
yum install ansible pyOpenSSL -y
```

- 在所有节点上，安装OpenShift Origin 3.9存储库和Docker。 接下来，为Docker Direct LVM创建一个卷组，以便像下面那样设置LVM Thinpool。

```
# 以master为例，虽有节点都必须执行
[root@master ~]# yum -y install centos-release-openshift-origin37 docker
[root@master ~]# vgcreate centos /dev/sdb1  #笔者vgname为centos
Volume group "centos" successfully created
[root@master ~]# echo VG=centos >> /etc/sysconfig/docker-storage-setup 
[root@master ~]# systemctl start docker 
[root@master ~]# systemctl enable docker 
```

- 设置三个节点master节点与其他节点ssh免密。方便执行ansible-playbook

```

# 在master节点上执行：
[root@master ~]# ssh-keygen -t rsa
# 创建免密设置
[root@master ~]# cat /etc/hosts # 参考笔者hosts，同步hosts到node1，node2
127.0.0.1   localhost localhost.localdomain pinpoint
###########################################
## openshift
192.168.0.113 master.aniu.so
192.168.0.114 node1.aniu.so
192.168.0.115 node2.aniu.so
[root@master ~]# ssh-copy-id master.aniu.so
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/root/.ssh/id_rsa.pub"
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed

/usr/bin/ssh-copy-id: WARNING: All keys were skipped because they already exist on the remote system.
                (if you think this is a mistake, you may want to use -f option)

[root@master ~]# ssh-copy-id node1.aniu.so 
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/root/.ssh/id_rsa.pub"
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed

/usr/bin/ssh-copy-id: WARNING: All keys were skipped because they already exist on the remote system.
                (if you think this is a mistake, you may want to use -f option)

[root@master ~]# ssh-copy-id node2.aniu.so
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/root/.ssh/id_rsa.pub"
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed

/usr/bin/ssh-copy-id: WARNING: All keys were skipped because they already exist on the remote system.
                (if you think this is a mistake, you may want to use -f option)
```

## 在主节点上，使用root登录并运行Ansible Playbook以设置OpenShift群集。

- 参考：https://docs.openshift.org/latest/install_config/install/stand_alone_registry.html

```
yum -y install atomic-openshift-utils

配置ansible的hosts如下：

[root@master ~]# cat /etc/ansible/hosts 
# add follows to the end
[OSEv3:children]
masters
nodes
etcd

[OSEv3:vars]
# admin user created in previous section
ansible_ssh_user=root
openshift_deployment_type=origin

# use HTPasswd for authentication
openshift_master_identity_providers=[{'name': 'htpasswd_auth', 'login': 'true', 'challenge': 'true', 'kind': 'HTPasswdPasswordIdentityProvider', 'filename': '/etc/origin/master/.htpasswd'}]
openshift_master_default_subdomain=apps.test.aniu.so

# allow unencrypted connection within cluster
openshift_docker_insecure_registries=172.30.0.0/16

[masters]
master.aniu.so openshift_schedulable=true containerized=false

[etcd]
master.aniu.so

[nodes]
# set labels [region: ***, zone: ***] (any name you like)
master.aniu.so openshift_node_labels="{'region': 'infra', 'zone': 'default'}"
node1.aniu.so openshift_node_labels="{'region': 'primary', 'zone': 'east'}" openshift_schedulable=true
node2.aniu.so openshift_node_labels="{'region': 'primary', 'zone': 'west'}" openshift_schedulable=true


# 运行deploy_cluster.yml手册以启动安装：
ansible-playbook /usr/share/ansible/openshift-ansible/playbooks/deploy_cluster.yml # 此步骤会很慢，笔者大概花了2个多小时。。。
```

- 正常执行完成查看状态

```
- 可能会出现的报错：
Error from server (Forbidden): nodes is forbidden: User "system:anonymous" cannot list nodes at the cluster scope: User "system:anonymous" cannot list all nodes in the cluster
报错解决：
[root@master ~]# oc login -u system:admin # 使用admin登录进行查看
Logged into "https://master.aniu.so:8443" as "system:admin" using existing credentials.

You have access to the following projects and can switch between them with 'oc project <projectname>':

  * default
    kube-public
    kube-system
    logging
    management-infra
    openshift
    openshift-infra
    openshift-node
    openshift-web-console

Using project "default".
[root@master ~]# oc get nodes            
NAME             STATUS    ROLES     AGE       VERSION
master.aniu.so   Ready     master    4h        v1.9.1+a0ce1bc657
node1.aniu.so    Ready     <none>    4h        v1.9.1+a0ce1bc657
node2.aniu.so    Ready     <none>    4h        v1.9.1+a0ce1bc657
[root@master ~]# oc get nodes --show-labels=true 
NAME             STATUS    ROLES     AGE       VERSION             LABELS
master.aniu.so   Ready     master    4h        v1.9.1+a0ce1bc657   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/hostname=master.aniu.so,node-role.kubernetes.io/master=true,region=infra,zone=default
node1.aniu.so    Ready     <none>    4h        v1.9.1+a0ce1bc657   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/hostname=node1.aniu.so,region=primary,zone=east
node2.aniu.so    Ready     <none>    4h        v1.9.1+a0ce1bc657   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/hostname=node2.aniu.so,region=primary,zone=west 
```

## 创建一个新用户用来登录openshift

- 在master节点上创建用户：

```
[root@master ~]# htpasswd /etc/origin/master/.htpasswd aniu # 
```

- 用任何操作系统用户登录，然后登录OpenShift群集，只需添加一个HTPasswd用户

```
[root@master ~]# oc login
Authentication required for https://master.aniu.so:8443 (openshift)
Username: aniu
Password: 
Login successful.

You don't have any projects. You can try to create a new project, by running

    oc new-project <projectname>
[root@master ~]# oc whoami
aniu
[root@master ~]# oc logout
Logged "aniu" out on "https://master.aniu.so:8443"
```

- 可以从任何使用Web浏览器的客户端访问管理控制台。