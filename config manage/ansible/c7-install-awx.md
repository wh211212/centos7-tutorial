# CentOS7 安装Ansible AWX

## AWX服务器的最低系统要求

> 4GB 2CPU 20GB ，运行在docker、openshift、或者kubernetes

- 系统设置。关闭selinux，停止firewalld，更改hostname

```
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

systemctl stop firewalld && systemctl disable firewalld

hostnamectl set-hostname ansible-awx
# 笔者虚拟机从来都关闭ipv6
```

- 启用epel源

```
# yum install -y epel-release
```

- 安装postgreSQL 9.6，为了后面AWX的安装

```
# yum install -y https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm # 若版本失效，自行替换当前最新
# yum install postgresql96-server -y
```

- 安装依赖服务

```
yum install -y rabbitmq-server wget memcached nginx ansible
```

## 安装Ansible AWX

- 添加awx源

```
# wget -O /etc/yum.repos.d/awx-rpm.repo https://copr.fedorainfracloud.org/coprs/mrmeee/awx/repo/epel-7/mrmeee-awx-epel-7.repo
```

- 使用rpm安装awx

```
# yum install -y awx
```

- 初始化postgresql

```
usr/pgsql-9.6/bin/postgresql96-setup initdb
```

- 启动消息通道rabbitmq服务

```
[root@awx ~]# systemctl start rabbitmq-server
[root@awx ~]# systemctl enable rabbitmq-server
Created symlink from /etc/systemd/system/multi-user.target.wants/rabbitmq-server.service to /usr/lib/systemd/system/rabbitmq-server.service.
[root@awx ~]#
```

- 启动postgresql服务

```
[root@awx ~]# systemctl enable postgresql-9.6
Created symlink from /etc/systemd/system/multi-user.target.wants/postgresql-9.6.service to /usr/lib/systemd/system/postgresql-9.6.service.
[root@awx ~]# systemctl start postgresql-9.6
```

- 启动memcached服务

```
[root@awx ~]# systemctl enable memcached
Created symlink from /etc/systemd/system/multi-user.target.wants/memcached.service to /usr/lib/systemd/system/memcached.service.
[root@awx ~]# systemctl start memcached
```

- 创建postgres用户和数据库

```
cd /tmp # 建议到tmp服务执行，不然可能会报：could not change directory to "/root": Permission denied
[root@awx ~]# sudo -u postgres createuser -S awx

[root@awx ~]# sudo -u postgres createdb -O awx awx
```

- 导入数据库

```
[root@awx ~]# sudo -u awx /opt/awx/bin/awx-manage migrate
```

- AWX初始化配置

```
[root@awx ~]# echo "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'root@localhost', 'password')" | sudo -u awx /opt/awx/bin/awx-manage shell
[root@awx ~]# sudo -u awx /opt/awx/bin/awx-manage create_preload_data
Default organization added.
Demo Credential, Inventory, and Job Template added.
[root@awx ~]# sudo -u awx /opt/awx/bin/awx-manage provision_instance --hostname=$(hostname)
Successfully registered instance awx.sunil.cc
(changed: True)
[root@awx ~]# sudo -u awx /opt/awx/bin/awx-manage register_queue --queuename=tower --hostnames=$(hostname)
Creating instance group tower
Added instance awx.sunil.cc to tower
(changed: True)
```

- 配置nginx

```
[root@awx ~]# cd /etc/nginx/
[root@awx nginx]# pwd
/etc/nginx
[root@awx nginx]# cp nginx.conf nginx.conf.bkp

# 替换nginx.conf
[root@awx nginx]# wget -O /etc/nginx/nginx.conf https://raw.githubusercontent.com/sunilsankar/awx-build/master/nginx.conf
```

- 启动nginx

```
[root@awx ~]# systemctl start nginx
[root@awx ~]# systemctl enable nginx
```
- 

- 启动AWX服务

```
[root@awx ~]# systemctl start awx-cbreceiver
[root@awx ~]# systemctl start awx-celery-beat
[root@awx ~]# systemctl start awx-celery-worker
[root@awx ~]# systemctl start awx-channels-worker
[root@awx ~]# systemctl start awx-daphne
[root@awx ~]# systemctl start awx-web
```

- 设置服务自启

```
[root@awx ~]# systemctl enable awx-cbreceiver
Created symlink from /etc/systemd/system/multi-user.target.wants/awx-cbreceiver.service to /usr/lib/systemd/system/awx-cbreceiver.service.
[root@awx ~]# systemctl enable awx-celery-beat
Created symlink from /etc/systemd/system/multi-user.target.wants/awx-celery-beat.service to /usr/lib/systemd/system/awx-celery-beat.service.
[root@awx ~]# systemctl enable awx-celery-worker
Created symlink from /etc/systemd/system/multi-user.target.wants/awx-celery-worker.service to /usr/lib/systemd/system/awx-celery-worker.service.
[root@awx ~]# systemctl enable awx-channels-worker
Created symlink from /etc/systemd/system/multi-user.target.wants/awx-channels-worker.service to /usr/lib/systemd/system/awx-channels-worker.service.
[root@awx ~]# systemctl enable awx-daphne
Created symlink from /etc/systemd/system/multi-user.target.wants/awx-daphne.service to /usr/lib/systemd/system/awx-daphne.service.
[root@awx ~]# systemctl enable awx-web
Created symlink from /etc/systemd/system/multi-user.target.wants/awx-web.service to /usr/lib/systemd/system/awx-web.service.
[root@awx ~]#
```

- 从AWX服务器配置无密码登录

systemctl restart awx-cbreceiver
systemctl restart awx-celery-beat
systemctl restart awx-celery-worker
systemctl restart awx-channels-worker
systemctl restart awx-daphne
systemctl restart awx-web



