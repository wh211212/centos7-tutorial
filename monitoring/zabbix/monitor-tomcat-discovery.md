# zabbix监控tomcat多实例（自动发现，主动模式）

## 实验背景

> 笔者同一台服务器运行三个java api接口，需要监控tomcat 服务状态，很多监控项的情况下一个个添加很烦，笔者使用自动发现功能，已监控tomcat线程为例。系统CentOS7,zabbix 3.0.x

- 创建发现服务器上面运行tomcat的 tomcat目录名称的脚本

脚本可以自动发现tomcat的目录名称（一般自定义），设置脚本成监控项，zabbix会定期执行这个监控项，自动发现当前服务器上所有tomcat实例，笔者脚本默认放在zabbix配置文件目录下的scripts（笔者zabbix，yum安装，scripts需手动创建）目录下，脚本如下：

```
# cat tomcat_name_discovery.py
#!/usr/bin/env python 
# -*- coding: UTF-8 -*-
import os
import subprocess
import simplejson as json

TOMCAT_HOME="/data/tomcats"

# TOMCAT_NAME 自定义项目运行的tomcat的目录名称

#TOMCAT_NAME="/bin/find 'TOMCAT_HOME' -name 'server.xml' | sort -n | uniq -c | awk -F'/' '{print $4}'"
TOMCAT_NAME="/bin/find /data/tomcats -name 'server.xml' | sort -n | uniq -c | awk -F'/' '{print $4}'"

#t=subprocess.Popen(args,shell=True,stdout=subprocess.PIPE).communicate()[0]
t=subprocess.Popen(TOMCAT_NAME,shell=True,stdout=subprocess.PIPE).communicate()[0]

tomcats=[]

for tomcat in t.split('\n'):
    if len(tomcat) != 0:
        tomcats.append({'{#TOMCAT_NAME}':tomcat})

# 打印出zabbix可识别的json格式
print json.dumps({'data':tomcats},sort_keys=True,indent=4,separators=(',',':'))
```

- 本地执行脚本查看获取到的tomcat实例

```
# 安装pip，并安装simplejson模块，笔者最小化安装的CentOS7默认没有安装所用到的python模块
yum install python-pip -y && pip install simplejson 
pip install --upgrade pip # 顺手更新下pip

# 获取当前服务器tomcat实例
[root@ecs-09 scripts]# python tomcat_name_discovery.py 
{
    "data":[
        {
            "{#TOMCAT_NAME}":"tomcat-7081"
        },
        {
            "{#TOMCAT_NAME}":"tomcat-7082"
        },
        {
            "{#TOMCAT_NAME}":"tomcat-7083"
        }
    ]
}
```

- 创建监控项脚本

> 脚本作用打印出tomcat实例需要监控的监控项，本文以tomcat线程数为例，脚本执行需要两个参数，$1为tomcat实例名，$2为tomcat监控项。所有脚本记得赋权

```
[root@ecs-09 scripts]# cat tomcat_status_monitor.sh 
#!/bin/bash
######################################
# Usage: tomcat project status monitor
#
# Changelog:
# 2018-05-10 shaonbean@qq.com create
######################################
# config zabbix sudo
# echo "zabbix ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/zabbix 

TOMCAT_NAME=$1
status=$2

TOMCAT_PID=`/usr/bin/ps -ef | grep "$TOMCAT_NAME" | grep "[o]rg.apache.catalina.startup.Bootstrap start" | grep -v grep | awk '{print $2}'`

jstack=`which jstack`

case $status in
     thread.num)

     # use jstack --help
     /usr/bin/sudo ${jstack} -l ${TOMCAT_PID} | grep http | grep -v grep | wc -l
     ;;

     *)
     echo "Usage: $0 {TOMCAT_NAME status[thread.num]}"
     exit 1
     ;;
esac


# 监控项可以在case部分添加多个，具体参考jstack --help，jstack pid获取的信息，
# 配置jstack环境变量，
ln -s /usr/java/jdk1.7.0_80/bin/jstack /usr/local/sbin/jstack 
```

## zabbix客户端配置

- 在客户端配置文件中添加自定义的监控项key，示例如下：

```
[root@ecs-09 scripts]# cd /etc/zabbix/zabbix_agentd.d/
[root@ecs-09 zabbix_agentd.d]# cat userparameter_tomcat.conf 
# 变量1的key定义为：tomcat.name.discovery, 是脚本自动发现的tomcat实例名称，获取途径是执行tomcat_name_discovery.py

UserParameter=tomcat.name.discovery, /etc/zabbix/scripts/tomcat_name_discovery.py

# 变量2的key自定义为：tomcat.status.thread_num, [*]表示需要变量支持，$1,$2(脚本中$2,即tomcat的监控项自定义，监控项可添加)，获取途径执行：tomcat_status_monitor.sh

UserParameter=tomcat.status.thread_num[*], /etc/zabbix/scripts/tomcat_status_monitor.sh $1 $2
```

- 添加完成后重启zabbix-agent,并在客户端验证（笔者客户端使用的是zabbix主动模式，如果zabbix是被动模式，验证步骤可到zabbix服务端进行）

```
# 验证获取tomcat.name.discovery的key值 
[root@ecs-09 ~]# zabbix_get -s 127.0.0.1 -p 10050 -k tomcat.name.discovery # zabbix_get记得yum安装一下
{
    "data":[
        {
            "{#TOMCAT_NAME}":"tomcat-7081"
        },
        {
            "{#TOMCAT_NAME}":"tomcat-7082"
        },
        {
            "{#TOMCAT_NAME}":"tomcat-7083"
        }
    ]
}

# 验证获取tomcat.status.thread_num 的key值
[root@ecs-09 ~]# zabbix_get -s 127.0.0.1 -p 10050 -k tomcat.status.thread_num[tomcat-7081,thread.num] 
4
[root@ecs-09 ~]# zabbix_get -s 127.0.0.1 -p 10050 -k tomcat.status.thread_num[tomcat-7082,thread.num]
4
```

## zabbix界面添加自动发现模板

模板下载：https://github.com/wh211212/zabbix

- 创建发现规则
![这里写图片描述](https://img-blog.csdn.net/20180510130953474?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3doMjExMjEy/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

- 添加监控项

![这里写图片描述](https://img-blog.csdn.net/20180510131029825?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3doMjExMjEy/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

-设置trigger告警
![这里写图片描述](https://img-blog.csdn.net/2018051013111528?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3doMjExMjEy/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

- 添加图形展示

![这里写图片描述](https://img-blog.csdn.net/20180510131159769?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3doMjExMjEy/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

- 查看
![这里写图片描述](https://img-blog.csdn.net/20180510131301199?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3doMjExMjEy/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

- 模拟tomcat实例停掉，假死，查看告警触发

![这里写图片描述](https://img-blog.csdn.net/20180510131504714?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3doMjExMjEy/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
