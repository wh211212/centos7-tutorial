# Docker技术入门与实战

## Hello Docker

- 官网文档：https://docs.docker.com/

Docker主要目标：Build、Ship and Run Any App，Anywhere，通过对应用组件的封装（packaging）、分发（Distribution）、部署（Deployment）、运行（Running），一次封装、到处运行

- Linux容器技术（Linux Containers，LXC）

> 容器有效地将由单个操作系统管理的资源划分到孤立的组中，以便更好的在孤立的组中间平衡有冲突的资源使用需求。与虚拟化相比，这样既不需要指令级模拟，也不需要即时编译。容器可以在核心CPU本地运行命令、而不需要任何专门的解释机制。避免了准虚拟机和系统调用替换中的复杂性。

- Docker优势

更快速的交付和部署
更搞笑的资源利用
更轻松的迁移和扩展
更简单的更新管理

> Docker与虚拟机比较

- Docker容器启动和停止可以秒级实现，相对于传统虚拟机快很多
- Docker容器对系统资源需求很少，一台主机可以运行上千个Docker容器
- Docker通过Dockerfile配置文件来支持灵活的自动化创建和部署机制、提高效率
- Docker容器实在操作系统层面上实现虚拟化，传统方式实在硬件层面实现虚拟化

## Docker核心概念和安装

- Docker镜像：类似虚拟机镜像

- Docker容器：轻量级沙箱，可看成简历版linux运行环境

- Docker仓库：类似代码仓库、是Docker集中存放镜像文件的场所。分为：公开仓库、私有仓库

### Docker安装

笔者环境：CentOS Linux release 7.5

- 安装Docker

```
yum -y install docker
systemctl start docker && systemctl enable docker 
[root@ops-223 ~]# docker version
Client:
 Version:         1.13.1
 API version:     1.26
 Package version: docker-1.13.1-63.git94f4240.el7.centos.x86_64
 Go version:      go1.9.4
 Git commit:      94f4240/1.13.1
 Built:           Fri May 18 15:44:33 2018
 OS/Arch:         linux/amd64

Server:
 Version:         1.13.1
 API version:     1.26 (minimum version 1.12)
 Package version: docker-1.13.1-63.git94f4240.el7.centos.x86_64
 Go version:      go1.9.4
 Git commit:      94f4240/1.13.1
 Built:           Fri May 18 15:44:33 2018
 OS/Arch:         linux/amd64
 Experimental:    false
```

### Docker镜像

镜像是Docker运行容器的前提

- 获取镜像

```
[root@ops-223 ~]# docker pull centos
Using default tag: latest
Trying to pull repository docker.io/library/centos ... 
latest: Pulling from docker.io/library/centos
7dc0dca2b151: Downloading 2.124 MB/74.69 MB

# 镜像文件一般由若干层组成、行首7dc0dca2b151这样的字串代表了各层的ID，下载过程会获取并输出镜像的各层信息，层（Layer）是AUFS（Advanced Union File System、一种联合文件系统）中的重要概念、是实现增量更新和保存的基础

# 可以通过指定标签、下载特定版本的镜像，例如：docker pull ubuntu:16.04 

# 利用镜像创建一个容器，并运行bash应用
[root@ops-223 ~]# docker run -i -t centos /bin/bash
[root@c5b5350ad64a /]# uname -a
Linux c5b5350ad64a 3.10.0-862.3.3.el7.x86_64 #1 SMP Fri Jun 15 04:15:27 UTC 2018 x86_64 x86_64 x86_64 GNU/Linux
[root@c5b5350ad64a /]# exit
exit

# 果退出Container会话并保持容器的进程，请按Ctrl + p和Ctrl + q键。
[root@ops-223 ~]# docker run -i -t centos /bin/bash
[root@c5b5350ad64a /]# uname -a
Linux c5b5350ad64a 3.10.0-862.3.3.el7.x86_64 #1 SMP Fri Jun 15 04:15:27 UTC 2018 x86_64 x86_64 x86_64 GNU/Linux
[root@c5b5350ad64a /]# exit
exit
[root@ops-223 ~]# docker run -i -t centos /bin/bash 
[root@aa459856bbb3 /]# [root@ops-223 ~]# #按Ctrl+p和Ctrl+q键
[root@ops-223 ~]# docker ps 
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
aa459856bbb3        centos              "/bin/bash"         15 seconds ago      Up 12 seconds                           boring_perlman
[root@ops-223 ~]# docker attach aa459856bbb3 # 访问容器
[root@aa459856bbb3 /]# [root@ops-223 ~]# 
[root@ops-223 ~]# docker kill aa459856bbb3 # 停止容器
aa459856bbb3
[root@ops-223 ~]# docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
```

- 查看镜像信息

```
# 使用docker images列出本机上已有镜像
[root@ops-223 ~]# docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
docker.io/ubuntu    16.04               5e8b97a2a082        4 weeks ago         114 MB
docker.io/centos    latest              49f7960eb7e4        4 weeks ago         200 MB

# 字段含义： 来源仓库、镜像标签、镜像ID、镜像创建时间、镜像大小

# 使用docker tag命令为本地镜像添加标签

# 使用docker inspect 查看镜像详细信息
```

- 搜索镜像

```
# 使用docker search搜索远端仓库中共享的镜像、默认搜索Docker Hub官方仓库中的镜像
[root@ops-223 ~]# docker search mysql --limit 3
INDEX       NAME                           DESCRIPTION                                     STARS     OFFICIAL   AUTOMATED
docker.io   docker.io/mysql                MySQL is a widely used, open-source relati...   6506      [OK]       
docker.io   docker.io/mysql/mysql-server   Optimized MySQL Server Docker images. Crea...   476                  [OK]
docker.io   docker.io/circleci/mysql       MySQL is a widely used, open-source relati...   5    

#返回信息：镜像名字、星级、是否官方创建、是的自动创建
```

- 删除镜像

```
# 使用镜像ID删除镜像
[root@ops-223 ~]# docker rmi 5e8b97a2a082 # 删除ubuntu镜像
Untagged: docker.io/ubuntu:16.04
Untagged: docker.io/ubuntu@sha256:b050c1822d37a4463c01ceda24d0fc4c679b0dd3c43e742730e2884d3c582e3a
Deleted: sha256:5e8b97a2a0820b10338bd91674249a94679e4568fd1183ea46acff63b9883e9c
Deleted: sha256:ef572e1ba2ecca900f0ec3db00e997de12dd380ce3e360b5813fd75920232359
Deleted: sha256:98fc4d5421178c7be7d5718d2d44abba8053dc5c712e51658fe5b872675b4f7a
Deleted: sha256:7b2cc05dfd889e28234f8831c80ac20cf299d5bbebbbac013f8f7d2b7abc0d65
Deleted: sha256:6b0187d1cdff63eb5966ac72bf4ccd96150586c1409eb858bb98783f02018ee7
Deleted: sha256:644879075e24394efef8a7dddefbc133aad42002df6223cacf98bd1e3d5ddde2
# 使用镜像标签删除镜像
```

- 创建镜像

```
# 基于已有镜像的容器创建、基于本地模板导入、基于Dockerfile创建
```

- 存出与载入镜像

```
# 存出镜像
[root@ops-223 ~]# docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
docker.io/centos    latest              49f7960eb7e4        4 weeks ago         200 MB
[root@ops-223 ~]# docker save -o centos_latest.tar centos:latest

# 载入镜像
[root@ops-223 ~]# docker load < centos_latest.tar
```

## Docker容器

> 容器是镜像的一个运行实例

### 





