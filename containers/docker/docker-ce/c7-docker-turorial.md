# Docker 快速上手教程

> Docker 是一个开源的应用容器引擎，基于 Go 语言 并遵从Apache2.0协议开源。Docker 可以让开发者打包他们的应用以及依赖包到一个轻量级、可移植的容器中，然后发布到任何流行的 Linux 机器上，也可以实现虚拟化。容器是完全使用沙箱机制，相互之间不会有任何接口（类似 iPhone 的 app）,更重要的是容器性能开销极低。

## Docker的应用场景

- Web 应用的自动化打包和发布。
- 自动化测试和持续集成、发布。
- 在服务型环境中部署和调整数据库或其他的后台应用。
- 从头编译或者扩展现有的OpenShift或Cloud Foundry平台来搭建自己的PaaS环境。

## Docker优点

- 1、简化程序：
Docker 让开发者可以打包他们的应用以及依赖包到一个可移植的容器中，然后发布到任何流行的 Linux 机器上，便可以实现虚拟化。Docker改变了虚拟化的方式，使开发者可以直接将自己的成果放入Docker中进行管理。方便快捷已经是 Docker的最大优势，过去需要用数天乃至数周的	任务，在Docker容器的处理下，只需要数秒就能完成。
- 2、避免选择恐惧症：
如果你有选择恐惧症，还是资深患者。Docker 帮你	打包你的纠结！比如 Docker 镜像；Docker 镜像中包含了运行环境和配置，所以 Docker 可以简化部署多种应用实例工作。比如 Web 应用、后台应用、数据库应用、大数据应用比如 Hadoop 集群、消息队列等等都可以打包成一个镜像部署。
- 3、节省开支：
一方面，云计算时代到来，使开发者不必为了追求效果而配置高额的硬件，Docker 改变了高性能必然高价格的思维定势。Docker 与云的结合，让云空间得到更充分的利用。不仅解决了硬件管理的问题，也改变了虚拟化的方式。

> 参考链接：

- Docker 官网：http://www.docker.com
- Github Docker 源码：https://github.com/docker/docker

## CentOS7 快速安装并使用docker

# Docker CE for CentOS

## 特点和优点

轻松安装和设置优化的Docker环境，以便在裸机服务器和虚拟机上进行CentOS分发。 最新的Docker平台版本，具有内置的业务流程（集群和调度），运行时安全性，容器网络和卷，Docker CE可免费下载，并提供社区支持的每月Edge或季度稳定版本。 Docker EE订阅包括季度版本，每个版本有一年的维护和SLA的企业级支持。

## CentOS上安装docker-ce

- 卸载旧版本
> Docker的旧版本被称为docker或docker引擎。如果这些已安装，请卸载它们以及关联的依赖关系。

```
sudo yum remove docker \
                  docker-common \
                  docker-selinux \
                  docker-engine
```

- Centore 7.3 64位支持Docker CE

> 在CentOS上设置Docker CE存储库

```
sudo yum install -y yum-utils

sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

sudo yum makecache fast
```
> 可选：启用边缘和测试存储库。这些存储库包含在上面的docker.repo文件中，但默认情况下是禁用的。您可以将它们与稳定的存储库一起启用

```
sudo yum-config-manager --enable docker-ce-edge

sudo yum-config-manager --enable docker-ce-test
# 禁用
sudo yum-config-manager --disable docker-ce-edge
```

## 在CentOS上安装最新版本的Docker CE

```
sudo yum -y install docker-ce
# 启动docker
sudo systemctl start docker
```

- 在生产系统上，我们可以安装特定版本的Docker CE，而不是始终使用最新版本。列出可用的版本。此示例使用sort -r命令按版本号排序结果，从最高到最低，并被截断。

```
[root@aniu-k8s yum.repos.d]# yum list docker-ce --showduplicates | sort -r
 * updates: mirrors.cn99.com
Loading mirror speeds from cached hostfile
Loaded plugins: fastestmirror
Installed Packages
 * extras: mirrors.shuosc.org
 * epel: mirrors.tongji.edu.cn
docker-ce.x86_64            17.09.0.ce-1.el7.centos            docker-ce-stable 
docker-ce.x86_64            17.09.0.ce-1.el7.centos            @docker-ce-stable
docker-ce.x86_64            17.06.2.ce-1.el7.centos            docker-ce-stable 
docker-ce.x86_64            17.06.1.ce-1.el7.centos            docker-ce-stable 
docker-ce.x86_64            17.06.0.ce-1.el7.centos            docker-ce-stable 
docker-ce.x86_64            17.03.2.ce-1.el7.centos            docker-ce-stable 
docker-ce.x86_64            17.03.1.ce-1.el7.centos            docker-ce-stable 
docker-ce.x86_64            17.03.0.ce-1.el7.centos            docker-ce-stable 
# 如果需要安装指定版本，参考：
sudo yum install <FULLY-QUALIFIED-PACKAGE-NAME>（17.06.2.ce-1.el7.centos）
```


- 测试Docker CE的安装

```
sudo docker run hello-world
```

- 升级Docker CE，可以把最新版本的rpm下载下来，使用 yum localinstall rpm-name升级

- 卸载Docker CE

```
sudo yum remove docker-ce
sudo rm -rf /var/lib/docker
```

## 参考教程

- https://docs.docker.com/engine/installation/linux/docker-ce/centos

