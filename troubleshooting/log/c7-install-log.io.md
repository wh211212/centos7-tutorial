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

> 这是收割机的配置文件，它不过是一个日志转发器，它不断监视日志文件的变化，向服务器发送新日志。

```
# vi  ~/.log.io/harvester.conf
# cat harvester.conf 
exports.config = {
  nodeName: "log.io",
  logStreams: {
    systeminfo: [
      "/var/log/messages",
      "/var/log/secure"
    ],
    logioaccess: [
      "/var/log/nginx/logio.aniu.so.access.log"
    ],
    logiolog: [
      "/root/.log.io/log.io-server.log"
    ]
  },
  server: {
    host: '192.168.0.24',
    port: 28777
  }
}

# 编辑log_server.conf 
[root@ecs-01 .log.io]# cat log_server.conf 
exports.config = {
  host: '192.168.0.24',
  port: 28777
}

# 编辑web_server.conf
[root@nkmapi-1 .log.io]# cat web_server.conf 
exports.config = {
  host: '0.0.0.0',
  port: 28778,

  /* 
  // Enable HTTP Basic Authentication
  auth: {
    user: "admin",
    pass: "1234"
  },
  */

  /* 
  // Enable HTTPS/SSL
  ssl: {
    key: '/path/to/privatekey.pem',
    cert: '/path/to/certificate.pem'
  },
  */

  /*
  // Restrict access to websocket (socket.io)
  // Uses socket.io 'origins' syntax
  restrictSocket: '*:*',
  */

  /*
  // Restrict access to http server (express)
  restrictHTTP: [
    "192.168.29.*", # 笔者只改了这里 其他没改
    "192.168.0.*"
  ]
  */

}

```

- 配置启动脚本

```
# cat /etc/init.d/log.io 
#!/bin/bash

start() {
       echo "Starting log.io process..."
       /usr/bin/nohup /usr/bin/log.io-server >> /root/.log.io/log.io-server.log 2>&1 &
       /usr/bin/nohup /usr/bin/log.io-harvester >> /root/.log.io/log.io-harvester.log 2>&1 &
}

stop() {
      echo "Stopping io-log process..."
      pkill node
}                             

status() {
      echo "Status io-log process..."
      netstat -tlp | grep node
}

case "$1" in
     start)
     start
     ;;
     stop)
     stop
     ;;
     status)
     status
     ;;
     restart)
     echo "Restart log.io process..."
     $0 stop
     $0 start
     ;;
     *)
     echo "Usage: start|stop|restart|status"
     ;;
esac
```

- 启动logio

```
# 正常安装配置完成，启动logio
/etc/init.d/log.io start
```

- 浏览器查看

```

```

## 收集tomcat实时日志

- centos6/7 上java api客户端执行：

```
# 配置epel源
yum install npm nodejs gcc-c++
npm config set strict-ssl false
npm install -g log.io --user "root"
```

- 配置log.io配置

```
# 注意client端只需要修改harvester配置文件即可
# cat harvester.conf  
exports.config = {
  nodeName: "liquidation-master",
  logStreams: {
    tomcat_8082: [
      "/data/tomcats/tomcat-8082/logs/catalina.out"
    ]
  },
  server: {
    host: '192.168.0.24',
    port: 28777
  }
}
```

- 收集日志的服务器，也要安装log.io,正常笔者认为启动harvester即可，但是没成功，笔者还是每个客户端都启动了两个服务









