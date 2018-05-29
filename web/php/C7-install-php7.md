# php7运行环境安装

- 添加remi源

```
# yum -y install http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
# sed -i -e "s/enabled=1/enabled=0/g" /etc/yum.repos.d/remi-safe.repo
# if [enabled=0], input a command to use the repository
# yum --enablerepo=remi-safe install [Package]
```

- 安装开发环境，依赖包

```
yum groupinstall "Development tools" -y
yum --enablerepo=remi-safe -y install php72-php-fpm php72-php-pear php72-php-mbstring php72-php-devel php72-php-json php72-php-xml php72-php-mbstring php72-php-pecl-redis php72-php-common php72-php-pecl-igbinary php72-php-pdo php72-php-pecl-mysql php72-php-devel php72-php-cli php72-php-pear php72-php-mysqlnd php72-php-gd
```

- 使用pecl安装功能模块

```
pecl install channel://pecl.php.net/mcrypt-1.0.1
```



https://pecl.php.net/get/event-2.3.0.tgz


pecl install channel://pecl.php.net/libevent-0.1.0

pecl install channel://pecl.php.net/event-2.3.0