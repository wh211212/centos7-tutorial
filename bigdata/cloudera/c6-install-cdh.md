# Cloudera Manager 安装 CDH5.x 心得

> 废话不多说，先展示下这几天捣鼓的成果

- Cloudera Manager 管理配置界面

![这里写图片描述](http://img.blog.csdn.net/20171213102457112?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2gyMTEyMTI=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

- Hbase 管理界面及Hbase Web UI

![这里写图片描述](http://img.blog.csdn.net/20171213102556106?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2gyMTEyMTI=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

![这里写图片描述](http://img.blog.csdn.net/20171213102623505?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2gyMTEyMTI=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

- HDFS 管理界面 及 NameNode Web UI

![这里写图片描述](http://img.blog.csdn.net/20171213102721864?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2gyMTEyMTI=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

![这里写图片描述](http://img.blog.csdn.net/20171213102812360?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2gyMTEyMTI=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)


- Hive 管理界面 及 HiveServer2 Web UI

![这里写图片描述](http://img.blog.csdn.net/20171213103023112?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2gyMTEyMTI=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)
![这里写图片描述](http://img.blog.csdn.net/20171213103101968?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2gyMTEyMTI=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

- Hue 管理界面 及 Web UI

![这里写图片描述](http://img.blog.csdn.net/20171213103203463?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2gyMTEyMTI=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

![这里写图片描述](http://img.blog.csdn.net/20171213103246670?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2gyMTEyMTI=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)
> 首次登录会提示让创建管理员账号和密码，笔者 admin admin

![这里写图片描述](http://img.blog.csdn.net/20171213103349874?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2gyMTEyMTI=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

- Oozie 管理界面 及 Oozie  Web UI

![这里写图片描述](http://img.blog.csdn.net/20171213103447451?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2gyMTEyMTI=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

```
# Oozie  Web UI 报错，后期修复

Oozie web console is disabled.
To enable Oozie web console install the Ext JS library.

参考：http://cdh01.aniu.so:11000/oozie/docs/DG_QuickStart.html
```

- YARN (MR2 Included) 管理界面 及 Web UI

![这里写图片描述](http://img.blog.csdn.net/20171213104023409?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2gyMTEyMTI=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)
 
- ResourceManager Web UI
![这里写图片描述](http://img.blog.csdn.net/20171213104210418?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2gyMTEyMTI=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

- HistoryServer Web UI
![这里写图片描述](http://img.blog.csdn.net/20171213104600793?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2gyMTEyMTI=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

- Zookeeper 管理界面

![这里写图片描述](http://img.blog.csdn.net/20171213104648546?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2gyMTEyMTI=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

> 笔者这里zookeeper安装的时候选择的默认，因此只安装了一个zookeeper，但个人感觉后期应该需要增加zookeeper的界面数量

## 下面开始说安装的注事事项

- 1、配置环境要符合要求，要纯净的系统环境

```
# 笔者环境
# CM env
192.168.1.137 cdh01.aniu.so CentOS6.9 16G Memory 100G LVM卷 （Manger 节点）
192.168.1.148 cdh02.aniu.so CentOS6.9 4G Memory 70G LVM卷
192.168.1.149 cdh03.aniu.so CentOS6.9 4G Memory 70G LVM卷
192.168.1.150 cdh04.aniu.so CentOS6.9 4G Memory 70G LVM卷

建议小白参考笔者的环境配置，主机名可以自定义

#对四个节点的系统进行更新，安装开发工具包
yum update -y && yum -y groupinstall "Development Tools"
```

- 2、关闭防火墙、禁用Selinux

```
# 关闭防火墙
/etc/init.d/iptables stop && /etc/init.d/ip6tables stop
chkconfig iptables off && chkconfig ip6tables off

# 建议采用修改内核参数的方式关闭ip6tables 
vim /etc/modprobe.d/dist.conf # 编辑此文件，在最后加入：

# Disable ipv6
alias net-pf-10 off
alias ipv6 off

# 禁用selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
setenforce 0  # 不重启临时生效
```

- 3、内核参数调整

```
# 内存参数调整
sysctl -w vm.swappiness=10 或者 编辑vim /etc/sysctl.conf，在最后加入：

vm.swappiness = 10

编辑启动项vim /etc/rc.local,最后加入：
echo never > /sys/kernel/mm/transparent_hugepage/defrag 
echo never > /sys/kernel/mm/transparent_hugepage/enabled
```
> 注：上面所有操作在所有节点都需要执行

- 4、所有节点间配置免密认证

```
# CM节点执行
ssh-keygen -t rsa -b 2048 # 有确认提示，一直按回车即可
cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
# 笔者 hosts.conf
# CM node
192.168.1.137 cdh01.aniu.so
192.168.1.148 cdh02.aniu.so
192.168.1.149 cdh03.aniu.so
192.168.1.150 cdh04.aniu.so

# 同步密钥
for ip in $(awk '{print $1}' hosts.conf );do scp ~/.ssh/authorized_keys root@$ip:/root/.ssh ;done
或者使用
ssh-copy-id root@cdh01.aniu.so
ssh-copy-id root@cdh02.aniu.so
ssh-copy-id root@cdh03.aniu.so
ssh-copy-id root@cdh04.aniu.so
# 上面操作也需要在所有节点执行
```
- 5、使用cloudera-manger repo安装CM

```
# 在CM节点执行
wget http://archive.cloudera.com/cm5/redhat/6/x86_64/cm/cloudera-manager.repo -P /etc/yum.repos.d
wget https://archive.cloudera.com/cdh5/redhat/6/x86_64/cdh/cloudera-cdh5.repo -P /etc/yum.repos.d
# 
yum clean all && yum makecache # 建议执行不强制
yum install oracle-j2sdk1.7 -y
yum install cloudera-manager-daemons cloudera-manager-server -y

# 在其他节点执行
wget http://archive.cloudera.com/cm5/redhat/6/x86_64/cm/cloudera-manager.repo -P /etc/yum.repos.d
yum install oracle-j2sdk1.7 -y

# 配置JAVA_HOME
编辑vim /etc/profile
export JAVA_HOME=/usr/java/jdk1.7.0_67-cloudera
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
保存退出执行：
source /etc/profile 使更改的环境变量生效

# 在所有节点执行配置JAVA_HOME的操作
```

- 6、CM节点安装数据库，或使用已有的数据

```
# 笔者使用mysql57-community.repo,安装的mysql
[mysql57-community]
name=MySQL 5.7 Community Server
baseurl=http://repo.mysql.com/yum/mysql-5.7-community/el/6/$basearch/
enabled=1
gpgcheck=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-mysql
#
yum install mysql-community-embedded  mysql-community-server  mysql-community-devel mysql-community-client -y

# 笔者my.cnf
[root@cdh01 yum.repos.d]# cat /etc/my.cnf
[client]
port        = 3306
socket      = /var/lib/mysql/mysql.sock

[mysqld]
datadir     = /opt/mysql
socket      = /var/lib/mysql/mysql.sock
#skip-grant-tables 
skip-ssl
disable-partition-engine-check
port        = 3306
skip-external-locking
key_buffer_size = 16M
max_allowed_packet = 1M
table_open_cache = 64
sort_buffer_size = 512K
net_buffer_length = 8K
read_buffer_size = 256K
read_rnd_buffer_size = 512K
myisam_sort_buffer_size = 8M
thread_cache_size = 8
query_cache_size = 8M
tmp_table_size = 16M
performance_schema_max_table_instances = 500

explicit_defaults_for_timestamp = true
max_connections = 500
max_connect_errors = 100
open_files_limit = 8192

log-bin=mysql-bin
binlog_format=mixed
server-id   = 1
expire_logs_days = 10
early-plugin-load = ""

default_storage_engine          = InnoDB
innodb_file_per_table           = 1
innodb_data_home_dir            = /opt/mysql
innodb_data_file_path           = ibdata1:1024M;ibdata2:10M:autoextend
innodb_log_group_home_dir       = /opt/mysql
innodb_buffer_pool_size         = 16M
innodb_log_file_size            = 5M
innodb_log_buffer_size          = 8M
innodb_flush_log_at_trx_commit  = 1
innodb_lock_wait_timeout        = 50
innodb_log_files_in_group       = 3 
innodb_buffer_pool_size         = 12G
innodb_log_file_size            = 512M
innodb_log_buffer_size          = 256M
innodb_flush_log_at_trx_commit  = 2
innodb_lock_wait_timeout        = 150
innodb_open_files               = 600
innodb_max_dirty_pages_pct      = 50
innodb_file_per_table           = 1

[mysqldump]
quick
max_allowed_packet = 16M

[mysql]
no-auto-rehash

[myisamchk]
key_buffer_size = 20M
sort_buffer_size = 20M
read_buffer = 2M
write_buffer = 2M

[mysqlhotcopy]
xinteractive-timeout

symbolic-links=0
slow_query_log
long_query_time = 5
slow_query_log_file = /var/log/mysql-slow.log
log-error = /var/log/mysqld.log
pid-file = /var/run/mysqld/mysqld.pid

# 初始化mysql，并设置启动数据库设置root密码
/usr/sbin/mysqld --initialize --user=mysql --socket=/var/lib/mysql/mysql.sock # 先执行
mysql_secure_installation # 再执行

# 创建CM启动用到的数据库
mysql -u root -pAniuops123. -e "create database cmf DEFAULT CHARACTER SET utf8;"
mysql -u root -pAniuops123. -e "GRANT ALL PRIVILEGES ON `cmf`.* TO 'cmf'@'localhost' IDENTIFIED BY 'Aniunas123.'";"
```

- 启动cloudera-scm-server，并配置parcel

```
# 生成db配置文件
/usr/share/cmf/schema/scm_prepare_database.sh mysql cmf cmf Aniucmf123.

# 启动cloudera-scm-server
/etc/init.d/cloudera-scm-server start # 查看启动日志

# 配置parcel离线
cd /opt/cloudera/parcel-repo/ # 然后下载

wget http://archive.cloudera.com/cdh5/parcels/latest/CDH-5.13.1-1.cdh5.13.1.p0.2-el6.parcel
wget http://archive.cloudera.com/cdh5/parcels/latest/CDH-5.13.1-1.cdh5.13.1.p0.2-el6.parcel.sha1
wget http://archive.cloudera.com/cdh5/parcels/latest/manifest.json

# 注：读者根据cloudera当前CDH最新版本更改下载用到的URL
mv CDH-5.13.1-1.cdh5.13.1.p0.2-el6.parcel.sha1 CDH-5.13.1-1.cdh5.13.1.p0.2-el6.parcel.sha # 强制执行、默认使用本地的parcels包，不更改sha1,cloudera-scm-server启动安装时会去cloudera官网找匹配的parcel安装包

重启cloudera-scm-server，查看实时日志
/etc/init.d/cloudera-scm-server restart
tailf /var/log/cloudera-scm-server/cloudera-scm-server.log 
```

- 通过CM管理界面安装CDH，注意事项

```
# CM server启动成功即可通过http://192.168.1.137:7180访问，默认账户密码：admin admin

# **重点内容** 下面的话很重要：


不要勾选：单用户模式 ，笔者在此模式下安装多次都没成功，有心人可以测试
```

- 能一次性安装成功的最好，安装不成功建议多试几次，对初始化完成的虚拟机进行快照操作，便于恢复