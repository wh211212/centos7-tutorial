# 生产redis集群解决方案

> 实验背景，业务上需要使用redis集群

- 环境CentOS7：

| Hostname      | Role             | IP            |
| ------------- |:----------------:| -------------:|
| redis1        | redis:7000 7003  | 192.168.0.117 |
| redis2        | redis:7001 7004  | 192.168.0.118 |
| redis3        | redis:7002 7005  | 192.168.0.119 |

- 首先在三个redis节点上安装并启动至少6个redis实例

## 编译当前最新版本redis

- 安装依赖，CentOS7最小化安装

```
yum -y install epel-release && yum update -y
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

yum install vim net-tools -y 
```

- 为了方便设置三台redis节点ssh免密，同步hosts如下：

```
# redis1为例：
# cat /etc/hosts
127.0.0.1   localhost localhost.localdomain 

# redis cluster
192.168.0.117 redis1 ecs-117
192.168.0.118 redis2 ecs-118
192.168.0.119 redis3 ecs-119
```

- redis1编译安装redis4.0.9

yum groupinstall "Development Tools" -y && yum install wget -y

wget http://download.redis.io/releases/redis-4.0.9.tar.gz


