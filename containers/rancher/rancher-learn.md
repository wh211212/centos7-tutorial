# Rancher（2.0）是Kubernetes的企业管理

## Architecture

介绍Rancher如何与Rancher构建的两种基本技术进行交互：Docker和Kubernetes

### Docker

Docker是容器包装和运行时标准。开发人员从Dockerfiles构建容器映像，并从Docker注册表中分发容器映像。Docker Hub是最受欢迎的公共注册中心。许多组织还设置了私有Docker注册表。 Docker主要用于管理各个节点上的容器。

### Kubernetes

Kubernetes是容器集群管理标准。YAML文件指定形成应用程序的容器和其他资源。Kubernetes执行诸如调度，扩展，服务发现，运行状况检查，私钥管理和配置管理等功能。

Kubernetes集群由多个节点组成

- etcd database

虽然只能在一个节点上运行etcd，但通常需要3个，5个或更多节点来创建HA配置。

- Master nodes

主节点是无状态的，用于运行API服务器，调度程序和控制器。

- Worker nodes

应用程序工作负载在工作节点上运行

### Rancher