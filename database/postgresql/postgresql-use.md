# CentOS7 安装PostgreSQL

## 配置PostgreSQL源

```bash
# 安装postgresql96源
rpm -Uvh https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm

yum install postgresql96 -y
yum install postgresql96-server -y
# 初始化postgresql
/usr/pgsql-9.6/bin/postgresql96-setup initdb
```

- 初始化完成可以执行：启动

```bash
/usr/pgsql-9.6/bin/pg_ctl -D /var/lib/pgsql/9.6/data/ -l logfile start

systemctl enable postgresql-9.6
systemctl start postgresql-9.6
# 
systemctl restart postgresql-9.6
```

## postgres用户初始配置

# set password
# su - postgres 
-bash-4.2$ psql -c "alter user postgres with password 'password'" 
ALTER ROLE

## 配置远程连接PostgreSQL

> 需要修改data目录下的pg_hba.conf和postgresql.conf

- 编辑/var/lib/pgsql/9.6/data/pg_hba.conf
```bash
# 82行添加访问
TYPE  DATABASE        USER            ADDRESS                 METHOD
host    all             all             192.168.103.0/24        trust
# 
 METHOD can be "trust", "reject", "md5", "password", "gss", "sspi",
 46 # "ident", "peer", "pam", "ldap", "radius" or "cert". 
```

- 编辑/var/lib/pgsql/9.6/data/postgresql.conf

# 59行 localhost更改*
```bash
listen_addresses = '*' 
```
- 查看日志

```bash
tailf /var/lib/pgsql/9.6/data/pg_log
```
