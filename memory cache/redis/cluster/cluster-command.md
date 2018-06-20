# redis集群常用命令 

CLUSTER info：打印集群的信息。
CLUSTER nodes：列出集群当前已知的所有节点（node）的相关信息。
CLUSTER meet <ip> <port>：将ip和port所指定的节点添加到集群当中。
CLUSTER addslots <slot> [slot ...]：将一个或多个槽（slot）指派（assign）给当前节点。
CLUSTER delslots <slot> [slot ...]：移除一个或多个槽对当前节点的指派。
CLUSTER slots：列出槽位、节点信息。
CLUSTER slaves <node_id>：列出指定节点下面的从节点信息。
CLUSTER replicate <node_id>：将当前节点设置为指定节点的从节点。
CLUSTER saveconfig：手动执行命令保存保存集群的配置文件，集群默认在配置修改的时候会自动保存配置文件。
CLUSTER keyslot <key>：列出key被放置在哪个槽上。
CLUSTER flushslots：移除指派给当前节点的所有槽，让当前节点变成一个没有指派任何槽的节点。
CLUSTER countkeysinslot <slot>：返回槽目前包含的键值对数量。
CLUSTER getkeysinslot <slot> <count>：返回count个槽中的键。

CLUSTER setslot <slot> node <node_id> 将槽指派给指定的节点，如果槽已经指派给另一个节点，那么先让另一个节点删除该槽，然后再进行指派。  
CLUSTER setslot <slot> migrating <node_id> 将本节点的槽迁移到指定的节点中。  
CLUSTER setslot <slot> importing <node_id> 从 node_id 指定的节点中导入槽 slot 到本节点。  
CLUSTER setslot <slot> stable 取消对槽 slot 的导入（import）或者迁移（migrate）。 

CLUSTER failover：手动进行故障转移。
CLUSTER forget <node_id>：从集群中移除指定的节点，这样就无法完成握手，过期时为60s，60s后两节点又会继续完成握手。
CLUSTER reset [HARD|SOFT]：重置集群信息，soft是清空其他节点的信息，但不修改自己的id，hard还会修改自己的id，不传该参数则使用soft方式。

CLUSTER count-failure-reports <node_id>：列出某个节点的故障报告的长度。
CLUSTER SET-CONFIG-EPOCH：设置节点epoch，只有在节点加入集群前才能设置。


## slots迁移

1，在目标节点上声明将从源节点上迁入Slot CLUSTER SETSLOT <slot> IMPORTING <source_node_id>
2，在源节点上声明将往目标节点迁出Slot CLUSTER SETSLOT <slot> migrating <target_node_id>
3，批量从源节点获取KEY CLUSTER GETKEYSINSLOT <slot> <count>
4，将获取的Key迁移到目标节点 MIGRATE <target_ip> <target_port> <key_name> 0 <timeout>
重复步骤3，4直到所有数据迁移完毕，MIGRATE命令会将所有的指定的key通过RESTORE key ttl serialized-value REPLACE迁移给target
5，分别向双方节点发送 CLUSTER SETSLOT <slot> NODE <target_node_id>，该命令将会广播给集群其他节点，取消importing和migrating。
6，等待集群状态变为OK CLUSTER INFO 中的 cluster_state = ok