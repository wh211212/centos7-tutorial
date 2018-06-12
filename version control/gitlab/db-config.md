# gitlab 数据库配置

- https://docs.gitlab.com/omnibus/settings/database.html

## 本机访问Gitlab的Postgresql

- 查看gitlab的postgresql配置文件

```
[root@yunwei-backup ~]# cat /var/opt/gitlab/gitlab-rails/etc/database.yml # 
# This file is managed by gitlab-ctl. Manual changes will be
# erased! To change the contents below, edit /etc/gitlab/gitlab.rb
# and run `sudo gitlab-ctl reconfigure`.

production:
  adapter: postgresql
  encoding: unicode
  collation: 
  database: gitlabhq_production //数据库名
  pool: 10
  username: "gitlab" //用户名
  password: 
  host: "/var/opt/gitlab/postgresql" //主机
  port: 5432
  socket: 
  sslmode: 
  sslrootcert: 
  sslca: 
  load_balancing: {"hosts":[]}
  prepared_statements: false
  statements_limit: 1000
  fdw: 
```

- 查看/etc/passwd中gitlab对应的系统用户

```
[root@yunwei-backup ~]# cat /etc/passwd | grep gitlab
gitlab-www:x:498:498::/var/opt/gitlab/nginx:/bin/false
git:x:497:497::/var/opt/gitlab:/bin/sh
gitlab-redis:x:496:496::/var/opt/gitlab/redis:/bin/false
gitlab-psql:x:495:495::/var/opt/gitlab/postgresql:/bin/sh //gitlab的postgresql用户
gitlab-prometheus:x:494:494::/var/opt/gitlab/prometheus:/bin/sh
```

## 根据上面的配置信息登陆postgresql数据库

```
[root@yunwei-backup ~]# cat /etc/passwd | grep gitlab 
gitlab-www:x:498:498::/var/opt/gitlab/nginx:/bin/false
git:x:497:497::/var/opt/gitlab:/bin/sh
gitlab-redis:x:496:496::/var/opt/gitlab/redis:/bin/false
gitlab-psql:x:495:495::/var/opt/gitlab/postgresql:/bin/sh
gitlab-prometheus:x:494:494::/var/opt/gitlab/prometheus:/bin/sh
[root@yunwei-backup ~]# su - gitlab-psql //登陆用户
-sh-4.1$ psql -h /var/opt/gitlab/postgresql -d gitlabhq_production //连接到gitlabhq_production库 
psql (9.6.5)
Type "help" for help.

gitlabhq_production=# \h //查看帮助命令
Available help:
  ABORT                            ALTER TYPE                       CREATE RULE                      DROP GROUP                       LOAD
  ALTER AGGREGATE                  ALTER USER                       CREATE SCHEMA                    DROP INDEX                       LOCK
  ALTER COLLATION                  ALTER USER MAPPING               CREATE SEQUENCE                  DROP LANGUAGE                    MOVE
  ALTER CONVERSION                 ALTER VIEW                       CREATE SERVER                    DROP MATERIALIZED VIEW           NOTIFY
  ALTER DATABASE                   ANALYZE                          CREATE TABLE                     DROP OPERATOR                    PREPARE
  ALTER DEFAULT PRIVILEGES         BEGIN                            CREATE TABLE AS                  DROP OPERATOR CLASS              PREPARE TRANSACTION
  ALTER DOMAIN                     CHECKPOINT                       CREATE TABLESPACE                DROP OPERATOR FAMILY             REASSIGN OWNED
  ALTER EVENT TRIGGER              CLOSE                            CREATE TEXT SEARCH CONFIGURATION DROP OWNED                       REFRESH MATERIALIZED VIEW
  ALTER EXTENSION                  CLUSTER                          CREATE TEXT SEARCH DICTIONARY    DROP POLICY                      REINDEX
  ALTER FOREIGN DATA WRAPPER       COMMENT                          CREATE TEXT SEARCH PARSER        DROP ROLE                        RELEASE SAVEPOINT
  ALTER FOREIGN TABLE              COMMIT                           CREATE TEXT SEARCH TEMPLATE      DROP RULE                        RESET
  ALTER FUNCTION                   COMMIT PREPARED                  CREATE TRANSFORM                 DROP SCHEMA                      REVOKE
  ALTER GROUP                      COPY                             CREATE TRIGGER                   DROP SEQUENCE                    ROLLBACK
  ALTER INDEX                      CREATE ACCESS METHOD             CREATE TYPE                      DROP SERVER                      ROLLBACK PREPARED
  ALTER LANGUAGE                   CREATE AGGREGATE                 CREATE USER                      DROP TABLE                       ROLLBACK TO SAVEPOINT
  ALTER LARGE OBJECT               CREATE CAST                      CREATE USER MAPPING              DROP TABLESPACE                  SAVEPOINT
  ALTER MATERIALIZED VIEW          CREATE COLLATION                 CREATE VIEW                      DROP TEXT SEARCH CONFIGURATION   SECURITY LABEL
  ALTER OPERATOR                   CREATE CONVERSION                DEALLOCATE                       DROP TEXT SEARCH DICTIONARY      SELECT
  ALTER OPERATOR CLASS             CREATE DATABASE                  DECLARE                          DROP TEXT SEARCH PARSER          SELECT INTO
  ALTER OPERATOR FAMILY            CREATE DOMAIN                    DELETE                           DROP TEXT SEARCH TEMPLATE        SET
  ALTER POLICY                     CREATE EVENT TRIGGER             DISCARD                          DROP TRANSFORM                   SET CONSTRAINTS
  ALTER ROLE                       CREATE EXTENSION                 DO                               DROP TRIGGER                     SET ROLE
  ALTER RULE                       CREATE FOREIGN DATA WRAPPER      DROP ACCESS METHOD               DROP TYPE                        SET SESSION AUTHORIZATION
  ALTER SCHEMA                     CREATE FOREIGN TABLE             DROP AGGREGATE                   DROP USER                        SET TRANSACTION
  ALTER SEQUENCE                   CREATE FUNCTION                  DROP CAST                        DROP USER MAPPING                SHOW
  ALTER SERVER                     CREATE GROUP                     DROP COLLATION                   DROP VIEW                        START TRANSACTION
  ALTER SYSTEM                     CREATE INDEX                     DROP CONVERSION                  END                              TABLE
  ALTER TABLE                      CREATE LANGUAGE                  DROP DATABASE                    EXECUTE                          TRUNCATE
  ALTER TABLESPACE                 CREATE MATERIALIZED VIEW         DROP DOMAIN                      EXPLAIN                          UNLISTEN
  ALTER TEXT SEARCH CONFIGURATION  CREATE OPERATOR                  DROP EVENT TRIGGER               FETCH                            UPDATE
  ALTER TEXT SEARCH DICTIONARY     CREATE OPERATOR CLASS            DROP EXTENSION                   GRANT                            VACUUM
  ALTER TEXT SEARCH PARSER         CREATE OPERATOR FAMILY           DROP FOREIGN DATA WRAPPER        IMPORT FOREIGN SCHEMA            VALUES
  ALTER TEXT SEARCH TEMPLATE       CREATE POLICY                    DROP FOREIGN TABLE               INSERT                           WITH
  ALTER TRIGGER                    CREATE ROLE                      DROP FUNCTION                    LISTEN 
gitlabhq_production=# \l //查看数据库
                                             List of databases
        Name         |    Owner    | Encoding |   Collate   |    Ctype    |        Access privileges        
---------------------+-------------+----------+-------------+-------------+---------------------------------
 gitlabhq_production | gitlab      | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 postgres            | gitlab-psql | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 template0           | gitlab-psql | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/"gitlab-psql"               +
                     |             |          |             |             | "gitlab-psql"=CTc/"gitlab-psql"
 template1           | gitlab-psql | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/"gitlab-psql"               +
                     |             |          |             |             | "gitlab-psql"=CTc/"gitlab-psql"
(4 rows)
gitlabhq_production=# \q //退出
-sh-4.1$ exit
logout
You have new mail in /var/spool/mail/root
```

