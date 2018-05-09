# 分布式RabbitMQ代理

## RabbitMQ 集群

# rabbitmq cluster
192.168.0.62 rabbitmq1 ecs-13
192.168.0.63 rabbitmq2 ecs-14
192.168.0.64 rabbitmq3 ecs-15

由于笔者的rabbitmq节点是虚拟机，rabbitmq2，rabbitmq3由rabbitmq1克隆而来，因此笔者三台的erlang.cookie都一样，如果rabbitmq节点单独安装的需要同步erlang.cookie值到每个节点

- 以rabbitmq1为例：

scp /var/lib/rabbitmq/.erlang.cookie rabbitmq2:/var/lib/rabbitmq/.erlang.cookie
scp /var/lib/rabbitmq/.erlang.cookie rabbitmq3:/var/lib/rabbitmq/.erlang.cookie

- 配置集群，以rabbitmq1节点为例：

systemctl restart rabbitmq-server

- 停止应用并重置


创建集群

把rabbitmq2加到rabbitmq1集群当中，再把rabbitm3加到rabbitmq1集群中

rabbitmq2上执行：
[root@rabbitmq2 ~]# rabbitmqctl stop_app
Stopping rabbit application on node rabbit@rabbitmq2 ...
[root@rabbitmq2 ~]# rabbitmqctl join_cluster rabbitmqctl join_cluster^C
[root@rabbitmq2 ~]# rabbitmqctl join_cluster rabbit@rabbitmq1
Clustering node rabbit@rabbitmq2 with rabbit@rabbitmq1
[root@rabbitmq2 ~]# rabbitmqctl start_app
Starting node rabbit@rabbitmq2 ...
 completed with 6 plugins.

rabbitmq3上执行：
[root@rabbitmq3 ~]# rabbitmqctl stop_app
Stopping rabbit application on node rabbit@rabbitmq3 ...
[root@rabbitmq3 ~]# rabbitmqctl join_cluster rabbitmqctl join_cluster^C
[root@rabbitmq3 ~]# rabbitmqctl join_cluster rabbit@rabbitmq1
Clustering node rabbit@rabbitmq3 with rabbit@rabbitmq1
[root@rabbitmq3 ~]# rabbitmqctl start_app
Starting node rabbit@rabbitmq3 ...
 completed with 6 plugins.

rabbitmq1上查看：

 [root@rabbitmq1 ~]# rabbitmqctl cluster_status
Cluster status of node rabbit@rabbitmq1 ...
[{nodes,[{disc,[rabbit@rabbitmq1,rabbit@rabbitmq2]}]},
 {running_nodes,[rabbit@rabbitmq2,rabbit@rabbitmq1]},
 {cluster_name,<<"rabbit@rabbitmq1">>},
 {partitions,[]},
 {alarms,[{rabbit@rabbitmq2,[]},{rabbit@rabbitmq1,[]}]}] # rabbitmq2先加到集群中来
[root@rabbitmq1 ~]# rabbitmqctl cluster_status
Cluster status of node rabbit@rabbitmq1 ...
[{nodes,[{disc,[rabbit@rabbitmq1,rabbit@rabbitmq2,rabbit@rabbitmq3]}]},
 {running_nodes,[rabbit@rabbitmq3,rabbit@rabbitmq2,rabbit@rabbitmq1]},
 {cluster_name,<<"rabbit@rabbitmq1">>},
 {partitions,[]},
 {alarms,[{rabbit@rabbitmq3,[]},{rabbit@rabbitmq2,[]},{rabbit@rabbitmq1,[]}]}] # rabbitmq3也加到集群中来

[root@rabbitmq1 ~]# rabbitmqctl cluster_status
Cluster status of node rabbit@rabbitmq1 ...
[{nodes,[{disc,[rabbit@rabbitmq1,rabbit@rabbitmq2,rabbit@rabbitmq3]}]},
 {running_nodes,[rabbit@rabbitmq3,rabbit@rabbitmq2,rabbit@rabbitmq1]},
 {cluster_name,<<"rabbit@rabbitmq1">>},
 {partitions,[]},
 {alarms,[{rabbit@rabbitmq3,[]},{rabbit@rabbitmq2,[]},{rabbit@rabbitmq1,[]}]}]
[root@rabbitmq1 ~]# 

[root@rabbitmq2 ~]# rabbitmqctl start_app
Starting node rabbit@rabbitmq2 ...
 completed with 6 plugins.
[root@rabbitmq2 ~]# rabbitmqctl cluster_status
Cluster status of node rabbit@rabbitmq2 ...
[{nodes,[{disc,[rabbit@rabbitmq1,rabbit@rabbitmq2,rabbit@rabbitmq3]}]},
 {running_nodes,[rabbit@rabbitmq3,rabbit@rabbitmq1,rabbit@rabbitmq2]},
 {cluster_name,<<"rabbit@rabbitmq1">>},
 {partitions,[]},
 {alarms,[{rabbit@rabbitmq3,[]},{rabbit@rabbitmq1,[]},{rabbit@rabbitmq2,[]}]}]
[root@rabbitmq3 ~]# rabbitmqctl cluster_status
Cluster status of node rabbit@rabbitmq3 ...
[{nodes,[{disc,[rabbit@rabbitmq1,rabbit@rabbitmq2,rabbit@rabbitmq3]}]},
 {running_nodes,[rabbit@rabbitmq1,rabbit@rabbitmq2,rabbit@rabbitmq3]},
 {cluster_name,<<"rabbit@rabbitmq1">>},
 {partitions,[]},
 {alarms,[{rabbit@rabbitmq1,[]},{rabbit@rabbitmq2,[]},{rabbit@rabbitmq3,[]}]}]

可以通过在任何节点上运行cluster_status命令来看到这三个节点已加入到群集中：
rabbitmqctl cluster_status

## 重启集群节点

模拟故障：停掉rabbit@rabbitmq1、rabbit@rabbitmq3，检查集群状态

[root@rabbitmq1 ~]# rabbitmqctl stop
Stopping and halting node rabbit@rabbitmq1 ...

rabbitmq2： 查看
[root@rabbitmq2 ~]# rabbitmqctl cluster_status
Cluster status of node rabbit@rabbitmq2 ...
[{nodes,[{disc,[rabbit@rabbitmq1,rabbit@rabbitmq2,rabbit@rabbitmq3]}]},
 {running_nodes,[rabbit@rabbitmq3,rabbit@rabbitmq2]},
 {cluster_name,<<"rabbit@rabbitmq1">>},
 {partitions,[]},
 {alarms,[{rabbit@rabbitmq3,[]},{rabbit@rabbitmq2,[]}]}]

rabbitmq3上查看：
[root@rabbitmq3 ~]# rabbitmqctl cluster_status
Cluster status of node rabbit@rabbitmq3 ...
[{nodes,[{disc,[rabbit@rabbitmq1,rabbit@rabbitmq2,rabbit@rabbitmq3]}]},
 {running_nodes,[rabbit@rabbitmq2,rabbit@rabbitmq3]},
 {cluster_name,<<"rabbit@rabbitmq1">>},
 {partitions,[]},
 {alarms,[{rabbit@rabbitmq2,[]},{rabbit@rabbitmq3,[]}]}] 

 - 停掉rabbitmq3，rabbitm2上查看集群状态：

[root@rabbitmq2 ~]# rabbitmqctl cluster_status
Cluster status of node rabbit@rabbitmq2 ...
[{nodes,[{disc,[rabbit@rabbitmq1,rabbit@rabbitmq2,rabbit@rabbitmq3]}]},
 {running_nodes,[rabbit@rabbitmq2]},
 {cluster_name,<<"rabbit@rabbitmq1">>},
 {partitions,[]},
 {alarms,[{rabbit@rabbitmq2,[]}]}]


- 重新启动rabbitmq1，rabbitmq3，查看集群状态


[root@rabbitmq1 ~]# rabbitmq-server -detached
Warning: PID file not written; -detached was passed. # 忽略
[root@rabbitmq1 ~]# rabbitmqctl cluster_status
Cluster status of node rabbit@rabbitmq1 ...
[{nodes,[{disc,[rabbit@rabbitmq1,rabbit@rabbitmq2,rabbit@rabbitmq3]}]},
 {running_nodes,[rabbit@rabbitmq2,rabbit@rabbitmq1]},
 {cluster_name,<<"rabbit@rabbitmq1">>},
 {partitions,[]},
 {alarms,[{rabbit@rabbitmq2,[]},{rabbit@rabbitmq1,[]}]}]

 [root@rabbitmq3 ~]# rabbitmq-server -detached

[root@rabbitmq3 ~]# rabbitmqctl cluster_status
Cluster status of node rabbit@rabbitmq3 ...
[{nodes,[{disc,[rabbit@rabbitmq1,rabbit@rabbitmq2,rabbit@rabbitmq3]}]},
 {running_nodes,[rabbit@rabbitmq1,rabbit@rabbitmq2,rabbit@rabbitmq3]},
 {cluster_name,<<"rabbit@rabbitmq1">>},
 {partitions,[]},
 {alarms,[{rabbit@rabbitmq1,[]},{rabbit@rabbitmq2,[]},{rabbit@rabbitmq3,[]}]}]


## 破坏集群

从集群中移除rabbitmq3

rabbitmqctl stop_app
rabbitmqctl reset
rabbitmqctl start_app

即可

远程删除节点，在rabbitmq2上，删除rabbitmq1

rabbitmqctl stop_app # rabbitmq1上操作

rabbitmqctl forget_cluster_node rabbit@rabbitmq1 # rabbitmq2上操作

rabbitmqctl forget_cluster_node  # 自动清理未知节点


## 创建ram节点

rabbitmqctl stop_app
rabbitmqctl join_cluster --ram rabbit@rabbitmq1
rabbitmqctl start_app


## 改变节点类型 

rabbitmqctl stop_app
rabbitmqctl change_cluster_node_type disc
rabbitmqctl start_app






