# redis 主从复制方案

> 实验背景，提高redis可用性

- 环境CentOS7：

| Hostname      | Role,Port        | IP            |
| ------------- |:----------------:| -------------:|
| redis1        | master:6379      | 192.168.0.117 |
| redis2        | slave:6379       | 192.168.0.118 |
| redis3        | slave:6379       | 192.168.0.119 |

- 对系统进行初始化设置，笔者使用yum安装的redis进行实验

## redis安装、启动设置

```
# ansible 配置
[redis]
192.168.0.117
192.168.0.118
192.168.0.119

# 使用ansible安装设置
ansible redis -a "yum install redis -y"

echo 511 > /proc/sys/net/core/somaxconn
sysctl vm.overcommit_memory=1

建议写到/etc/sysctl.conf

echo "vm.overcommit_memory=1" >> /etc/sysctl.conf

echo 2 > /proc/sys/vm/overcommit_memory
echo 80 > /proc/sys/vm/overcommit_ratio

# 开机启动配置
# redis
echo 511 > /proc/sys/net/core/somaxconn
echo never > /sys/kernel/mm/transparent_hugepage/enabled

- 启动
ansible redis -a "systemctl restart redis"
```

- 查看redis运行状态

ansible redis -a "systemctl status redis"

## 修改Redis配置文件

- redis1

```
bind 0.0.0.0
protected-mode no
port 6379
tcp-backlog 511
timeout 60
tcp-keepalive 300
daemonize yes
supervised no
pidfile /var/run/redis/redis-6379.pid
loglevel verbose
logfile /var/log/redis/redis-6379.log
databases 16
save ""
stop-writes-on-bgsave-error yes
rdbcompression yes
rdbchecksum yes
dbfilename dump-6379.rdb
dir /var/lib/redis
slave-serve-stale-data yes
slave-read-only yes
repl-diskless-sync no
repl-diskless-sync-delay 5
repl-disable-tcp-nodelay no
slave-priority 100
requirepass Aniuredis123
rename-command FLUSHALL ""
maxclients 10000
#maxmemory 4gb
maxmemory-policy volatile-lru
maxmemory-samples 5
appendonly no
appendfilename "appendonly-6379.aof"
appendfsync everysec
no-appendfsync-on-rewrite no
auto-aof-rewrite-percentage 100
auto-aof-rewrite-min-size 64mb
aof-load-truncated yes
lua-time-limit 5000
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

- redis2

```
# 在redis1配置文件基础上添加下面两行：
slaveof 192.168.0.117 6379
masterauth password
slave-read-only yes
```


- redis3

```
# 在redis1配置文件基础上添加下面两行：
slaveof 192.168.0.117 6379
masterauth password
slave-read-only yes
```

- 重启所有redis查看复制状态

```
                _._                                                  
           _.-``__ ''-._                                             
      _.-``    `.  `_.  ''-._           Redis 3.2.10 (00000000/0) 64 bit
  .-`` .-```.  ```\/    _.,_ ''-._                                   
 (    '      ,       .-`  | `,    )     Running in standalone mode
 |`-._`-...-` __...-.``-._|'` _.-'|     Port: 6379
 |    `-._   `._    /     _.-'    |     PID: 20940
  `-._    `-._  `-./  _.-'    _.-'                                   
 |`-._`-._    `-.__.-'    _.-'_.-'|                                  
 |    `-._`-._        _.-'_.-'    |           http://redis.io        
  `-._    `-._`-.__.-'_.-'    _.-'                                   
 |`-._`-._    `-.__.-'    _.-'_.-'|                                  
 |    `-._`-._        _.-'_.-'    |                                  
  `-._    `-._`-.__.-'_.-'    _.-'                                   
      `-._    `-.__.-'    _.-'                                       
          `-._        _.-'                                           
              `-.__.-'                                               

20940:M 29 May 15:23:54.513 # Server started, Redis version 3.2.10
20940:M 29 May 15:23:54.514 * The server is now ready to accept connections on port 6379
20940:M 29 May 15:23:54.514 - 0 clients connected (0 slaves), 754728 bytes in use
20940:M 29 May 15:23:54.567 - Accepted 192.168.0.118:33412
20940:M 29 May 15:23:54.571 * Slave 192.168.0.118:6379 asks for synchronization
20940:M 29 May 15:23:54.571 * Full resync requested by slave 192.168.0.118:6379
20940:M 29 May 15:23:54.571 * Starting BGSAVE for SYNC with target: disk
20940:M 29 May 15:23:54.572 * Background saving started by pid 20947
20947:C 29 May 15:23:54.614 * DB saved on disk
20947:C 29 May 15:23:54.615 * RDB: 0 MB of memory used by copy-on-write
20940:M 29 May 15:23:54.715 * Background saving terminated with success
20940:M 29 May 15:23:54.715 * Synchronization with slave 192.168.0.118:6379 succeeded
20940:M 29 May 15:23:55.508 - Accepted 192.168.0.119:42300
20940:M 29 May 15:23:55.518 * Slave 192.168.0.119:6379 asks for synchronization
20940:M 29 May 15:23:55.518 * Full resync requested by slave 192.168.0.119:6379
20940:M 29 May 15:23:55.518 * Starting BGSAVE for SYNC with target: disk
20940:M 29 May 15:23:55.519 * Background saving started by pid 20952
20952:C 29 May 15:23:55.643 * DB saved on disk
20952:C 29 May 15:23:55.644 * RDB: 0 MB of memory used by copy-on-write
20940:M 29 May 15:23:55.718 * Background saving terminated with success
20940:M 29 May 15:23:55.718 * Synchronization with slave 192.168.0.119:6379 succeeded
20940:M 29 May 15:23:59.528 - 0 clients connected (2 slaves), 1882000 bytes in use
20940:M 29 May 15:24:04.541 - 0 clients connected (2 slaves), 1880976 bytes in use
20940:M 29 May 15:24:09.554 - 0 clients connected (2 slaves), 1844120 bytes in use

# redis2
[root@redis2 redis]# tailf redis-6379.log 
20931:S 29 May 15:23:54.293 * MASTER <-> SLAVE sync started
20931:S 29 May 15:23:54.293 * Non blocking connect for SYNC fired the event.
20931:S 29 May 15:23:54.294 * Master replied to PING, replication can continue...
20931:S 29 May 15:23:54.298 * Partial resynchronization not possible (no cached master)
20931:S 29 May 15:23:54.299 * Full resync from master: f6211c70354e4f7b28ee265728f733a8b4a3684f:1
20931:S 29 May 15:23:54.442 * MASTER <-> SLAVE sync: receiving 77 bytes from master
20931:S 29 May 15:23:54.442 * MASTER <-> SLAVE sync: Flushing old data
20931:S 29 May 15:23:54.442 * MASTER <-> SLAVE sync: Loading DB in memory
20931:S 29 May 15:23:54.443 * MASTER <-> SLAVE sync: Finished with success
20931:S 29 May 15:23:59.311 - 1 clients connected (0 slaves), 775616 bytes in use
```

> 建议redis2进行rdb备份，redis3进行aof备份，提高数据的安全性

