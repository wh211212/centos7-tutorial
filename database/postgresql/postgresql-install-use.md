# CentOS7 postgresql安装与使用

## 安装配置postgresql

```
# 安装
[root@vm-06 ~]# yum -y install postgresql-server
# 初始化
[root@vm-06 ~]# postgresql-setup initdb 
Initializing database ... OK
# 设置postgresql可被远程连接登录
[root@vm-06 ~]# vi /var/lib/pgsql/data/postgresql.conf
# 第59行取消注释，更改为：
listen_addresses = '*'
# 第395行，添加
log_line_prefix = '%t %u %d '
[root@vm-06 ~]# systemctl start postgresql  
[root@vm-06 ~]# systemctl enable postgresql 
```

- 防火设置

```
[root@vm-06 ~]# firewall-cmd --add-service=postgresql --permanent 
success
[root@vm-06 ~]# firewall-cmd --reload 
success
```

- 设置PostgreSQL管理员用户的密码并添加一个用户并添加一个测试数据库。

```
[root@vm-06 ~]# su - postgres 
-bash-4.2$ psql -c "alter user postgres with password 'password'"
ALTER ROLE
-bash-4.2$ createuser devops
-bash-4.2$ createdb testdb -O devops
-bash-4.2$ exit
logout

```

- 以刚刚添加的用户身份登录，并将DataBase作为测试操作。

```
[root@vm-06 ~]# su - devops
[devops@vm-06 ~]$ 
[devops@vm-06 ~]$ 
[devops@vm-06 ~]$ 
[devops@vm-06 ~]$ psql -l
                                  List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges   
-----------+----------+----------+-------------+-------------+-----------------------
 postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 template0 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
 testdb    | devops   | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
(4 rows)

[devops@vm-06 ~]$ psql testdb
psql (9.2.23)
Type "help" for help.

testdb=> alter user devops with password 'password';
ALTER ROLE
testdb=> create table test (no int,name text );
CREATE TABLE
testdb=> insert into test (no,name) values (1,'devops');         
INSERT 0 1
testdb=> select * from test;
 no |  name  
----+--------
  1 | devops
(1 row)

testdb=> drop table test;
DROP TABLE
testdb=> \q
[devops@vm-06 ~]$ dropdb testdb
```

## PostgreSQL 主从配置

- hosts

```
192.168.1.124 master
192.168.1.123 slave01
```

> 配置PostgreSQL复制设置。配置是主从设置。

- 配置主服务器

```
[root@vm-06 ~]# yum -y install postgresql-server
[root@vm-06 ~]# postgresql-setup initdb 
Initializing database ... OK
[root@vm-06 ~]# vi /var/lib/pgsql/data/postgresql.conf # 编辑配置文件
# 第59行，取消注释更改为：
listen_addresses = '*'
# 第165行，取消注释更改为：
wal_level = hot_standby
# 第168行，取消注释更改为：
# on ⇒ sync
# remote_write ⇒ memory sync
# local ⇒ slave is asynchronous
# off ⇒ asynchronous
synchronous_commit = local
# 第194行，取消注释更改为：
archive_mode = on
# 第196行，取消注释更改为：
archive_command = 'cp %p /var/lib/pgsql/archive/%f'
# 第212行，取消注释更改为：
max_wal_senders = 2
# 第214行，取消注释更改为：
wal_keep_segments = 10
# 第221行，取消注释更改为：
synchronous_standby_names = 'slave01'
# 
[root@vm-06 ~]# vi /var/lib/pgsql/data/pg_hba.conf
# 文件最后添加
# host replication [replication user] [allowed IP addresses] password
 host    replication     replica          127.0.0.1/32            md5
host    replication     replica          192.168.1.1/32            md5

[root@vm-06 ~]# systemctl start postgresql 
[root@vm-06 ~]# systemctl enable postgresql 
# create a user for replication
[root@vm-06 ~]# su - postgres
-bash-4.2$ createuser --replication -P replica 
Enter password for new role: #password
Enter it again: #password
```

- 配置从服务器

```
# 安装
[root@vm-05 ~]# yum -y install postgresql-server
[root@vm-05 ~]# su - postgres
# get backup from Master Server
-bash-4.2$ pg_basebackup -h 192.168.1.124 -U replica -D /var/lib/pgsql/data -P --xlog 
Password:     # "replica" user's password
-bash-4.2$ vi /var/lib/pgsql/data/postgresql.conf
# line 230: uncomment and change
hot_standby = on
-bash-4.2$ cp /usr/share/pgsql/recovery.conf.sample /var/lib/pgsql/data/recovery.conf 
-bash-4.2$ vi /var/lib/pgsql/data/recovery.conf
# line 44: uncomment and change (command to get archives)
restore_command = 'scp 192.168.1.124:/var/lib/pgsql/archive/%f %p'
# line 108: uncomment and change
standby_mode = on
# line 115: uncomment and change (connection info to Master Server)
primary_conninfo = 'host=192.168.1.124 port=5432 user=replica password=password application_name=slave01'
-bash-4.2$ exit 
logout
[root@vm-05 ~]# systemctl start postgresql 
[root@vm-05 ~]# systemctl enable postgresql 
```

- 配置完成master所在服务器查看状态：

```
[root@vm-06 ~]# su - postgres        
Last login: Tue Jun 12 15:35:12 +08 2018 on pts/0
-bash-4.2$ psql -c "select application_name, state, sync_priority, sync_state from pg_stat_replication;" 
 application_name |   state   | sync_priority | sync_state 
------------------+-----------+---------------+------------
 slave01          | streaming |             1 | sync
(1 row)
```