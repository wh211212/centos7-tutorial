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

要求：Memory：4GB ，disk:50GB Docker：1.12.6、1.13.1、17.03.2 ,docker版本henz

## 安装Rancher

- docker安装

```
sudo docker run -d --restart=unless-stopped -p 80:80 -p 443:443 rancher/rancher:stable
```

- 登录，登录Rancher开始使用该应用程序。登录后，将进行一些一次性配置。

1、通过浏览器访问：https://<SERVER_IP>
2、初始为admin创建密码
3、设置Rancher Server URL。 URL可以是IP地址或主机名。但是，添加到群集的每个节点都必须能够连接到此URL
![这里写图片描述](https://img-blog.csdn.net/20180705175244606?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3doMjExMjEy/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
![这里写图片描述](https://img-blog.csdn.net/20180705175253562?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3doMjExMjEy/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 创建集群

- 步骤，add cluster - 选择 custom- 输入名字：rancher-1（自定义）- 默认next，选择所有角色：etcd、control、worker
![这里写图片描述](https://img-blog.csdn.net/20180705175704145?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3doMjExMjEy/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

- 复制docker run命令。贴到vm上执行，然后点击done完成。成功结果如下：

![这里写图片描述](https://img-blog.csdn.net/20180705175822554?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3doMjExMjEy/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)


## 注意事项

- docker版本选择，根据官网提供的版本进行安装
- 笔者关闭了防火墙
- 创建cluster的时候先执行生成的docker run命令再点击done
- 如果安装失败删除容器重新来一遍

## 部署工作负载






























































































































