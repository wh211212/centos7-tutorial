# CentOS7 安装RabbitMQ

- RabbitMQ文档：http://www.rabbitmq.com/documentation.html
- AMQP介绍：http://www.rabbitmq.com/protocol.html

安装RabbitMQ，它是实现AMQP（高级消息队列协议）的消息代理软件

- 下载安装：https://www.rabbitmq.com/download.html

## 添加rabbitmq源

https://github.com/rabbitmq/rabbitmq-server/releases/download/v3.7.4/rabbitmq-server-3.7.4-1.el7.noarch.rpm # 下载到服务器上

yum install rabbitmq-server-3.7.4-1.el7.noarch.rpm

# rabbitmq hosts config
192.168.0.62 rabbitmq1
192.168.0.63 rabbitmq2
192.168.0.64 rabbitmq3

- 启动rabbitmq-server

[root@rabbitmq1 ~]# systemctl start rabbitmq-server 
[root@rabbitmq1 ~]# systemctl status rabbitmq-server
● rabbitmq-server.service - RabbitMQ broker
   Loaded: loaded (/usr/lib/systemd/system/rabbitmq-server.service; disabled; vendor preset: disabled)
   Active: active (running) since Wed 2018-05-09 18:27:54 CST; 9s ago
  Process: 2011 ExecStop=/usr/sbin/rabbitmqctl shutdown (code=exited, status=69)
 Main PID: 2149 (beam.smp)
   Status: "Initialized"
   CGroup: /system.slice/rabbitmq-server.service
           ├─2149 /usr/lib64/erlang/erts-9.3/bin/beam.smp -W w -A 64 -P 1048576 -t 5000000 -stbt db -zdbbl 1280000 -K true -- -root /usr/lib64/erlang -progname erl -- -home /var/lib/rabbitmq -- ...
           ├─2290 /usr/lib64/erlang/erts-9.3/bin/epmd -daemon
           ├─2433 erl_child_setup 1024
           ├─2462 inet_gethost 4
           └─2463 inet_gethost 4

May 09 18:27:49 rabbitmq1 rabbitmq-server[2149]: ##  ##
May 09 18:27:49 rabbitmq1 rabbitmq-server[2149]: ##  ##      RabbitMQ 3.7.4. Copyright (C) 2007-2018 Pivotal Software, Inc.
May 09 18:27:49 rabbitmq1 rabbitmq-server[2149]: ##########  Licensed under the MPL.  See http://www.rabbitmq.com/
May 09 18:27:49 rabbitmq1 rabbitmq-server[2149]: ######  ##
May 09 18:27:49 rabbitmq1 rabbitmq-server[2149]: ##########  Logs: /var/log/rabbitmq/rabbit@rabbitmq1.log
May 09 18:27:49 rabbitmq1 rabbitmq-server[2149]: /var/log/rabbitmq/rabbit@rabbitmq1_upgrade.log
May 09 18:27:49 rabbitmq1 rabbitmq-server[2149]: Starting broker...
May 09 18:27:54 rabbitmq1 rabbitmq-server[2149]: systemd unit for activation check: "rabbitmq-server.service"
May 09 18:27:54 rabbitmq1 systemd[1]: Started RabbitMQ broker.
May 09 18:27:54 rabbitmq1 rabbitmq-server[2149]: completed with 0 plugins.

[root@rabbitmq1 ~]# systemctl enable rabbitmq-server # 设置自启
Created symlink from /etc/systemd/system/multi-user.target.wants/rabbitmq-server.service to /usr/lib/systemd/system/rabbitmq-server.service.


## 命令行工具，管理命令行工具

man rabbitmqctl  # 
rabbitmq-plugins
rabbitmqadmin # 需单独安装

rabbitmq-management插件提供了一个基于HTTP的API，用于管理和监控您的RabbitMQ服务器，以及基于浏览器的用户界面和命令行工具rabbitmqadmin。

rabbitmq-plugins enable rabbitmq_management # 启用

[root@rabbitmq1 ~]# rabbitmq-plugins enable rabbitmq_management
The following plugins have been configured:
  rabbitmq_management
  rabbitmq_management_agent
  rabbitmq_web_dispatch
Applying plugin configuration to rabbit@rabbitmq1...
The following plugins have been enabled:
  rabbitmq_management
  rabbitmq_management_agent
  rabbitmq_web_dispatch

started 3 plugins.

[root@rabbitmq1 ~]# systemctl restart rabbitmq-server

- 权限

management policymaker monitoring administrator

http://www.rabbitmq.com/configure.html # 参数详解

关闭所有连接

rabbitmqadmin -f tsv -q list connections name | while read conn ; do rabbitmqadmin -q close connection name="${conn}" ; done
