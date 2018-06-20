# redis单实例数据迁移到redis cluster集群

## 实验环境

- redis 4.0.9, centos7 16G 2CPU 30Gdisk

单实例redis端口 30000 
redis集群：30001-30006 (使用create-cluster创建)

> 参考：https://www.18188.org/articles/2016/04/23/1461374145366.html

```
方案步骤

1）获取原单实例节点D的持久化AOF文件

2）新准备三个节点A，B，C，建立集群，目前集群为空

3）把节点B，C上的slots，全部分配给A

4）把1）中获取的AOF文件SCP到A上

5）重启A节点，把数据全部加载到内存

6）把A节点上的slots再均匀分配给B，C

7）新准备A1，B1，C1，分别作为A，B，C的slave加入到集群

8）验证数据的完整性和集群状态

笔者是在单台vm上做的测试，故ABCD节点是一样以端口来区分彼此
```

## 测试redis生成模拟数据

- redis集群性能测试

```
[root@ecs-116 redis]# time /data/redis/bin/redis-benchmark -h 192.168.0.116 -p 30000 -a Aniuredis123 -c 200 -r 1000000 -n 2000000 -t get,set,lpush,lpop -P 16 -q
SET: 221459.42 requests per second
GET: 267058.34 requests per second
LPUSH: 234274.34 requests per second
LPOP: 215447.59 requests per second

real    0m35.066s
user    0m4.945s
sys     0m15.653s
```

## 迁移实战

1、查看redis单实例数据量：

```
[root@ecs-116 ~]# /data/redis/bin/redis-cli -h 192.168.0.116 -p 30000 -a Aniuredis123 dbsize
(integer) 865405

# 这里的keys总量是刚笔者测试性能时生成的数据
```

2、持久化单实例redis数据

```
[root@ecs-116 ~]# /data/redis/bin/redis-cli -h 192.168.0.116 -p 30000 -a Aniuredis123 BGREWRITEAOF
Background append only file rewriting started

# 到aof文件目录查看，触发生成的持久化文件：
[root@ecs-116 redis]# ll -tr /var/lib/redis
total 38032
-rw-r--r-- 1 redis redis        0 Jun 15 10:37 appendonly-6379.aof
-rw-r--r-- 1 root  root  38943248 Jun 15 10:52 appendonly-30000.aof # 笔者生成的持久化文件
```

## 操作集群

- 新建redis集群

> 注意：使用gem install redis指定版本：gem install redis -v 3.3.3，不然后面迁移slots时候会报错，笔者ruby2.4的环境，默认安装的redis是4.0.1版本

```
[root@ecs-116 ~ ]# cd /data/redis/utils/create-cluster # 需要进入到这个目录
[root@ecs-116 create-cluster]# ./create-cluster create
>>> Creating cluster
>>> Performing hash slots allocation on 6 nodes...
Using 3 masters:
192.168.0.116:30001
192.168.0.116:30002
192.168.0.116:30003
Adding replica 192.168.0.116:30005 to 192.168.0.116:30001
Adding replica 192.168.0.116:30006 to 192.168.0.116:30002
Adding replica 192.168.0.116:30004 to 192.168.0.116:30003
>>> Trying to optimize slaves allocation for anti-affinity
[WARNING] Some slaves are in the same host as their master
M: 651e1184fb19f7ff276650b8ec4b644017c7b038 192.168.0.116:30001
   slots:0-5460 (5461 slots) master
M: 3784ddf7e205b4816b50766970517b75347b6c9f 192.168.0.116:30002
   slots:5461-10922 (5462 slots) master
M: 4c8bad3a64581ad029728f7927a1c881efb67b9b 192.168.0.116:30003
   slots:10923-16383 (5461 slots) master
S: 4045976f5ca0094881b666649ede3f8f89addcd9 192.168.0.116:30004
   replicates 3784ddf7e205b4816b50766970517b75347b6c9f
S: c032e7e9352b07aca0d01bc9952529062091fcc8 192.168.0.116:30005
   replicates 4c8bad3a64581ad029728f7927a1c881efb67b9b
S: f4644679c147e45af65f14b8446a3638ce03726e 192.168.0.116:30006
   replicates 651e1184fb19f7ff276650b8ec4b644017c7b038
Can I set the above configuration? (type 'yes' to accept): yes
>>> Nodes configuration updated
>>> Assign a different config epoch to each node
>>> Sending CLUSTER MEET messages to join the cluster
Waiting for the cluster to join..
>>> Performing Cluster Check (using node 192.168.0.116:30001)
M: 651e1184fb19f7ff276650b8ec4b644017c7b038 192.168.0.116:30001
   slots:0-5460 (5461 slots) master
   1 additional replica(s)
S: f4644679c147e45af65f14b8446a3638ce03726e 192.168.0.116:30006
   slots: (0 slots) slave
   replicates 651e1184fb19f7ff276650b8ec4b644017c7b038
S: c032e7e9352b07aca0d01bc9952529062091fcc8 192.168.0.116:30005
   slots: (0 slots) slave
   replicates 4c8bad3a64581ad029728f7927a1c881efb67b9b
M: 3784ddf7e205b4816b50766970517b75347b6c9f 192.168.0.116:30002
   slots:5461-10922 (5462 slots) master
   1 additional replica(s)
S: 4045976f5ca0094881b666649ede3f8f89addcd9 192.168.0.116:30004
   slots: (0 slots) slave
   replicates 3784ddf7e205b4816b50766970517b75347b6c9f
M: 4c8bad3a64581ad029728f7927a1c881efb67b9b 192.168.0.116:30003
   slots:10923-16383 (5461 slots) master
   1 additional replica(s)
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[OK] All 16384 slots covered.
```

- 查看create-cluster创建的redis集群的slots分布情况：

```
[root@ecs-116 create-cluster]# /data/redis/bin/redis-cli -h 192.168.0.116 -a Aniuredis123 -c -p 30001 cluster nodes
f4644679c147e45af65f14b8446a3638ce03726e 192.168.0.116:30006@40006 slave 651e1184fb19f7ff276650b8ec4b644017c7b038 0 1529032000916 6 connected
651e1184fb19f7ff276650b8ec4b644017c7b038 192.168.0.116:30001@40001 myself,master - 0 1529032001000 1 connected 0-5460
c032e7e9352b07aca0d01bc9952529062091fcc8 192.168.0.116:30005@40005 slave 4c8bad3a64581ad029728f7927a1c881efb67b9b 0 1529032001116 5 connected
3784ddf7e205b4816b50766970517b75347b6c9f 192.168.0.116:30002@40002 master - 0 1529032001116 2 connected 5461-10922
4045976f5ca0094881b666649ede3f8f89addcd9 192.168.0.116:30004@40004 slave 3784ddf7e205b4816b50766970517b75347b6c9f 0 1529032000916 4 connected
4c8bad3a64581ad029728f7927a1c881efb67b9b 192.168.0.116:30003@40003 master - 0 1529032001116 3 connected 10923-16383
```

- 把B、C节点上slots移动到A节点，即：30002,30003上的slots分片移动到30001

```
# check redis 30001 status
[root@ecs-116 src]# /data/redis/bin/redis-trib.rb check 192.168.0.116:30001
>>> Performing Cluster Check (using node 192.168.0.116:30001)
M: d14821e7d45a1f24a591e9dbec14fb08a1b171a7 192.168.0.116:30001
   slots:0-5460 (5461 slots) master
   1 additional replica(s)
S: 8d8df1e4baa1767249f4ad797e028459eb8b30eb 192.168.0.116:30004
   slots: (0 slots) slave
   replicates 8216ed6a058892a436ce59c00aa244e338f313e3
S: dc1e474745cc241e20bc33504945a095b73d8aba 192.168.0.116:30005
   slots: (0 slots) slave
   replicates d14821e7d45a1f24a591e9dbec14fb08a1b171a7
S: 1d2dbba1465f5f42fb5081b6271dcbf6dc856886 192.168.0.116:30006
   slots: (0 slots) slave
   replicates b2ae5b28e9220a27cab13e4061a37c1d283b74ae
M: 8216ed6a058892a436ce59c00aa244e338f313e3 192.168.0.116:30003
   slots:10923-16383 (5461 slots) master
   1 additional replica(s)
M: b2ae5b28e9220a27cab13e4061a37c1d283b74ae 192.168.0.116:30002
   slots:5461-10922 (5462 slots) master
   1 additional replica(s)
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[OK] All 16384 slots covered.
```

- 获取节点A、B、C对应的slots信息

```
runid: 集群中每个节点都有唯一的名字，称之为node ID，一个160位随机数字的16进制表示，在每个节点首次启动时创建。

# A节点（30001） 192.168.0.116:30001 的runid为：d14821e7d45a1f24a591e9dbec14fb08a1b171a7，其中有0-5460 (5461 slots) 
# B节点（30002） 192.168.0.116:30002 的runid为：b2ae5b28e9220a27cab13e4061a37c1d283b74ae，其中有5461-10922 (5462 slots)
# C节点（30003） 192.168.0.116:30003 的runid为：8216ed6a058892a436ce59c00aa244e338f313e3，其中有10923-16383 (5461 slots)
```
- 把B节点（30002）上5462个slots移动A节点上

```
# 移动slots槽
[root@ecs-116 ~]# cd /data/redis/src/
[root@ecs-116 src]# ./redis-trib.rb 
# 笔者使用绝对路径
# slots迁移,from跟B节点ID，to跟A节点ID，从B移动slots到A

[root@ecs-116 src]# time /data/redis/bin/redis-trib.rb reshard --from b2ae5b28e9220a27cab13e4061a37c1d283b74ae --to d14821e7d45a1f24a591e9dbec14fb08a1b171a7 --slots 5462 --yes 192.168.0.116:30001
...
Moving slot 10918 from 192.168.0.116:30002 to 192.168.0.116:30001: 
Moving slot 10919 from 192.168.0.116:30002 to 192.168.0.116:30001: 
Moving slot 10920 from 192.168.0.116:30002 to 192.168.0.116:30001: 
Moving slot 10921 from 192.168.0.116:30002 to 192.168.0.116:30001: 
Moving slot 10922 from 192.168.0.116:30002 to 192.168.0.116:30001: 
# 迁移完成显示如上
```
- 把C节点（30003）上5461个slots移动A节点上

```
# slots迁移,from跟C节点ID，to跟A节点ID，从C移动slots到A
[root@ecs-116 src]# time /data/redis/bin/redis-trib.rb reshard --from 8216ed6a058892a436ce59c00aa244e338f313e3 --to d14821e7d45a1f24a591e9dbec14fb08a1b171a7 --slots 5461 --yes 192.168.0.116:30001
...
Moving slot 16378 from 192.168.0.116:30003 to 192.168.0.116:30001: 
Moving slot 16379 from 192.168.0.116:30003 to 192.168.0.116:30001: 
Moving slot 16380 from 192.168.0.116:30003 to 192.168.0.116:30001: 
Moving slot 16381 from 192.168.0.116:30003 to 192.168.0.116:30001: 
Moving slot 16382 from 192.168.0.116:30003 to 192.168.0.116:30001: 
Moving slot 16383 from 192.168.0.116:30003 to 192.168.0.116:30001: 

real    1m25.698s
user    0m7.491s
sys     0m3.229s
# 迁移完成大概耗时1m25s
```

- slots迁移完成之后，查看集群slots状态

```
[root@ecs-116 src]# /data/redis/bin/redis-trib.rb check 192.168.0.116:30001
>>> Performing Cluster Check (using node 192.168.0.116:30001)
M: d14821e7d45a1f24a591e9dbec14fb08a1b171a7 192.168.0.116:30001
   slots:0-16383 (16384 slots) master #A节点30001拥有全部的16384个slots，B、C节点上已经没有slots
   3 additional replica(s)
S: 8d8df1e4baa1767249f4ad797e028459eb8b30eb 192.168.0.116:30004
   slots: (0 slots) slave
   replicates d14821e7d45a1f24a591e9dbec14fb08a1b171a7
S: dc1e474745cc241e20bc33504945a095b73d8aba 192.168.0.116:30005
   slots: (0 slots) slave
   replicates d14821e7d45a1f24a591e9dbec14fb08a1b171a7
S: 1d2dbba1465f5f42fb5081b6271dcbf6dc856886 192.168.0.116:30006
   slots: (0 slots) slave
   replicates d14821e7d45a1f24a591e9dbec14fb08a1b171a7
M: 8216ed6a058892a436ce59c00aa244e338f313e3 192.168.0.116:30003
   slots: (0 slots) master
   0 additional replica(s)
M: b2ae5b28e9220a27cab13e4061a37c1d283b74ae 192.168.0.116:30002
   slots: (0 slots) master
   0 additional replica(s)
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[OK] All 16384 slots covered.

```

## redis持久化文件重载

- 把redis单实例30000的持久化文件，移动到redis集群A节点所在服务器，停止A节点，加载AOF文件，重启A节点（笔者操作的时候直接./create-cluster stop，停掉了所有redis实例）

```
# 操作步骤
[root@ecs-116 src]# /data/redis/bin/redis-cli -c -a Aniuredis123 -p 30001 shutdown
[root@ecs-116 src]# ps -ef | grep redis-server # 确认30001停掉
root     10384     1  0 10:33 ?        00:00:19 ../../src/redis-server 0.0.0.0:30002 [cluster]
root     10389     1  0 10:33 ?        00:00:19 ../../src/redis-server 0.0.0.0:30003 [cluster]
root     10394     1  0 10:33 ?        00:00:08 ../../src/redis-server 0.0.0.0:30004 [cluster]
root     10399     1  0 10:33 ?        00:00:08 ../../src/redis-server 0.0.0.0:30005 [cluster]
root     10404     1  0 10:33 ?        00:00:08 ../../src/redis-server 0.0.0.0:30006 [cluster]
redis    10597     1  0 10:38 ?        00:00:03 /usr/bin/redis-server 0.0.0.0:6379
root     10662     1  0 10:42 ?        00:00:35 /data/redis/bin/redis-server 0.0.0.0:30000
root     13358 10286  0 11:49 pts/0    00:00:00 grep --color=auto redis-server

- 把30000的AOF覆盖30001的AOF
[root@ecs-116 src]# cp /var/lib/redis/appendonly-30000.aof /data/redis/utils/create-cluster/appendonly-30001.aof 
cp: overwrite ‘/data/redis/utils/create-cluster/appendonly-30001.aof’? y
[root@ecs-116 src]# du -sh /var/lib/redis/appendonly-30000.aof
38M     /var/lib/redis/appendonly-30000.aof
[root@ecs-116 src]# du -sh /data/redis/utils/create-cluster/appendonly-30001.aof
38M     /data/redis/utils/create-cluster/appendonly-30001.aof 
# 可以看出30001的AOF文件已经被替换
```

- 重启A节点，查看redis dbsize

```
# 移动到/data/redis/utils/create-cluster目录下，执行下面命令：
[root@ecs-116 create-cluster]# ../../src/redis-server --bind 0.0.0.0 --requirepass Aniuredis123 --masterauth Aniuredis123 --protected-mode no --port 30001 --cluster-enabled yes --cluster-config-file nodes-30001.conf --cluster-node-timeout 2000 --appendonly yes --appendfilename appendonly-30001.aof --dbfilename dump-30001.rdb --logfile 30001.log --daemonize yes
[root@ecs-116 create-cluster]# ps -ef | grep redis-server
root     10384     1  0 10:33 ?        00:00:21 ../../src/redis-server 0.0.0.0:30002 [cluster]
root     10389     1  0 10:33 ?        00:00:21 ../../src/redis-server 0.0.0.0:30003 [cluster]
root     10394     1  0 10:33 ?        00:00:11 ../../src/redis-server 0.0.0.0:30004 [cluster]
root     10399     1  0 10:33 ?        00:00:11 ../../src/redis-server 0.0.0.0:30005 [cluster]
root     10404     1  0 10:33 ?        00:00:11 ../../src/redis-server 0.0.0.0:30006 [cluster]
redis    10597     1  0 10:38 ?        00:00:04 /usr/bin/redis-server 0.0.0.0:6379
root     10662     1  0 10:42 ?        00:00:35 /data/redis/bin/redis-server 0.0.0.0:30000
root     13887     1 81 11:59 ?        00:00:02 ../../src/redis-server 0.0.0.0:30001 [cluster] # 节点A 30001已经起来
root     13894 10286  0 11:59 pts/0    00:00:00 grep --color=auto redis-server

# 或者直接
[root@ecs-116 create-cluster]# ./create-cluster start # 启动
Starting 30001
Starting 30002
Starting 30003
Starting 30004
Starting 30005
Starting 30006

# 查看dbsize
[root@ecs-116 create-cluster]# /data/redis/bin/redis-cli -c -a Aniuredis123 -p 30001 dbsize
(integer) 865405 # 和当时30000节点上keys数量一致
```

- 把A节点上的slots(5462个)移动到B节点上

```
[root@ecs-116 ~]# time /data/redis/bin/redis-trib.rb reshard --from d14821e7d45a1f24a591e9dbec14fb08a1b171a7 --to b2ae5b28e9220a27cab13e4061a37c1d283b74ae --slots 5462 --yes 192.168.0.116:30001
...
# 执行完成：
    Moving slot 5456 from 651e1184fb19f7ff276650b8ec4b644017c7b038
    Moving slot 5457 from 651e1184fb19f7ff276650b8ec4b644017c7b038
    Moving slot 5458 from 651e1184fb19f7ff276650b8ec4b644017c7b038
    Moving slot 5459 from 651e1184fb19f7ff276650b8ec4b644017c7b038
    Moving slot 5460 from 651e1184fb19f7ff276650b8ec4b644017c7b038
    Moving slot 5461 from 651e1184fb19f7ff276650b8ec4b644017c7b038
Moving slot 0 from 192.168.0.116:30001 to 192.168.0.116:30002: 
[ERR] Calling MIGRATE: ERR Syntax error, try CLIENT (LIST | KILL | GETNAME | SETNAME | PAUSE | REPLY) # 这里查报错

real    0m0.909s
user    0m0.452s
```
- 把A节点上的slots（5461个）移动到C节点上


## 重新划分集群


## 深入理解redis集群

- 参考：http://shift-alt-ctrl.iteye.com/blog/2285470
- http://www.cnblogs.com/zhoujinyi/p/6477133.html
- https://blog.csdn.net/dc_726/article/details/48552531