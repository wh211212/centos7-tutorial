# CentOS7 安装log.io服务

> 官网： http://logio.org/

- 添加epel源

```
yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
``

## 安裝Log.io:

```
# 安装依赖

```
# 安装开发工具包或者 yum install gcc-c++
yum install npm nodejs

# npm是jabascript的软件包管理器，允许管理应用程序的依赖关系，也允许用户从npm注册表安装node.js应用程序。输入一个用户名来安装，筆者使用了“yunwei”用户
npm install -g log.io --user "root"
```

## 配置 Log.io

> Log.io的Installed目录是〜/ .log.io，它是用户主目录下的一个隐藏目录，在prevoius步骤中用于安装，它有三个配置文件来控制它的工作性质。

- harvester.conf

> 这是收割机的配置文件，它不过是一个日志转发器，它不断监视日志文件的变化，向服务器发送新日志。我们可以配置节点名，什么是所有日志以及发送日志。编辑收割机文件，提及节点名称。 默认情况下，Harvester设置为仅监视apache日志，我们将修改它以监视消息日志。 由于服务器主机定义为0.0.0.0，收集器会将日志广播到所有正在监听的Log.io服务器，因此建议将127.0.0.1（如果同一台计算机用作Log.io服务器）或远程服务器的IP地址 Log.io服务器。

# vi  ~/.log.io/harvester.conf

[root@ecs-01 .log.io]# cat harvester.conf 
exports.config = {
  nodeName: "log.io",
  logStreams: {
    systeminfo: [
      "/var/log/messages",
      "/var/log/secure"
    ],
    logioerror: [
      "/var/log/nginx/logio.aniu.so.error.log"
    ]
  },
  server: {
    host: '192.168.0.24',
    port: 28777
  }
}

- 编辑log_server.conf 
[root@ecs-01 .log.io]# cat log_server.conf 
exports.config = {
  host: '192.168.0.24',
  port: 28777
}



# CS模式

- api客户端执行：

```
yum install npm nodejs gcc-c++
npm config set strict-ssl false
npm install -g log.io --user "root"
```





