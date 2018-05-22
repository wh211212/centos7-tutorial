# CentOS7 安装Elastic Stack 6

- 实验环境：

| Hostname      | Role             | IP            |
| ------------- |:----------------:| -------------:|
| elastic1      | elasticsearch    | 192.168.0.116 |
| elastic2      | elasticsearch    | 192.168.0.117 |
| elastic3      | elasticsearch    | 192.168.0.118 |

## 安装Elasticsearch

- 安装Java

```bash
 yum -y install java-1.8.0-openjdk java-1.8.0-openjdk-devel
 #
[root@localhost ~]# cat > /etc/profile.d/java8.sh <<EOF 
> export JAVA_HOME=$(dirname $(dirname $(readlink $(readlink $(which javac)))))
> export PATH=\$PATH:\$JAVA_HOME/bin
> export CLASSPATH=.:\$JAVA_HOME/jre/lib:\$JAVA_HOME/lib:\$JAVA_HOME/lib/tools.jar
> EOF
[root@localhost ~]# source /etc/profile.d/java8.sh
[root@localhost ~]# alternatives --config java 

There is 1 program that provides 'java'.

  Selection    Command
-----------------------------------------------
*+ 1           java-1.8.0-openjdk.x86_64 (/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.161-0.b14.el7_4.x86_64/jre/bin/java)

Enter to keep the current selection[+], or type selection number: 1
```

- 安装运行Elasticsearch

```bash
[root@localhost ~]# vi /etc/yum.repos.d/elasticsearch.repo
# create new
[elasticsearch-6.x]
name=Elasticsearch repository for 6.x packages
baseurl=https://artifacts.elastic.co/packages/6.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
#
[root@localhost ~]# yum -y install elasticsearch
[root@localhost ~]# systemctl start elasticsearch 
[root@localhost ~]# systemctl enable elasticsearch
#确认启动
[root@localhost ~]# curl http://127.0.0.1:9200 
{
  "name" : "HRs6cxK",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "QEdJdSZ6QBay9lUV3FEH5A",
  "version" : {
    "number" : "6.2.2",
    "build_hash" : "10b1edd",
    "build_date" : "2018-02-16T19:01:30.685723Z",
    "build_snapshot" : false,
    "lucene_version" : "7.2.1",
    "minimum_wire_compatibility_version" : "5.6.0",
    "minimum_index_compatibility_version" : "5.0.0"
  },
  "tagline" : "You Know, for Search"
}
```

