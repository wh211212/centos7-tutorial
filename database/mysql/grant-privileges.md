# mysql账号添加权限

# 查看用户

SELECT DISTINCT CONCAT('User: ''',user,'''@''',host,''';') AS query FROM mysql.user;

# 查看用户权限
show grants for 'wanghui'@'%';

# 重置密码MySQL5.6

update mysql.user set password=password('Aniudb123.') where user='root@localhost';
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('Aniudb123.');
flush privileges;

# 重置密码MySQL5.7

update mysql.user set password=password('bareos') where User='bareos';

# 权限设置

mysql -uroot -p -e"GRANT USAGE ON *.* TO 'zabbix'@'127.0.0.1' IDENTIFIED BY 'Aniuzabbix123.'";
mysql -uroot -p -e"GRANT USAGE ON *.* TO 'zabbix'@'localhost' IDENTIFIED BY 'Aniuzabbix123.'";
mysql -uroot -p -e"flush privileges"

GRANT select ON tysx_s.* TO wuchenming@'192.168.103.%' IDENTIFIED BY 'yv29NPCeSgMRCAsH'; 

GRANT select ON aniu_product.* TO 'nkmdev'@'192.168.103.%' IDENTIFIED BY 'cgui2gty9XiKXKsN';

GRANT ALL PRIVILEGES ON *.* TO 'yunwei'@'%' IDENTIFIED BY 'Aniuyunwei123.';

GRANT ALL PRIVILEGES ON `aniu_message_channel`.* TO 'guodepei'@'192.168.103.%' IDENTIFIED BY 'cgui2gty9XiKXKsN';

GRANT SELECT ON niu_interface.* TO 'algoquote'@'192.168.0.%' IDENTIFIED BY 'yv29NPCeSgMRCAsH';

GRANT ALL PRIVILEGES ON salt.* TO 'salt'@'%' IDENTIFIED BY 'Salt123.';


GRANT ALL PRIVILEGES ON *.* TO 'caven'@'%' IDENTIFIED BY 'dkemftlswjdgml';

GRANT SELECT ON aniu_crm.* TO 'tangxiuwen'@'192.168.103.%' IDENTIFIED BY 'xiuwen123.';

GRANT ALL PRIVILEGES ON `tysx_s`.`aniu_custom_service_phone` TO 'wangfei'@'192.168.0.%';

flush privileges;

## 增删改查
grant select insert update on algo_quote.* to mingjing@'192.168.103.%' IDENTIFIED BY 'Mingjing123.';

grant insert on testdb.* to common_user@'%' IDENTIFIED BY 'fangbuxia..0';
grant update on testdb.* to common_user@'%' IDENTIFIED BY 'fangbuxia..0';
grant delete on testdb.* to common_user@'%' IDENTIFIED BY 'fangbuxia..0';
#
grant select, insert, update, delete on testdb.* to common_user@'%' 'fangbuxia..0';
#
flush privileges;

# grant 创建、修改、删除 MySQL 数据表结构权限

grant create on testdb.* to developer@'192.168.0.%';
grant alter  on testdb.* to developer@'192.168.0.%';
grant drop   on testdb.* to developer@'192.168.0.%';
#
grant references on testdb.* to developer@'192.168.0.%';

# grant 操作 MySQL 临时表权限

grant create temporary tables on testdb.* to developer@'192.168.0.%';

# grant 操作 MySQL 索引权限

grant index on testdb.* to developer@'192.168.0.%';

# grant 操作 MySQL 视图、查看视图源代码 权限
grant create view on testdb.* to developer@'192.168.0.%';
grant show   view on testdb.* to developer@'192.168.0.%';

# grant 操作 MySQL 存储过程、函数 权限

grant create routine on testdb.* to developer@'192.168.0.%'; -- now, can show procedure status
grant alter  routine on testdb.* to developer@'192.168.0.%'; -- now, you can drop a procedure
grant execute        on testdb.* to developer@'192.168.0.%';

# grant 普通 DBA 管理某个 MySQL 数据库的权限

grant all privileges on testdb to dba@'localhost' IDENTIFIED BY 'dbapassword';

# grant 高级 DBA 管理 MySQL 中所有数据库的权限

grant all on *.* to dba@'localhost';

# MySQL grant 权限，分别可以作用在多个层次上

## grant 作用在整个 MySQL 服务器上

grant select on *.* to dba@localhost; -- dba 可以查询 MySQL 中所有数据库中的表
grant all    on *.* to dba@localhost; -- dba 可以管理 MySQL 中的所有数据库

## grant 作用在单个数据库上
grant select on testdb.* to dba@localhost; -- dba 可以查询 testdb 中的表。

## grant 作用在单个数据表上

grant select, insert, update, delete on testdb.orders to dba@localhost;

## grant 作用在表中的列上

grant select(id, se, rank) on testdb.apache_log to dba@localhost;

## rant 作用在存储过程、函数上

grant execute on procedure testdb.pr_add to 'dba'@'localhost'
grant execute on function testdb.fn_add to 'dba'@'localhost'

# 查看当前用户（自己）权限
show grants;

# 查看其他 MySQL 用户权限

show grants for dba@localhost;

# 权限删除
grant  all on *.* to   dba@localhost;
revoke all on *.* from dba@localhost;
flush
delete from mysql.user where user="walle" and host="192.168.0.%";

delete from mysql.user where user="mingjing" and host="%";

# mysql授权表共有5个表：user、db、host、tables_priv和columns_priv

授权表的内容有如下用途：
user表
user表列出可以连接服务器的用户及其口令，并且它指定他们有哪种全局（超级用户）权限。在user表启用的任何权限均是全局权限，并适用于所有数据库。例如，如果你启用了DELETE权限，在这里列出的用户可以从任何表中删除记录，所以在你这样做之前要认真考虑。

db表
db表列出数据库，而用户有权限访问它们。在这里指定的权限适用于一个数据库中的所有表。

host表
host表与db表结合使用在一个较好层次上控制特定主机对数据库的访问权限，这可能比单独使用db好些。这个表不受GRANT和REVOKE语句的影响，所以，你可能发觉你根本不是用它。

tables_priv表
tables_priv表指定表级权限，在这里指定的一个权限适用于一个表的所有列。

columns_priv表
columns_priv表指定列级权限。这里指定的权限适用于一个表的特定列。

# 查看变量
show variables like '%interactive_timeout%';

set global log_warning=1;
set global interactive_timeout = 120;   服务器关闭交互式连接前等待活动的秒数。交互式客户端定义为在mysql_real_connect()中使用CLIENT_INTERACTIVE选项的客户端。参数默认值：28800秒（8小时）
set global wait_timeout = 120;  服务器关闭非交互连接之前等待活动的秒数。参数默认值：28800秒（8小时）

# 查看mysql进程连接
show processlist;
show variables like 'wait_timeout';

 # mysql导入 备份


# 修改字段字符集 
1 # 修改数据库:  
2 ALTER DATABASE database_name CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;  
3 # 修改表:  
4 ALTER TABLE table_name CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;  
5 # 修改表字段:  
6 ALTER TABLE table_name CHANGE column_name column_name VARCHAR(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;