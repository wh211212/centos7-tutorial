# 重启rabbitmq-server服务器，再次登录之前创建的rabbitmq用户报错：

[warning] <0.694.0> HTTP access denied: user 'rabbitmq' - invalid credentials

## 解决：

vim /usr/lib/rabbitmq/lib/rabbitmq_server-3.7.4/ebin/rabbit.app

找到：loopback_users里的<<”guest”>>删除

如下：{loopback_users, []}

重启：systemctl restart rabbitmq-server.service  # 生产环境不建议这么做

## 创建一个管理员用户登录管理界面

rabbitmqctl add_user rabbitmq Aniumq123. && rabbitmqctl set_user_tags rabbitmq administrator # 集群情况下，创建用户时，每个节点会自动同步


