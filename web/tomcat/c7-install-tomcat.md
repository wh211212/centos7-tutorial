# 在CentOS 7上安装Apache Tomcat 8

## 安装Java

sudo yum install java-1.8.0-openjdk-devel -y

## 创建tomcat用户

sudo groupadd tomcat
sudo useradd -M -s /bin/nologin -g tomcat -d /data/tomcats tomcat

## 安装Tomcat

- 下载：https://tomcat.apache.org/download-80.cgi

wget http://mirror.bit.edu.cn/apache/tomcat/tomcat-8/v8.5.30/bin/apache-tomcat-8.5.30.tar.gz # 建议使用时下载当前稳定版本

sudo mkdir /data/tomcats
sudo tar xvf apache-tomcat-8*tar.gz -C /data/tomcats/

cd /data/tomcats/ && mv apache-tomcat-8* tomcat8-8081

sudo chgrp -R tomcat /data/tomcats/

## 设置自启

- 笔者在用

[root@ecs-09 ~]# cat /etc/systemd/system/tomcat-7081.service
[Unit]
Description=Tomcat 7.0.81 servlet container
After=syslog.target network.target

[Service]
Type=forking

#User=tomcat
#Group=tomcat

#Environment="JAVA_HOME=/usr/lib/jvm/jre"
#Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom"

Environment="CATALINA_BASE=/data/tomcats/tomcat-7081"
Environment="CATALINA_HOME=/data/tomcats/tomcat-7081"
Environment="CATALINA_PID=/data/tomcats/tomcat-7081/temp/tomcat.pid"
#Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"

ExecStart=/data/tomcats/tomcat-7081/bin/startup.sh
ExecStop=/data/tomcats/tomcat-7081/bin/shutdown.sh

[Install]
WantedBy=multi-user.target

- 笔者tomcat配置

```
[root@ecs-09 conf]# cat server.xml 
<?xml version='1.0' encoding='utf-8'?>
<Server port="7005" shutdown="SHUTDOWN">
  <Listener className="org.apache.catalina.startup.VersionLoggerListener" />
  <Listener className="org.apache.catalina.core.AprLifecycleListener" SSLEngine="on" />
  <Listener className="org.apache.catalina.core.JasperListener" />
  <Listener className="org.apache.catalina.core.JreMemoryLeakPreventionListener" />
  <Listener className="org.apache.catalina.mbeans.GlobalResourcesLifecycleListener" />
  <Listener className="org.apache.catalina.core.ThreadLocalLeakPreventionListener" />

  <GlobalNamingResources>
    <Resource name="UserDatabase" auth="Container"
              type="org.apache.catalina.UserDatabase"
              description="User database that can be updated and saved"
              factory="org.apache.catalina.users.MemoryUserDatabaseFactory"
              pathname="conf/tomcat-users.xml" />
  </GlobalNamingResources>

  <Service name="Catalina">

    <Executor name="tomcatThreadPool" 
              namePrefix="catalina-exec-"
              maxThreads="500" 
              minSpareThreads="10"
              maxSpareThreads="50"
              maxIdleTime="60000"
              />

    <Connector executor="tomcatThreadPool"
               port="7081" 
               protocol="org.apache.coyote.http11.Http11NioProtocol"
               URIEncoding="UTF-8"
               enableLookups="false"
               disableUploadTimeout="true"
               maxPostSize="10485760"
               acceptCount="300"
               acceptorThreadCount='2'
               maxHttpHeaderSize='8192'
               connectionTimeout="20000"
               maxKeepAliveRequests="1000"
               keepAliveTimeout="20000"
               maxConnections='1024'
               SSLEnabled="false"
               tcpNoDelay="true"
               compression="on"
               compressionMinSize="2048"
               compressableMimeType="text/html,text/xml,text/javascript,text/css,text/plain,image/gif,image/jpg,image/png,application/json,application/x-javascript"
               noCompressionUserAgents="gozilla, traviata"
               server="API SERVER"
               redirectPort="8443"
               />

    <Engine name="Catalina" defaultHost="localhost">
      <Realm className="org.apache.catalina.realm.LockOutRealm">
        <Realm className="org.apache.catalina.realm.UserDatabaseRealm"
               resourceName="UserDatabase"/>
      </Realm>

      <Host name="localhost"  appBase="webapps"
            unpackWARs="true" autoDeploy="true">
        <Valve className="org.apache.catalina.valves.AccessLogValve" directory="logs"
               prefix="localhost_access_log." suffix=".txt"
               pattern="%{X-Forwarded-For}i %h %l %u %t &quot;%r&quot; %s %b %T" />
      </Host>
    </Engine>
  </Service>
</Server>
```

- 环境变量设置

