# 安装OpenShift容器注册表的独立部署

## 关于OpenShift容器注册表

OpenShift Origin是一个全功能的企业解决方案，包括一个名为OpenShift Container Registry（OCR）的集成容器注册表 。或者，您可以将OCR作为独立的容器注册表安装在本地或云中运行，而不是将OpenShift Origin作为开发人员的完整PaaS环境部署。

在安装OCR的独立部署时，仍会安装一个主节点和节点集群，与典型的OpenShift Origin安装类似。然后，将容器注册表部署为在集群上运行。此独立部署选项对于需要容器注册表的管理员非常有用，但不需要包含以开发人员为中心的Web控制台和应用程序构建和部署工具的完整OpenShift Origin环境。

OCR提供以下功能：

- 以用户为中心的注册表Web控制台。

- 默认安全流量，通过TLS提供。

- 全球身份提供商认证。

- 一个 项目命名空间模型，使团队可以通过基于角色的访问控制（RBAC）授权进行协作 。

- 一个基于Kubernetes集群管理服务。

- 称为图像流的图像抽象以增强图像管理。

管理员可能希望部署独立的OCR来单独管理支持多个OpenShift Origin群集的注册表。独立的OCR还使管理员能够分离其注册表以满足其自己的安全或合规要求。

## 最低硬件要求

安装独立的OCR具有以下硬件要求：

- 物理或虚拟系统，或运行在公共或私人IaaS上的实例。

- 基本操作系统：Fedora 21，CentOS 7.4或RHEL 7.3,7.4或7.5，带有“最小”安装选项以及来自RHEL 7 Extras频道或RHEL Atomic Host 7.4.5或更高版本的最新软件包。

- NetworkManager 1.0或更高版本

- 2个vCPU。

- 最小16 GB RAM。

- 包含/ var /的文件系统的最小15 GB硬盘空间。

- Docker存储后端使用额外的最小15 GB未分配空间; 详情请参阅配置Docker存储。

- OpenShift Origin仅支持x86_64架构的服务器。

会议将在/ var /在RHEL原子主机文件系统的大小要求，需要更改默认配置。请参阅 在Red Hat Enterprise Linux Atomic Host中管理存储器，以获取有关在安装期间或安装后进行配置的说明。

## 支持的系统拓扑

独立OCR支持以下系统拓扑：

- All-in-one 包含主节点，节点，etcd和注册表组件的单个主机。
- Multiple Masters (Highly-Available) 每台主机上都包含三台主机（主节点，节点，etcd和注册表），主设备配置为实现高可用性。

## 主机准备