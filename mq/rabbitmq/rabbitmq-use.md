# rabbitmq常用操作

## 创建rabbitmq

[root@aniu-saas-1 bin]# rabbitmqctl add_user rabbitmq password
Creating user "rabbitmq" ...
...done.
[root@aniu-saas-1 bin]# rabbitmqctl add_vhost /my_vhost
Creating vhost "/my_vhost" ...
...done.
[root@aniu-saas-1 bin]# rabbitmqctl add_vhost /nkm_vhost
Creating vhost "/nkm_vhost" ...
...done.
[root@aniu-saas-1 bin]# rabbitmqctl set_permissions -p /nkm_vhost rabbitmq ".*" ".*" ".*"
Setting permissions for user "rabbitmq" in vhost "/nkm_vhost" ...
...done.

[root@aniu-saas-1 ~]# rabbitmqctl set_permissions -p /nkm_vhost_task rabbitmq ".*" ".*" ".*"

[root@aniu-saas-1 bin]# rabbitmqctl set_user_tags rabbitmq administrator
Setting tags for user "rabbitmq" to [administrator] ...
...done.

## 创建生产者和消费者账号

nkm_producer & nkm_consumer

rabbitmqctl add_user  producer_passwd

改变密码


rabbitmqctl add_user nkm_consumer consumer_passwd

rabbitmqctl change_password nkm_producer producer_passwd 

[root@aniu-saas-1 ~]# rabbitmqctl list_vhosts
Listing vhosts ...
/
/nkm_vhost
/nkm_vhost_task

rabbitmqctl set_permissions -p /nkm_vhost nkm_producer ".*" ".*" ".*"
rabbitmqctl set_permissions -p /nkm_vhost_task nkm_producer ".*" ".*" ".*"

rabbitmqctl set_permissions -p /nkm_vhost nkm_consumer ".*" ".*" ".*"
rabbitmqctl set_permissions -p /nkm_vhost_task nkm_consumer ".*" ".*" ".*"

