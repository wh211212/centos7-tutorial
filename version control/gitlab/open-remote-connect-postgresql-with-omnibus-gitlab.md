# Omnibus-GitLab 配置 PostgreSQL 开启远程访问

- https://gitlab.com/gitlab-org/omnibus-gitlab/blob/master/doc/settings/database.md

# 如何访问GitLab默认安装的PostgreSQL数据库

> http://www.huangzhongzhang.cn/ru-he-fang-wen-gitlab-mo-ren-an-zhuang-de-postgresql.html

# 新建用户并赋权

sudo psql -h /var/opt/gitlab/postgresql -d gitlabhq_prod;
