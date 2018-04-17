# ovirt 上创建vm模板

## 安装初始化虚拟机CentOS7 （笔者虚机暂时只有C7，C6），后面会加入更多的镜像及vm模板

- 如下如：以aniu-ecs-03为例：

![这里写图片描述](https://img-blog.csdn.net/20180417154058788?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3doMjExMjEy/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

当我们安装完成虚拟机后，ovirt管理控制台是不能正常获取到虚拟机的ip地址和主机名的，（Ovirt无法获取 IP Addresses 和 FQDN），因此我们需要安装ovirt-guest-agent-common软件包，然后启动ovirt-guest-agent服务，这个程序会获取vm的FQDN和ip上传到ovirt engine展示。

```
# C7添加ovirt源
[root@localhost ~]# yum -y install http://resources.ovirt.org/pub/yum-repo/ovirt-release42.rpm

# 安装ovirt agent tools
[root@localhost ~]# yum install ovirt-guest-agent-common -y

# 启动ovirt-guest-agent，并设置自启

# 参考：https://www.ovirt.org/documentation/vmm-guide/chap-Installing_Linux_Virtual_Machines/
[root@localhost ~]# systemctl start qemu-guest-agent.service
[root@localhost ~]# systemctl enable qemu-guest-agent.service

# 查看ovirt agent启动状态
[root@localhost ~]# systemctl status qemu-guest-agent
● qemu-guest-agent.service - QEMU Guest Agent
   Loaded: loaded (/usr/lib/systemd/system/qemu-guest-agent.service; enabled; vendor preset: enabled)
   Active: active (running) since Tue 2018-04-17 15:52:20 CST; 1min 18s ago
 Main PID: 7881 (qemu-ga)
   CGroup: /system.slice/qemu-guest-agent.service
           └─7881 /usr/bin/qemu-ga --method=virtio-serial --path=/dev/virtio-ports/org.qemu.guest_agent.0 --blacklist=guest-file-open,guest-file-close,guest-file-read,guest-file-write,guest-file...

Apr 17 15:52:20 localhost.localdomain systemd[1]: Started QEMU Guest Agent.
Apr 17 15:52:20 localhost.localdomain systemd[1]: Starting QEMU Guest Agent...
[root@localhost ~]# systemctl status qemu-guest-agent

# 启动ovirt-guest-agent # 笔者这里启动了两个服务ovirt-guest-agent和qemu-guest-agent
[root@localhost ~]# systemctl start ovirt-guest-agent
[root@localhost ~]# systemctl enable ovirt-guest-agent
Created symlink from /etc/systemd/system/multi-user.target.wants/ovirt-guest-agent.service to /usr/lib/systemd/system/ovirt-guest-agent.service.
[root@localhost ~]# systemctl status ovirt-guest-agent
● ovirt-guest-agent.service - oVirt Guest Agent
   Loaded: loaded (/usr/lib/systemd/system/ovirt-guest-agent.service; enabled; vendor preset: disabled)
   Active: active (running) since Tue 2018-04-17 16:00:05 CST; 11s ago
 Main PID: 7945 (python)
   CGroup: /system.slice/ovirt-guest-agent.service
           └─7945 /usr/bin/python /usr/share/ovirt-guest-agent/ovirt-guest-agent.py

Apr 17 16:00:05 localhost.localdomain systemd[1]: Starting oVirt Guest Agent...
Apr 17 16:00:05 localhost.localdomain systemd[1]: Started oVirt Guest Agent.
Apr 17 16:00:06 localhost.localdomain userhelper[7955]: pam_succeed_if(ovirt-container-list:auth): requirement "user = ovirtagent" was met by user "ovirtagent"
Apr 17 16:00:06 localhost.localdomain userhelper[7954]: pam_succeed_if(ovirt-container-list:auth): requirement "user = ovirtagent" was met by user "ovirtagent"
Apr 17 16:00:06 localhost.localdomain userhelper[7954]: running '/usr/share/ovirt-guest-agent/container-list' with root privileges on behalf of 'ovirtagent'
Apr 17 16:00:06 localhost.localdomain userhelper[7955]: running '/usr/share/ovirt-guest-agent/container-list' with root privileges on behalf of 'ovirtagent'
Apr 17 16:00:06 localhost.localdomain userhelper[7965]: pam_succeed_if(ovirt-locksession:auth): requirement "user = ovirtagent" was met by user "ovirtagent"
Apr 17 16:00:06 localhost.localdomain userhelper[7965]: running '/usr/share/ovirt-guest-agent/LockActiveSession.py' with root privileges on behalf of 'ovirtagent'
Apr 17 16:00:15 localhost.localdomain userhelper[7987]: pam_succeed_if(ovirt-container-list:auth): requirement "user = ovirtagent" was met by user "ovirtagent"
Apr 17 16:00:15 localhost.localdomain userhelper[7987]: running '/usr/share/ovirt-guest-agent/container-list' with root privileges on behalf of 'ovirtagent'
```


- 等待一会到ovirt管理界面查看aniu-ecs-03是否能够正常显示ip和FQDN

![这里写图片描述](https://img-blog.csdn.net/20180417160419801?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3doMjExMjEy/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

从上图可以看出，从ovirt控制面板能够ovirt engine已经获取到了vm的ip地址但是 FQDN貌似还没有获取到，笔者准备进行对vm进行一些初始化设置

- 禁用IPV6及关闭selinux，笔者用不到

```
# 修改主机名编辑hosts
[root@localhost ~]# hostnamectl set-hostname ecs-03
[root@localhost ~]# cat /etc/hosts
127.0.0.1   localhost localhost.localdomain

# 建议修改配置文件关闭，需要重启
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

## 修改启动加载的内核参数

[root@localhost ~]# vi /etc/default/grub
# line 6: add
GRUB_CMDLINE_LINUX="ipv6.disable=1 rd.lvm.lv=fedora-server/root.....
# apply changing
[root@localhost ~]# grub2-mkconfig -o /boot/grub2/grub.cfg 
[root@localhost ~]# reboot 
```

再次到控制台查看aniu-ecs-03的ip和FQDN情况，如下：
![这里写图片描述](https://img-blog.csdn.net/20180417161209871?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3doMjExMjEy/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 使用aniu-ecs-03创建vm模板

- 笔者的aniu-ecs-03规格为：Medium  2 cpu 4G mem  20G disk ，GMT China Standard Time，设置了HA，
![这里写图片描述](https://img-blog.csdn.net/20180417161628873?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3doMjExMjEy/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

停止aniu-ecs-03，然后右上角选择make template，如下：
![这里写图片描述](https://img-blog.csdn.net/20180417164539704?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3doMjExMjEy/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

自定义模板名称，描述，点击ok确认创建模板：

![这里写图片描述](https://img-blog.csdn.net/20180417171802468?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3doMjExMjEy/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

- 创建模板介绍先写到这里，笔者的想法是继续对vm完善，安装一些必须的依赖包，在进行创建模板。

