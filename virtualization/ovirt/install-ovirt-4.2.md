# 安装虚拟化环境管理工具oVirt

| Hostname      | Role             | IP            |
| ------------- |:----------------:| -------------:|
| ovirt.aniu.so | oVirt Management | 192.168.1.115 |
| ovirt1        | oVirt Node 1     | 192.168.1.131 |
| ovirt2        | oVirt Node 1     | 192.168.1.132 |

## 安装oVirt

- 设置hosts

```
[root@ovirt ~]# cat /etc/hosts
127.0.0.1   localhost localhost.localdomain 

# ovirt
192.168.1.115 ovirt.aniu.so
192.168.1.131 ovirt1
192.168.1.132 ovirt2

# 笔者主机名为：ovirt.aniu.so
```

- 参考官网文档：https://ovirt.org/documentation/quickstart/quickstart-guide/

```
[root@ovirt ~]# yum -y install http://resources.ovirt.org/pub/yum-repo/ovirt-release42.rpm
[root@ovirt ~]# yum -y install ovirt-engine

# 安装配置nfs作为本地存储，详解参考：https://www.ovirt.org/documentation/admin-guide/chap-Storage/

[root@ovirt ~]# touch /etc/exports 
[root@ovirt ~]# systemctl start rpcbind nfs-server 
[root@ovirt ~]# systemctl enable rpcbind nfs-server 

# 注意：安装nfs并配置，可以先不设置，后面进行单独安装配置

[root@ovirt ~]# engine-setup # ovirt engine安装，一直回车默认即可，安装如下：

[ INFO  ] Stage: Initializing
[ INFO  ] Stage: Environment setup
          Configuration files: ['/etc/ovirt-engine-setup.conf.d/10-packaging-jboss.conf', '/etc/ovirt-engine-setup.conf.d/10-packaging.conf']
          Log file: /var/log/ovirt-engine/setup/ovirt-engine-setup-20180404232742-tiy6om.log # 建议tailf 查看实时日志
          Version: otopi-1.7.7 (otopi-1.7.7-1.el7.w'hos)
[ INFO  ] Stage: Environment packages setup
[ INFO  ] Stage: Programs detection
[ INFO  ] Stage: Environment setup
[ INFO  ] Stage: Environment customization
         
          --== PRODUCT OPTIONS ==--
         
          Configure Engine on this host (Yes, No) [Yes]: 
          Configure ovirt-provider-ovn (Yes, No) [Yes]:  # 卸载重新安装时 这里选择on
          Configure Image I/O Proxy on this host (Yes, No) [Yes]: 
          Configure WebSocket Proxy on this host (Yes, No) [Yes]: 
         
          * Please note * : Data Warehouse is required for the engine.
          If you choose to not configure it on this host, you have to configure
          it on a remote host, and then configure the engine on this host so
          that it can access the database of the remote Data Warehouse host.
          Configure Data Warehouse on this host (Yes, No) [Yes]: 
          Configure VM Console Proxy on this host (Yes, No) [Yes]: 
         
          --== PACKAGES ==--
         
[ INFO  ] Checking for product updates...
[ INFO  ] No product updates found
         
          --== NETWORK CONFIGURATION ==--
         
          Host fully qualified DNS name of this server [ovirt.aniu.so]: #注意此处的dns name
[WARNING] Failed to resolve ovirt.aniu.so using DNS, it can be resolved only locally
         
          --== DATABASE CONFIGURATION ==--
         
          Where is the DWH database located? (Local, Remote) [Local]: 
          Setup can configure the local postgresql server automatically for the DWH to run. This may conflict with existing applications.
          Would you like Setup to automatically configure postgresql and create DWH database, or prefer to perform that manually? (Automatic, Manual) [Automatic]: 
          Where is the Engine database located? (Local, Remote) [Local]: 
          Setup can configure the local postgresql server automatically for the engine to run. This may conflict with existing applications.
          Would you like Setup to automatically configure postgresql and create Engine database, or prefer to perform that manually? (Automatic, Manual) [Automatic]: 
         
          --== OVIRT ENGINE CONFIGURATION ==--
         
          Engine admin password: 
          Confirm engine admin password: 
[WARNING] Password is weak: it does not contain enough DIFFERENT characters
          Use weak password? (Yes, No) [No]: Yes
          Application mode (Virt, Gluster, Both) [Both]: 
          Use default credentials (admin@internal) for ovirt-provider-ovn (Yes, No) [Yes]: 
         
          --== STORAGE CONFIGURATION ==--
         
          Default SAN wipe after delete (Yes, No) [No]: 
         
          --== PKI CONFIGURATION ==--
         
          Organization name for certificate [aniu.so]: 
         
          --== APACHE CONFIGURATION ==--
         
          Setup can configure the default page of the web server to present the application home page. This may conflict with existing applications.
          Do you wish to set the application as the default page of the web server? (Yes, No) [Yes]: 
          Setup can configure apache to use SSL using a certificate issued from the internal CA.
          Do you wish Setup to configure that, or prefer to perform that manually? (Automatic, Manual) [Automatic]: 
         
          --== SYSTEM CONFIGURATION ==--
         
         
          --== MISC CONFIGURATION ==--
         
          Please choose Data Warehouse sampling scale:
          (1) Basic
          (2) Full
          (1, 2)[1]: 
         
          --== END OF CONFIGURATION ==--
         
[ INFO  ] Stage: Setup validation
[WARNING] Less than 16384MB of memory is available
         
          --== CONFIGURATION PREVIEW ==--
         
          Application mode                        : both
          Default SAN wipe after delete           : False
          Update Firewall                         : False
          Host FQDN                               : ovirt.aniu.so
          Configure local Engine database         : True
          Set application as default page         : True
          Configure Apache SSL                    : True
          Engine database secured connection      : False
          Engine database user name               : engine
          Engine database name                    : engine
          Engine database host                    : localhost
          Engine database port                    : 5432
          Engine database host name validation    : False
          Engine installation                     : True
          PKI organization                        : aniu.so
          Set up ovirt-provider-ovn               : True
          Configure WebSocket Proxy               : True
          DWH installation                        : True
          DWH database host                       : localhost
          DWH database port                       : 5432
          Configure local DWH database            : True
          Configure Image I/O Proxy               : True
          Configure VMConsole Proxy               : True
         
          Please confirm installation settings (OK, Cancel) [OK]: # 回车后开始安装
[ INFO  ] Stage: Transaction setup
[ INFO  ] Stopping engine service
[ INFO  ] Stopping ovirt-fence-kdump-listener service
[ INFO  ] Stopping dwh service
[ INFO  ] Stopping Image I/O Proxy service
[ INFO  ] Stopping vmconsole-proxy service
[ INFO  ] Stopping websocket-proxy service
[ INFO  ] Stage: Misc configuration
[ INFO  ] Stage: Package installation
[ INFO  ] Stage: Misc configuration
[ INFO  ] Upgrading CA
[ INFO  ] Initializing PostgreSQL
[ INFO  ] Creating PostgreSQL 'engine' database
[ INFO  ] Configuring PostgreSQL
[ INFO  ] Creating PostgreSQL 'ovirt_engine_history' database
[ INFO  ] Configuring PostgreSQL
[ INFO  ] Creating CA
[ INFO  ] Creating/refreshing DWH database schema
[ INFO  ] Configuring Image I/O Proxy
[ INFO  ] Setting up ovirt-vmconsole proxy helper PKI artifacts
[ INFO  ] Setting up ovirt-vmconsole SSH PKI artifacts
[ INFO  ] Configuring WebSocket Proxy
[ INFO  ] Creating/refreshing Engine database schema
[ INFO  ] Creating/refreshing Engine 'internal' domain database schema
[ INFO  ] Adding default OVN provider to database
[ INFO  ] Adding OVN provider secret to database
[ INFO  ] Setting a password for internal user admin
[ INFO  ] Generating post install configuration file '/etc/ovirt-engine-setup.conf.d/20-setup-ovirt-post.conf'
[ INFO  ] Stage: Transaction commit
[ INFO  ] Stage: Closing up
[ INFO  ] Starting engine service
[ INFO  ] Starting dwh service
[ INFO  ] Restarting ovirt-vmconsole proxy service
         
          --== SUMMARY ==--
         
[ INFO  ] Restarting httpd
          In order to configure firewalld, copy the files from
              /etc/ovirt-engine/firewalld to /etc/firewalld/services
              and execute the following commands:
              firewall-cmd --permanent --add-service ovirt-postgres
              firewall-cmd --permanent --add-service ovirt-https
              firewall-cmd --permanent --add-service ovn-w'hral-firewall-service
              firewall-cmd --permanent --add-service ovirt-fence-kdump-listener
              firewall-cmd --permanent --add-service ovirt-imageio-proxy
              firewall-cmd --permanent --add-service ovirt-websocket-proxy
              firewall-cmd --permanent --add-service ovirt-http
              firewall-cmd --permanent --add-service ovirt-vmconsole-proxy
              firewall-cmd --permanent --add-service ovirt-provider-ovn
              firewall-cmd --reload
          The following network ports should be opened:
              tcp:2222
              tcp:35357
              tcp:443
              tcp:5432
              tcp:54323
              tcp:6100
              tcp:6641
              tcp:6642
              tcp:80
              tcp:9696
              udp:7410
          An example of the required configuration for iptables can be found at:
              /etc/ovirt-engine/iptables.example
          Please use the user 'admin@internal' and password specified in order to login
          Web access is enabled at:
              http://ovirt.aniu.so:80/ovirt-engine
              https://ovirt.aniu.so:443/ovirt-engine # 本地解析ovirt.aniu.so，然后浏览器直接访问
          Internal CA 90:4A:AC:7A:81:E4:B1:FD:00:02:0B:29:E9:E9:A2:3D:FC:9A:48:6F
          SSH fingerprint: SHA256:w4SOlDH2QH8/Bun839L+RO/VKYW/tFdKdHtF2jgPoas
[WARNING] Less than 16384MB of memory is available # 建议内存加大
         
          --== END OF SUMMARY ==--
         
[ INFO  ] Stage: Clean up
          Log file is located at /var/log/ovirt-engine/setup/ovirt-engine-setup-20180404232742-tiy6om.log
[ INFO  ] Generating answer file '/var/lib/ovirt-engine/setup/answers/20180404233332-setup.conf'
[ INFO  ] Stage: Pre-termination
[ INFO  ] Stage: Termination
[ INFO  ] Execution of setup completed successfully # 安装完成

- 安装桌面环境，很主要（笔者的w'hOS7 是最小化安装的，安装时没有安装桌面），方便后面安装node时管理vm

```
[root@ovirt ~]# yum -y groups install "GNOME Desktop"   # 此操作在oVirt Management所在服务器执行

[root@ovirt ~]# startx 
```

- 配置vnc，方便远程管理oVirt Management

```
# 安装VNC服务
[root@ovirt ~]# yum -y install tigervnc-server

# set VNC password
[wh@ovirt ~]$ vncpasswd 
Password:
Verify:
# run with diplay number [1], screen resolution [800x600], color depth [24]
[wh@ovirt ~]$ vncserver :1 -geometry 1920x1080 -depth 24 # 读者可以根据显示屏调整分辨率
# 笔者是root用户执行的，忘记切换到wh用户
xauth:  file /root/.Xauthority does not exist

New 'ovirt.aniu.so:1 (root)' desktop is ovirt.aniu.so:1

Creating default startup script /root/.vnc/xstartup
Creating default config /root/.vnc/config
Starting applications specified in /root/.vnc/xstartup
Log file is /root/.vnc/ovirt.aniu.so:1.log

# to stop VNC process, do like follows
[wh@ovirt ~]$ vncserver -kill :1 # 停止vncserver
```

- 本地通过VNC viewer连接远程host

## 安装oVirt Node

- 安装KVM (基于KVM（基于内核的虚拟机）+ QEMU的虚拟化)

```
# 首先在ovirt1执行下面操作，ovirt2执行同样的操作
[root@ovirt1 ~]# yum -y install qemu-kvm libvirt virt-install bridge-utils
# make sure modules are loaded
[root@ovirt1 ~]# lsmod | grep kvm 
kvm_intel             174250  0 
kvm                   570658  1 kvm_intel
irqbypass              13503  1 kvm

[root@ovirt1 ~]# systemctl start libvirtd 
[root@ovirt1 ~]# systemctl enable libvirtd 
```

- 安装oVirt Node

```
[root@ovirt1 ~]# yum -y install http://resources.ovirt.org/pub/yum-repo/ovirt-release42.rpm  # 笔者安装时，官方最新rpm源，读者可自行更改，4.2优化了管理界面，笔者很喜欢
[root@ovirt1 ~]# yum -y install vdsm

# 笔者这里安装的时候遇到了软件包依赖问题，解决：--skip-broken
```

## 从oVirt Management管理界面添加oVirt Node

> 参考：https://blog.csdn.net/wh211212/article/details/79442142

> youtube:https://www.youtube.com/watch?v=lvIjJPt1smo

安装时建议从ovirt 事件查看具体安装过程

## 添加存储 

- 笔者这里介绍两种方式实现存储，感兴趣参考：https://www.ovirt.org/documentation/admin-guide/chap-Storage/

### 使用nfs添加存储域

- oVirt Management 服务器上配饰nfs服务，或者使用单独的nfs服务器（笔者建议，由于服务器资源有限，笔者复用oVirt Management机器安装nfs服务）

```
# yum install nfs-utils

# systemctl daemon-reload
# systemctl enable rpcbind.service
# systemctl enable nfs-server.service

# 创建数据目录,镜像目录和导出目录

mkdir -p /exports/{data,iso,export}

# 设置nfs挂载的目录及权限,编辑/etc/exports文件，添加下面内容：

/exports/data      *(rw)
/exports/iso      *(rw)
/exports/export    *(rw)

# 重载nfs服务
systemctl reload nfs-server.service

# 设置vdsm账号具有nfs挂载的目录的读写权限

chown vdsm:kvm /exports/{data,iso,export}
```

### 使用glusterfs 存储

- https://docs.gluster.org/en/latest/Quick-Start-Guide/Quickstart/

###

| Hostname      | Role             | IP            |
| ------------- |:----------------:| -------------:|
| ovirt1        | glusterfs-server    | 192.168.1.131 |
| ovirt2        | glusterfs-server    | 192.168.1.132 |


