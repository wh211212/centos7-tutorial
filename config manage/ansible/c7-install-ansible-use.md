# CentOS7 安装ansible并配置使用

## 实验环境

- CentOS7, epel源

## 安装ansible

yum -y install ansible openssh-clients

- 配置ansible

[yunwei@wanghui ~]$ egrep -v "^#|^$" /etc/ansible/ansible.cfg 
[defaults]
inventory      = /etc/ansible/hosts
remote_port    = 54077 # 更改ssh端口
host_key_checking = False #取消此行注释
[inventory]
[privilege_escalation]
[paramiko_connection]
[ssh_connection]
[persistent_connection]
[accelerate]
[selinux]
[colors]
[diff]

其他参数修改，直接编辑sudo vim /etc/ansible/ansible.cfg。

- 配置hosts
[yunwei@wanghui ~]$ egrep -v "^#|^$" /etc/ansible/hosts
192.168.0.111
[web]
192.168.0.50
192.168.0.51

- 使用yunwei执行ansible前，需要在不同的服务器上设置yunwei用户间的免密认证登录

[yunwei@wanghui ~]$ ansible all --list-hosts
  hosts (3):
    192.168.0.111
    192.168.0.50
    192.168.0.51
[yunwei@wanghui ~]$ ansible web --list-hosts
  hosts (2):
    192.168.0.50
    192.168.0.51

- ansible 同步文件 

ansible allapi -m copy -a "src=/tmp/tomcatall dest=/etc/init.d/tomcatall"


ansible all -m copy -a "src=/etc/chrony.conf dest=/etc/chrony.conf"

- 同步hosts文件

ansible k8s -m copy -a "src=/etc/hosts dest=/etc/hosts"

ansible ovirt -a "yum install chrony -y && systemctl restart chronyd && systemctl enable chronyd"

ansible ovirt -m copy -a "src=/etc/chrony.conf dest=/etc/chrony.conf"

ansible ovirt -a "/usr/bin/chronyc sourcestats"