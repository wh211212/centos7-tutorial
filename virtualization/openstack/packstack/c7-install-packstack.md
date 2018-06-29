# CentOS7上利用packstack快速部署openstack测试环境

## 环境vm centos7 16G 4 vcpu

由Packstack快速构建Openstack All-in-One环境。

- 仅限于CentOS 7 Base和Openstack Queens Repo以及EPEL Repo和Packstack软件包。其他软件包由Packstack自动安装和配置。

```
[root@packstack ~]# yum -y install centos-release-openstack-queens epel-release 
[root@packstack ~]# yum -y install openstack-packstack python-pip
```

- 笔者环境：虚拟机CentOS7、16G 2vcpu 100G，两张网卡（必须）、关闭selinux，设置hostname为：packstack.aniu.so

- 执行Packstack

```
[root@packstack ~]# packstack --allinone
Welcome to the Packstack setup utility

The installation log file is available at: /var/tmp/packstack/20180629-142916-I6A192/openstack-setup.log

Installing:
Clean Up                                             [ DONE ]
Discovering ip protocol version                      [ DONE ]
Setting up ssh keys                                  [ DONE ]
Preparing servers                                    [ DONE ]
Pre installing Puppet and discovering hosts' details [ DONE ]
Preparing pre-install entries                        [ DONE ]
Setting up CACERT                                    [ DONE ]
Preparing AMQP entries                               [ DONE ]
Preparing MariaDB entries                            [ DONE ]
Fixing Keystone LDAP config parameters to be undef if empty[ DONE ]
Preparing Keystone entries                           [ DONE ]
Preparing Glance entries                             [ DONE ]
Checking if the Cinder server has a cinder-volumes vg[ DONE ]
Preparing Cinder entries                             [ DONE ]
Preparing Nova API entries                           [ DONE ]
Creating ssh keys for Nova migration                 [ DONE ]
Gathering ssh host keys for Nova migration           [ DONE ]
Preparing Nova Compute entries                       [ DONE ]
Preparing Nova Scheduler entries                     [ DONE ]
Preparing Nova VNC Proxy entries                     [ DONE ]
Preparing OpenStack Network-related Nova entries     [ DONE ]
Preparing Nova Common entries                        [ DONE ]
Preparing Neutron LBaaS Agent entries                [ DONE ]
Preparing Neutron API entries                        [ DONE ]
Preparing Neutron L3 entries                         [ DONE ]
Preparing Neutron L2 Agent entries                   [ DONE ]
Preparing Neutron DHCP Agent entries                 [ DONE ]
Preparing Neutron Metering Agent entries             [ DONE ]
Checking if NetworkManager is enabled and running    [ DONE ]
Preparing OpenStack Client entries                   [ DONE ]
Preparing Horizon entries                            [ DONE ]
Preparing Swift builder entries                      [ DONE ]
Preparing Swift proxy entries                        [ DONE ]
Preparing Swift storage entries                      [ DONE ]
Preparing Gnocchi entries                            [ DONE ]
Preparing Redis entries                              [ DONE ]
Preparing Ceilometer entries                         [ DONE ]
Preparing Aodh entries                               [ DONE ]
Preparing Puppet manifests                           [ DONE ]
Copying Puppet modules and manifests                 [ DONE ]
Applying 192.168.0.2_controller.pp
Testing if puppet apply is finished: 192.168.0.2_controller.pp  [ | ]
192.168.0.2_controller.pp:                           [ DONE ]        
Applying 192.168.0.2_network.pp
  2.168.0.2_network.pp:                              [ DONE ]     
▽pplying 192.168.0.2_compute.pp
192.168.0.2_compute.pp:                              [ DONE ]     
Applying Puppet manifests                            [ DONE ]
Finalizing                                           [ DONE ]

 **** Installation completed successfully ******

Additional information:
 * A new answerfile was created in: /root/packstack-answers-20180629-142918.txt
 * Time synchronization installation was skipped. Please note that unsynchronized time on server instances might be problem for some OpenStack components.
 * Warning: NetworkManager is active on 192.168.0.2. OpenStack networking currently does not work on systems that have the Network Manager service enabled.
 * File /root/keystonerc_admin has been created on OpenStack client host 192.168.0.2. To use the command line tools you need to source the file.
 * To access the OpenStack Dashboard browse to http://192.168.0.2/dashboard .
Please, find your login credentials stored in the keystonerc_admin in your home directory.
 * The installation log file is available at: /var/tmp/packstack/20180629-142916-I6A192/openstack-setup.log
 * The generated manifests are available at: /var/tmp/packstack/20180629-142916-I6A192/manifests
```

 - 自动安装过程大概会持续半个小时左右，根据物理环境不通而已

 - Keystone，Glance，Nova，Neutron，Swift，Cinder Ceilometer（+ Aodh，Gnocchi）通过packstack进行安装和配置，如下所示。如果想安装Trove或Sagara等其他组件，可以使用packstack命令指定选项

 ```
 [root@packstack ~]# source keystonerc_admin # 要执行
[root@packstack ~(keystone_admin)]# openstack user list
+----------------------------------+------------+
| ID                               | Name       |
+----------------------------------+------------+
| 0aa9709a9e3f4ed7afe1cb5c00b9ac42 | demo       |
| 2d897c0bfe2b47be8537c0c7ff6d80bf | cinder     |
| 5abb87731ded4a81801d79bbebe84fe1 | nova       |
| 7864791f709f418a87551ea4d94008ba | neutron    |
| 7bbb776c567148e1be6040abf4d800fd | placement  |
| 7d3bb584891549e58df6aa6a1373e20d | ceilometer |
| 9108042019d040f89a40eb598b074dc1 | swift      |
| b3d713d78d8e4706ab00835e0fd59161 | admin      |
| c01ebc8d6d0940099f39351b1b837e6b | gnocchi    |
| c5fed9d6fdb240ff81d8012fea7d05bd | glance     |
| d344ac67538145968462a3451c486e81 | aodh       |
+----------------------------------+------------+
[root@packstack ~(keystone_admin)]# openstack project list 
+----------------------------------+----------+
| ID                               | Name     |
+----------------------------------+----------+
| 26f5bc5db98540f48b81117fb5821cc9 | demo     |
| 64a8955e90db46eeba1b28efe62ed8d5 | admin    |
| a2836335b5844291aad362f0c59699b6 | services |
+----------------------------------+----------+
[root@packstack ~(keystone_admin)]# openstack service list
+----------------------------------+------------+--------------+
| ID                               | Name       | Type         |
+----------------------------------+------------+--------------+
| 43b2190a68ce4ed5b718142fcbe6a5e4 | neutron    | network      |
| 5486e623468a4624a88c95cbbd9c6d0f | keystone   | identity     |
| 683fa521de7a450fad904b6b33641da3 | cinderv2   | volumev2     |
| 6e6a79c7644c4a14994806c0e394323a | cinder     | volume       |
| 7b56035d1c254258b74bb341a94aadf8 | aodh       | alarming     |
| 8864d7f3c19f49f29348e7846a007d5a | glance     | image        |
| 8baef4757ebd4ebfb64c4be293895fcc | ceilometer | metering     |
| 8e1750cc55e24a9b8d71e136cbe46dec | nova       | compute      |
| 94371a0e281942448c3958bdb53b0b84 | placement  | placement    |
| 9d75fd7061b0407582b59889e1f6fc93 | cinderv3   | volumev3     |
| bf49c3e79f564a0b88bee23fd7b43639 | swift      | object-store |
| da61ff8ee9b34eb191b02a7347d0ab55 | gnocchi    | metric       |
+----------------------------------+------------+--------------+
[root@packstack ~(keystone_admin)]# openstack catalog list 
+------------+--------------+------------------------------------------------------------------------------+
| Name       | Type         | Endpoints                                                                    |
+------------+--------------+------------------------------------------------------------------------------+
| neutron    | network      | RegionOne                                                                    |
|            |              |   admin: http://192.168.0.2:9696                                             |
|            |              | RegionOne                                                                    |
|            |              |   internal: http://192.168.0.2:9696                                          |
|            |              | RegionOne                                                                    |
|            |              |   public: http://192.168.0.2:9696                                            |
|            |              |                                                                              |
| keystone   | identity     | RegionOne                                                                    |
|            |              |   internal: http://192.168.0.2:5000/v3                                       |
|            |              | RegionOne                                                                    |
|            |              |   public: http://192.168.0.2:5000/v3                                         |
|            |              | RegionOne                                                                    |
|            |              |   admin: http://192.168.0.2:35357/v3                                         |
|            |              |                                                                              |
| cinderv2   | volumev2     | RegionOne                                                                    |
|            |              |   internal: http://192.168.0.2:8776/v2/64a8955e90db46eeba1b28efe62ed8d5      |
|            |              | RegionOne                                                                    |
|            |              |   admin: http://192.168.0.2:8776/v2/64a8955e90db46eeba1b28efe62ed8d5         |
|            |              | RegionOne                                                                    |
|            |              |   public: http://192.168.0.2:8776/v2/64a8955e90db46eeba1b28efe62ed8d5        |
|            |              |                                                                              |
| cinder     | volume       | RegionOne                                                                    |
|            |              |   internal: http://192.168.0.2:8776/v1/64a8955e90db46eeba1b28efe62ed8d5      |
|            |              | RegionOne                                                                    |
|            |              |   public: http://192.168.0.2:8776/v1/64a8955e90db46eeba1b28efe62ed8d5        |
|            |              | RegionOne                                                                    |
|            |              |   admin: http://192.168.0.2:8776/v1/64a8955e90db46eeba1b28efe62ed8d5         |
|            |              |                                                                              |
| aodh       | alarming     | RegionOne                                                                    |
|            |              |   public: http://192.168.0.2:8042                                            |
|            |              | RegionOne                                                                    |
|            |              |   internal: http://192.168.0.2:8042                                          |
|            |              | RegionOne                                                                    |
|            |              |   admin: http://192.168.0.2:8042                                             |
|            |              |                                                                              |
| glance     | image        | RegionOne                                                                    |
|            |              |   admin: http://192.168.0.2:9292                                             |
|            |              | RegionOne                                                                    |
|            |              |   internal: http://192.168.0.2:9292                                          |
|            |              | RegionOne                                                                    |
|            |              |   public: http://192.168.0.2:9292                                            |
|            |              |                                                                              |
| ceilometer | metering     | RegionOne                                                                    |
|            |              |   internal: http://192.168.0.2:8777                                          |
|            |              | RegionOne                                                                    |
|            |              |   admin: http://192.168.0.2:8777                                             |
|            |              | RegionOne                                                                    |
|            |              |   public: http://192.168.0.2:8777                                            |
|            |              |                                                                              |
| nova       | compute      | RegionOne                                                                    |
|            |              |   public: http://192.168.0.2:8774/v2.1/64a8955e90db46eeba1b28efe62ed8d5      |
|            |              | RegionOne                                                                    |
|            |              |   admin: http://192.168.0.2:8774/v2.1/64a8955e90db46eeba1b28efe62ed8d5       |
|            |              | RegionOne                                                                    |
|            |              |   internal: http://192.168.0.2:8774/v2.1/64a8955e90db46eeba1b28efe62ed8d5    |
|            |              |                                                                              |
| placement  | placement    | RegionOne                                                                    |
|            |              |   admin: http://192.168.0.2:8778/placement                                   |
|            |              | RegionOne                                                                    |
|            |              |   public: http://192.168.0.2:8778/placement                                  |
|            |              | RegionOne                                                                    |
|            |              |   internal: http://192.168.0.2:8778/placement                                |
|            |              |                                                                              |
| cinderv3   | volumev3     | RegionOne                                                                    |
|            |              |   admin: http://192.168.0.2:8776/v3/64a8955e90db46eeba1b28efe62ed8d5         |
|            |              | RegionOne                                                                    |
|            |              |   public: http://192.168.0.2:8776/v3/64a8955e90db46eeba1b28efe62ed8d5        |
|            |              | RegionOne                                                                    |
|            |              |   internal: http://192.168.0.2:8776/v3/64a8955e90db46eeba1b28efe62ed8d5      |
|            |              |                                                                              |
| swift      | object-store | RegionOne                                                                    |
|            |              |   public: http://192.168.0.2:8080/v1/AUTH_64a8955e90db46eeba1b28efe62ed8d5   |
|            |              | RegionOne                                                                    |
|            |              |   admin: http://192.168.0.2:8080/v1/AUTH_64a8955e90db46eeba1b28efe62ed8d5    |
|            |              | RegionOne                                                                    |
|            |              |   internal: http://192.168.0.2:8080/v1/AUTH_64a8955e90db46eeba1b28efe62ed8d5 |
|            |              |                                                                              |
| gnocchi    | metric       | RegionOne                                                                    |
|            |              |   internal: http://192.168.0.2:8041                                          |
|            |              | RegionOne                                                                    |
|            |              |   admin: http://192.168.0.2:8041                                             |
|            |              | RegionOne                                                                    |
|            |              |   public: http://192.168.0.2:8041                                            |
|            |              |                                                                              |
+------------+--------------+------------------------------------------------------------------------------+
 ```

## 浏览器访问openstack UI：http://packstack.aniu.so

- 初始密码从keystonerc_admin文件中查看：笔者的 admin 1b02bd75c4084398