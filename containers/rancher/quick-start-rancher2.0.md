# 快速安装rancher环境指南

## 准备linux主机

- A cloud-host vm
- 内部部署VM
- 裸机（物理机）

> 使用云托管虚拟机时，需要允许到端口80和443的入站TCP通信。

根据以下要求配置主机

- Ubuntu 16.04 (64-bit)
- Red Hat Enterprise Linux 7.5 (64-bit)
- RancherOS 1.3.0 (64-bit)

要求：Memory：4GB ，disk:50GB Docker：1.12.6、1.13.1、17.03.2

## 安装Rancher

- docker安装

```
sudo docker run -d --restart=unless-stopped -p 80:80 -p 443:443 rancher/rancher:stable
```

- 登录，登录Rancher开始使用该应用程序。登录后，将进行一些一次性配置。

1、通过浏览器访问：https://<SERVER_IP>
2、初始为admin创建密码
3、设置Rancher Server URL。 URL可以是IP地址或主机名。但是，添加到群集的每个节点都必须能够连接到此URL

## 创建集群






## 报错

- [ERROR] cluster [c-zqp2n] provisioning: Unsupported Docker version found [18.03.1-ce], supported versions are [1.11.x 1.12.x 1.13.x 17.03.x]

更改docker版本：yy

