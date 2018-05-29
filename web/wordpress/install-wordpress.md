# 要求

PHP7.2+ MySQL5.6+
HTTPS


- mariadb

[root@wanghui ~]# mysql -u root -p
Enter password: 
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 16
Server version: 10.3.7-MariaDB MariaDB Server

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> create database wordpress;
Query OK, 1 row affected (0.001 sec)

MariaDB [(none)]> grant all privileges on wordpress.* to wordpress@'localhost' identified by 'Wordpress123.';
Query OK, 0 rows affected (0.002 sec)

MariaDB [(none)]> flush privileges; 
Query OK, 0 rows affected (0.002 sec)

MariaDB [(none)]> exit 
Bye

grant all privileges on ss_manager.* to ss_manager@'localhost' identified by 'SSmanager123.';