# CentOS7 安装pinpoint（开源APM工具pinpoint安装与使用）

- 参考教程：http://naver.github.io/pinpoint/

Pinpoint是用Java编写的大型分布式系统的APM（应用程序性能管理）工具。 受Dapper的启发，Pinpoint提供了一种解决方案，通过在分布式应用程序中跟踪事务来帮助分析系统的整体结构以及它们中的组件之间的相互关系。

Pinpoint-Collector：收集各种性能数据
Pinpoint-Agent：和自己运行的应用关联起来的探针
Pinpoint-Web：将收集到的数据显示成WEB网页形式
HBase Storage：收集到的数据存到HBase中

- https://github.com/naver/pinpoint/releases/  # 直接下载当前最新的war

## 快速安装参考（http://naver.github.io/pinpoint/quickstart.html）

### 安裝JDK

```
yum -y install java-1.* # 包含jdk1.6,1.7,1.8,笔者用到的1.9是下载的rpm包，手动安装的，安装完成配置JAVA_HOME,如下：

jdk9:http://www.oracle.com/technetwork/java/javase/downloads/java-archive-javase9-3934878.html

编辑/etc/profile，最后添加
# java8，笔者默认使用java8作为默认jdk
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk
export JAVA_8_HOME=/usr/lib/jvm/java-1.8.0-openjdk
export PATH=$PATH:$JAVA_HOME/bin
export CLASSPATH=.:$JAVA_HOME/jre/lib:$JAVA_HOME/lib:$JAVA_HOME/lib/tools.jar

# alternatives --config java  配置默认jdk环境

# java 6
export JAVA_6_HOME=/usr/lib/jvm/java-1.6.0-openjdk.x86_64

# java 7
export JAVA_7_HOME=/usr/lib/jvm/java-1.7.0-openjdk

# java 9
export JAVA_9_HOME=/usr/java/jdk-9.0.4

# 上面都需要设置，不然本地build的时候报错
```

- 下载最新代码：

```
git clone https://github.com/naver/pinpoint.git 
./mvnw install -Dmaven.test.skip=true # 自己build会非常慢，而且会有些报错，建议下载war
```
![这里写图片描述](https://img-blog.csdn.net/20180524171344435?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3doMjExMjEy/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)


### 安装并启动HBase

```

# 修改如下：
VERSION=2.0.0 
HBASE_VERSION=hbase-$VERSION
HBASE_FILE=$HBASE_VERSION-bin.tar.gz
HBASE_DL_URL=http://mirror.bit.edu.cn/apache/hbase/$VERSION/$HBASE_FILE
HBASE_ARCHIVE_DL_URL=http://mirror.bit.edu.cn/apache/hbase/$VERSION/$HBASE_FILE

#
Download & Start - Run quickstart/bin/start-hbase.sh # 注意，需要修改hbase的下载地址

Initialize Tables - Run quickstart/bin/init-hbase.sh
```

### 启动pinpoint服务

```
Collector - Run quickstart/bin/start-collector.sh

TestApp - Run quickstart/bin/start-testapp.sh

Web UI - Run quickstart/bin/start-web.sh
```

> 启动脚本完成后，Tomcat日志的最后10行将被拖尾到控制台：

- Collector
![这里写图片描述](https://img-blog.csdn.net/20180524171622758?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3doMjExMjEy/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

- TestApp
![这里写图片描述](https://img-blog.csdn.net/20180524171644382?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3doMjExMjEy/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

- Web UI
![这里写图片描述](https://img-blog.csdn.net/20180524171720800?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3doMjExMjEy/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)


### 检查运行状态

> 一旦HBase和3个守护进程运行，可以访问以下地址来测试自己的Pinpoint实例。

- Web UI - http://localhost:28080
![这里写图片描述](https://img-blog.csdn.net/20180524171844272?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3doMjExMjEy/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
- TestApp - http://localhost:28081
![这里写图片描述](https://img-blog.csdn.net/20180524171859278?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3doMjExMjEy/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
> 可以使用TestApp UI将跟踪数据提供给Pinpoint，并使用Pinpoint Web UI检查它们。 TestApp将自己注册为TESTAPP下的测试代理


### 服务停止

```
Web UI - Run quickstart/bin/stop-web.sh

TestApp - Run quickstart/bin/stop-testapp.sh

Collector - Run quickstart/bin/stop-collector.sh

HBase - Run quickstart/bin/stop-hbase.sh

# 注意执行quickstart目录下名称时，要移动到pinpoint家目录，笔者目录：/opt/pinpoint，笔者克隆pinpoint代码是在opt进行的
```

## 按步骤安装

为了构建Pinpoint，必须满足以下要求：

- https://naver.github.io/pinpoint/installation.html

- 1、安装Hbase

http://hbase.apache.org/

- 2、安装Java环境

- 3、安装Pinpoint Collector

- 4、安装Pinpoint Web

- 5、安装Pinpoint Agent

## 支持的模块

```
JDK 6+
Tomcat 6/7/8, Jetty 8/9, JBoss EAP 6, Resin 4, Websphere 6/7/8, Vertx 3.3/3.4/3.5
Spring, Spring Boot (Embedded Tomcat, Jetty)
Apache HTTP Client 3.x/4.x, JDK HttpConnector, GoogleHttpClient, OkHttpClient, NingAsyncHttpClient
Thrift Client, Thrift Service, DUBBO PROVIDER, DUBBO CONSUMER
ActiveMQ, RabbitMQ
MySQL, Oracle, MSSQL, CUBRID,POSTGRESQL, MARIA
Arcus, Memcached, Redis, CASSANDRA
iBATIS, MyBatis
DBCP, DBCP2, HIKARICP
gson, Jackson, Json Lib
log4j, Logback
```

- 参考链接：http://naver.github.io/pinpoint/quickstart.html
- https://blog.csdn.net/neven7/article/details/51043307

## agent配置（tomcat）

```
# 把打包生成pinpoint-agent-1.8.0-SNAPSHOT.zip，拷贝到对应的agent服务器上，解压到/opt/pinpoint-agent

# 修改tomcat的启动参数，编辑catalina.sh，添加如下：
AGENT_PATH=/opt/pinpoint-agent
AGENT_VERSION=1.8.0
AGENT_ID="agent2018052401" # 自定义
APPLICATION_NAME="message-channel-1-7081" # 自定义
CATALINA_OPTS="$CATALINA_OPTS -javaagent:$AGENT_PATH/pinpoint-bootstrap-$AGENT_VERSION-SNAPSHOT.jar"
CATALINA_OPTS="$CATALINA_OPTS -Dpinpoint.agentId=$AGENT_ID"
CATALINA_OPTS="$CATALINA_OPTS -Dpinpoint.applicationName=$APPLICATION_NAME"
```

- web查看监控的agent状态

## 安装注意事项

- 1、更改hbase下载地址
- 2、更改profiler-optional/pom.xml，去掉模块<module>profiler-optional-jdk6</module>,不然本地build过不去
- 3、web界面显示不了添加的应用，在对应的agent的服务器解析服务器的hosts，添加 127.0.0.1 $hostname