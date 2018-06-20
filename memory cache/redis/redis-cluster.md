# 生产redis集群解决方案

> 实验背景，业务上需要使用redis集群

- 环境CentOS7：

| Hostname      | Role             | IP            |
| ------------- |:----------------:| -------------:|
| redis1        | redis:7000 7003  | 192.168.0.117 |
| redis2        | redis:7001 7004  | 192.168.0.118 |
| redis3        | redis:7002 7005  | 192.168.0.119 |

- 首先在三个redis节点上安装并启动至少6个redis实例

通过F5实现负载均衡：


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

```
yum groupinstall "Development Tools" -y && yum install tcl wget -y

wget http://download.redis.io/releases/redis-4.0.9.tar.gz
tar zxvf redis-4.0.9.tar.gz -C /data/
ln -s /data/redis-4.0.9/ /data/redis 
cd /data/redis && make

# 创建redis常用命令目录
mkdir /data/redis/bin
cp /data/redis/src/{redis-benchmark,redis-check-aof,redis-check-rdb,redis-cli,redis-sentinel,redis-server,redis-shutdown,redis-trib.rb} /data/redis/bin/
```

- 安装ruby
yum -y install centos-release-scl-rh centos-release-scl  
sed -i -e "s/enabled=1/enabled=0/g" /etc/yum.repos.d/CentOS-SCLo-scl.repo
sed -i -e "s/enabled=1/enabled=0/g" /etc/yum.repos.d/CentOS-SCLo-scl-rh.repo


- 笔者redis cluster目录结构，以redis1为例：

```
[root@redis1 data]# tree -d /data -L 1
/data
├── redis -> /data/redis-4.0.9/
├── redis-4.0.9
└── redis-cluster

# tree -d /data/redis-cluster/
/data/redis-cluster/
├── conf
├── nodes  # 存放redis 集群节点的配置文件
└── scripts # redis 集群维护脚本

# conf存放redis实例配置文件：7000.conf、7003.conf
```

- 脚本具体内容

```
[root@redis1 redis-cluster]# tree scripts/
scripts/
├── bgrewriteaof.sh
├── redis-7000.sh
└── redis-7003.sh

0 directories, 3 files
[root@redis1 redis-cluster]# cat scripts/bgrewriteaof.sh 
#!/bin/bash
#############################################
# Functions: start & stop redis cluster node
# ChangeLog:
# 2018-05-30 shaonbean@qq.com initial
############################################
# set -x #DEBUG

REDIS_BIN_DIR="/data/redis/bin"
REDIS_CLUSTER_DIR="/data/redis-cluster"
REDIS_CLI="$REDIS_BIN_DIR/redis-cli"
REDIS_SERVER="$REDIS_BIN_DIR/redis-server"

PORTLIST=(7000 7003)

bgrewriteaof() {

for REDIS_PORT in ${PORTLIST[@]};
    do
    REDIS_NAME="redis-$REDIS_PORT"
    REDIS_CONFIG="/data/redis-cluster/conf/$REDIS_PORT.conf"
    REDIS_PASS="Aniuredis123"
    echo -n $"Rewriteaof $REDIS_NAME: "
    $REDIS_CLI -p $REDIS_PORT -a $REDIS_PASS BGREWRITEAOF
    retval=$?
    [ $retval -eq 0 ] && echo " $REDIS_NAME bgrewriteaof succeed!"  
    done
}

bgrewriteaof  

# 定时进行aof重写

[root@redis1 redis-cluster]# cat scripts/redis-7000.sh # redis实例启动脚本
#!/bin/bash
#############################################
# Functions: start & stop redis cluster node
# ChangeLog:
# 2018-05-30 shaonbean@qq.com initial
############################################
# set -x #DEBUG

REDIS_BIN_DIR="/data/redis/bin"
REDIS_CLUSTER_DIR="/data/redis-cluster"
REDIS_CLI="$REDIS_BIN_DIR/redis-cli"
REDIS_SERVER="$REDIS_BIN_DIR/redis-server"

REDIS_USER="root"
REDIS_PORT=7000
REDIS_NAME="redis-$REDIS_PORT"
REDIS_CONFIG="/data/redis-cluster/conf/$REDIS_PORT.conf"
REDIS_PASS="Aniuredis123"

start() {
    [ -f $REDIS_CONFIG ] || exit 6
    [ -x $REDIS_SERVER ] || exit 5
    echo -n $"Starting $REDIS_NAME: "
    $REDIS_SERVER $REDIS_CONFIG
    retval=$?
    [ $retval -eq 0 ] && echo " $REDIS_NAME start succeed!"
}

stop() {
    echo -n $"Stopping $REDIS_NAME: "
    $REDIS_CLI -p $REDIS_PORT -a $REDIS_PASS shutdown
    retval=$?
    [ $retval -eq 0 ] && echo " $REDIS_NAME stop succeed!"    
}

restart() {
    stop
    start
}

case "$1" in
    start)
        $1
        ;;
    stop)
        $1
        ;;
    restart)
        $1
        ;;
    *)
        echo $"Usage: $0 {start|stop|restart}"
        exit 2
esac
exit $?
```

- 7000.conf

```
[root@redis1 conf]# cat 7000.conf 
bind 0.0.0.0
protected-mode yes
port 7000
tcp-backlog 511
timeout 0
tcp-keepalive 300
daemonize yes
supervised no
pidfile /var/run/redis/redis_7000.pid
loglevel notice
logfile /var/log/redis/redis-7000.log
databases 16
always-show-logo yes
save ""
stop-writes-on-bgsave-error yes
rdbcompression yes
rdbchecksum yes
dbfilename dump_7000.rdb
dir /var/lib/redis
slave-serve-stale-data yes
slave-read-only yes
repl-diskless-sync no
repl-diskless-sync-delay 5
repl-disable-tcp-nodelay no
slave-priority 100
masterauth Aniuredis123
requirepass Aniuredis123
rename-command FLUSHALL ""
#rename-command CONFIG ""
maxclients 10000
maxmemory 4gb
maxmemory-policy allkeys-lru
maxmemory-samples 5
lazyfree-lazy-eviction no
lazyfree-lazy-expire no
lazyfree-lazy-server-del no
slave-lazy-flush no
appendonly yes
appendfilename "appendonly_7000.aof"
appendfsync everysec
no-appendfsync-on-rewrite no
auto-aof-rewrite-percentage 100
auto-aof-rewrite-min-size 64mb
aof-load-truncated yes
aof-use-rdb-preamble no
lua-time-limit 5000
# cluster config
cluster-enabled yes
cluster-config-file /data/redis-cluster/nodes/nodes-7000.conf
cluster-node-timeout 5000
cluster-slave-validity-factor 10
cluster-migration-barrier 1
cluster-require-full-coverage yes
cluster-slave-no-failover no
slowlog-log-slower-than 10000
slowlog-max-len 128
latency-monitor-threshold 0
notify-keyspace-events ""
hash-max-ziplist-entries 512
hash-max-ziplist-value 64
list-max-ziplist-size -2
list-compress-depth 0
set-max-intset-entries 512
zset-max-ziplist-entries 128
zset-max-ziplist-value 64
hll-sparse-max-bytes 3000
activerehashing yes
client-output-buffer-limit normal 0 0 0
client-output-buffer-limit slave 256mb 64mb 60
client-output-buffer-limit pubsub 32mb 8mb 60
hz 10
aof-rewrite-incremental-fsync yes
```

## 配置设置

- 安装ruby环境

```
yum --enablerepo=centos-sclo-rh -y install rh-ruby24
scl enable rh-ruby24 bash # 启用ruby环境变量

# 写入到环境变量
vi /etc/profile.d/rh-ruby24.sh
#!/bin/bash
source /opt/rh/rh-ruby24/enable
export X_SCLS="`scl enable rh-ruby24 'echo $X_SCLS'`"
```

- 创建集群安装依赖

```
# gem install redis
Successfully installed redis-4.0.1
Parsing documentation for redis-4.0.1
Done installing documentation for redis after 2 seconds
1 gem installed
```

- 以redis1为例：

```
[root@redis1 ~]# /data/redis/bin/redis-trib.rb create --replicas 1 192.168.0.117:7000 192.168.0.118:7001 192.168.0.119:7002 192.168.0.117:7003 192.168.0.118:7004 192.168.0.119:7005
>>> Creating cluster
>>> Performing hash slots allocation on 6 nodes...
Using 3 masters:
192.168.0.117:7000
192.168.0.118:7001
192.168.0.119:7002
Adding replica 192.168.0.118:7004 to 192.168.0.117:7000
Adding replica 192.168.0.119:7005 to 192.168.0.118:7001
Adding replica 192.168.0.117:7003 to 192.168.0.119:7002
M: 1ea6b06582a23a1c73d06bc1aa32c3f4d8edcb24 192.168.0.117:7000
   slots:0-5460 (5461 slots) master
M: 2da83fad766d22198f064b31524d7e757af63a04 192.168.0.118:7001
   slots:5461-10922 (5462 slots) master
M: 77aa1ba8353e1dc303c1f3f2a553f82777aad5d6 192.168.0.119:7002
   slots:10923-16383 (5461 slots) master
S: 76feb9dfb7963a740e697bc9ecbdf4d18d1cdbb4 192.168.0.117:7003
   replicates 77aa1ba8353e1dc303c1f3f2a553f82777aad5d6
S: 769eebd4bde8bbc58543585021bc34059d50ba23 192.168.0.118:7004
   replicates 1ea6b06582a23a1c73d06bc1aa32c3f4d8edcb24
S: 6f2b369304597814af228b32c9c384581a34b900 192.168.0.119:7005
   replicates 2da83fad766d22198f064b31524d7e757af63a04
Can I set the above configuration? (type 'yes' to accept): yes
>>> Nodes configuration updated
>>> Assign a different config epoch to each node
>>> Sending CLUSTER MEET messages to join the cluster
Waiting for the cluster to join...
>>> Performing Cluster Check (using node 192.168.0.117:7000)
M: 1ea6b06582a23a1c73d06bc1aa32c3f4d8edcb24 192.168.0.117:7000
   slots:0-5460 (5461 slots) master
   1 additional replica(s)
S: 76feb9dfb7963a740e697bc9ecbdf4d18d1cdbb4 192.168.0.117:7003
   slots: (0 slots) slave
   replicates 77aa1ba8353e1dc303c1f3f2a553f82777aad5d6
M: 2da83fad766d22198f064b31524d7e757af63a04 192.168.0.118:7001
   slots:5461-10922 (5462 slots) master
   1 additional replica(s)
M: 77aa1ba8353e1dc303c1f3f2a553f82777aad5d6 192.168.0.119:7002
   slots:10923-16383 (5461 slots) master
   1 additional replica(s)
S: 769eebd4bde8bbc58543585021bc34059d50ba23 192.168.0.118:7004
   slots: (0 slots) slave
   replicates 1ea6b06582a23a1c73d06bc1aa32c3f4d8edcb24
S: 6f2b369304597814af228b32c9c384581a34b900 192.168.0.119:7005
   slots: (0 slots) slave
   replicates 2da83fad766d22198f064b31524d7e757af63a04
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[OK] All 16384 slots covered.
```



## redis集群使用密码设置

- 配置文件写入：

```
masterauth Aniuredis123 
requirepass Aniuredis123
```

- 2、设置密码之后如果需要使用redis-trib.rb的各种命令,报错解决：

```
# 解决办法：
[root@redis1 redis]# find / -name client.rb
/opt/rh/rh-ruby24/root/usr/local/share/gems/gems/redis-4.0.1/lib/redis/client.rb

class Client
    DEFAULTS = {
      :url => lambda { ENV["REDIS_URL"] },
      :scheme => "redis",
      :host => "127.0.0.1",
      :port => 6379,
      :path => nil,
      :timeout => 5.0,
      :password => "passwd123",
      :db => 0,
      :driver => nil,
      :id => nil,
      :tcp_keepalive => 0,
      :reconnect_attempts => 1,
      :inherit_socket => false
    }

```

> 注意：client.rb路径可以通过find命令查找：find / -name 'client.rb'

## 笔者redis 集群安装总结

```
# redis集群说明

- redis1是Redis集群的一个节点A，上面运行两个redis实例，7000 7003
- redis2是Redis集群的一个节点B，上面运行两个redis实例，7001 7004
- redis3是Redis集群的一个节点C，上面运行两个redis实例，7002 7005


- 假设集群包含A、B、C、A1、B1、C1六个节点

A、B、C为主节点对应Redis实例：7000 7001 7002
A1、B1、C1为从节点对应redis实例：7003 7004 7005

# 建议交叉设置主从节点，对应关系为
A > B1
B > C1
C > A1

# 创建集群
cd /data/redis/bin
./redis-trib.rb create --replicas 1 192.168.0.117:7000 192.168.0.118:7001 192.168.0.119:7002 192.168.0.117:7003 192.168.0.118:7004 192.168.0.119:7005

# redis集群性能测试
time /usr/local/redis/bin/redis-benchmark -h redis1 -p 7000 -a Aniuredis123 -c 200 -r 1000000 -n 2000000 -t get,set,lpush,lpop -P 16 -q
time /usr/local/redis/bin/redis-benchmark -h redis2 -p 7001 -a Aniuredis123 -c 200 -r 1000000 -n 2000000 -t get,set,lpush,lpop -P 16 -q
time /usr/local/redis/bin/redis-benchmark -h redis3 -p 7002 -a Aniuredis123 -c 200 -r 1000000 -n 2000000 -t get,set,lpush,lpop -P 16 -q

# redis故障模拟


# 参考redis.service设置redis实例开机自启动
echo never > /sys/kernel/mm/transparent_hugepage/enabled
echo 511 > /proc/sys/net/core/somaxconn
```


