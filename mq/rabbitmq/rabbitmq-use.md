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
[root@aniu-saas-1 bin]# rabbitmqctl set_user_tags rabbitmq administrator
Setting tags for user "rabbitmq" to [administrator] ...
...done.