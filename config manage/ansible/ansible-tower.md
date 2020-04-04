# 三步搞定ansible-tower

## 环境准备

- centos7 + 2c/G （笔者测试）

## step1 下载ansible-tower最新版

- wget https://releases.ansible.com/ansible-tower/setup/ansible-tower-setup-latest.tar.gz

## step2 解压tower到opt下，并配置初始密码

```
tar zxvf ansible-tower-setup-bundle-latest.el7.tar.gz -C /opt/
cd /opt/ansible-tower-setup-bundle-3.5.2-1.el7/
```

- 更改配置如下：

```
# cat inventory 
[tower]
localhost ansible_connection=local

[database]

[all:vars]
admin_password='admin' #增加，默认无

pg_host=''
pg_port=''

pg_database='awx'
pg_username='awx'
pg_password='awx' #增加，默认无

rabbitmq_username=tower
rabbitmq_password='tower' #增加，默认无
rabbitmq_cookie=cookiemonster
```

## step3 执行sh setup

- sh setup.sh # 无报错，执行完成即可

## step4 访问并激活无限hosts

- 访问：https://ip

```
# 执行下面命令，刷新tower页面即可
echo codyguo > /var/lib/awx/i18n.db
```

- 友情链接：https://blog.csdn.net/CodyGuo/article/details/84136181
