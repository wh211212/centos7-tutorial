# redis4.0.9 集群迁移solts错误

- [ERR] Calling MIGRATE: ERR Syntax error, try CLIENT (LIST | KILL | GETNAME | SETNAME | PAUSE | REPLY)

集群状态：

```
[root@ecs-116 src]# /data/redis/bin/redis-trib.rb check 192.168.0.116:30001                      
>>> Performing Cluster Check (using node 192.168.0.116:30001)
M: 3e9e5c8043ff41d6ebf60a95a31a648d064f4448 192.168.0.116:30001
   slots:0-16383 (16384 slots) master
   3 additional replica(s)
M: 41da0f40c4fd966a6cdd6b00521b64888aa271a6 192.168.0.116:30002
   slots: (0 slots) master
   0 additional replica(s)
S: fe41b92d7b4abc5361115a42b38941c4282f10c7 192.168.0.116:30006
   slots: (0 slots) slave
   replicates 3e9e5c8043ff41d6ebf60a95a31a648d064f4448
S: 59b3cb11c42f57b54c5f6f69c2cc886c03ee4930 192.168.0.116:30005
   slots: (0 slots) slave
   replicates 3e9e5c8043ff41d6ebf60a95a31a648d064f4448
S: 6f26676c6ab5fdb622e950eefa9b73f98e7804d7 192.168.0.116:30004
   slots: (0 slots) slave
   replicates 3e9e5c8043ff41d6ebf60a95a31a648d064f4448
M: 9a51adb7912816b0e7d307df7312eb3d1e851f43 192.168.0.116:30003
   slots: (0 slots) master
   0 additional replica(s)
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
[WARNING] Node 192.168.0.116:30001 has slots in migrating state (0).
[WARNING] Node 192.168.0.116:30002 has slots in importing state (0).
[WARNING] The following slots are open: 0
>>> Check slots coverage...
[OK] All 16384 slots covered.
```

## 报错解决

- 参考：https://github.com/antirez/redis/issues/4272

```
# 只需安装较早版本的redis.rb即可解决问题
[root@ecs-116 src]# gem list |grep redis
redis (4.0.1, 3.3.3)
[root@ecs-116 src]# gem uninstall redis --version 4.0.1
Successfully uninstalled redis-4.0.1

gem install redis -v 3.3.3 # 下载完成，记得修改client.rb文件，添加redis集群密码
```

- [ERR] Calling MIGRATE: ERR Target instance replied with error: NOAUTH Authentication required.

https://github.com/antirez/redis/pull/4288



- 连接报错Unexpected end of stream



