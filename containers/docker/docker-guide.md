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

- 获取镜像

```

```

- 查看镜像信息

- 搜索镜像

- 删除镜像

- 使用镜像ID删除镜像

- 创建镜像

- 存出与载入镜像








