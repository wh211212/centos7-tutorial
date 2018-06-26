# CentOS7安装IT资产管理系统

## Snipe-IT介绍

- 资产管理工具
- Github：https://github.com/snipe/snipe-it
- 官网：https://snipeitapp.com/
- Demo：https://demo.snipeitapp.com/

## 安装要求

- 系统要求（https://snipe-it.readme.io/docs/requirements）：笔者环境：2vcpu 4G mem 20G /

| Hostname      | Role             | IP            |
| ------------- |:----------------:| -------------:|
| snipeit.aniu.so | snipeit | 192.168.0.220 |

| PHP version      | MySQL version             |   snipeit version         |
| ------------- |:----------------:| -------------:|
| 7.2.7 | 5.7 | 4.4.1 | v4.4.2 - build 3666 |


- 系统更新

```
sudo yum -y install epel-release
sudo yum update -y
```

- 下载http或nginx

```
# 笔者使用nginx
echo '[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=0
enabled=1
' | sudo tee /etc/yum.repos.d/nginx.repo

sudo yum install nginx -y
systemctl start nginx
systemctl enable nginx
```

- 下载php

```
# 配置remi源
sudo yum -y install http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
sudo sed -i -e "s/enabled=1/enabled=0/g" /etc/yum.repos.d/remi-safe.repo

# 下载php
yum --enablerepo=remi-safe -y install php72 php72-php-fpm php72-php-pear php72-php-openssl php72-php-pdo php72-php-mbstring php72-php-tokenizer php72-php-curl php72-php-mysql php72-php-ldap php72-php-zip php72-php-fileinfo php72-php-gd php72-php-dom php72-php-mcrypt php72-php-bcmath
scl enable php72 bash 
[root@ops-01 ~]# scl enable php72 bash 
[root@ops-01 ~]# php -v
PHP 7.2.7 (cli) (built: Jun 20 2018 07:26:08) ( NTS )
Copyright (c) 1997-2018 The PHP Group
Zend Engine v3.2.0, Copyright (c) 1998-2018 Zend Technologies
# 写到环境变量
[root@ops-01 ~]# vi /etc/profile.d/php72.sh # 记得做
#!/bin/bash
source /opt/remi/php72/enable
export X_SCLS="`scl enable php72 'echo $X_SCLS'`" 
```

- 下载数据库（MySQL/MariaDB）

```
# 参考：https://blog.csdn.net/wh211212/article/details/62881670，笔者这里使用之前安装过的mysql，就不单独描述安装过程
```

- 创建Snipe-IT数据库

```
# 登录数据库
sudo mysql -u root -p

mysql> create database snipeit;
mysql> grant all on snipeit.* to 'snipe_user'@'192.168.0.%' identified by 'Aniusnipeit123.';
mysql> flush privileges;
```

- 安装Composer

```
# 使用以下命令安装Composer,Composer是PHP的依赖管理器
[root@ops-01 ~]# curl -sS https://getcomposer.org/installer | php
All settings correct for using Composer
Downloading...

Composer (version 1.6.5) successfully installed to: /root/composer.phar
Use it: php composer.phar

[root@ops-01 ~]# mv /root/composer.phar /usr/bin/composer
```

- 安装Snipe-IT

```
# 安装git
[root@ops-01 ~]# cd /data/
[root@ops-01 data]# sudo git clone https://github.com/snipe/snipe-it snipeit # 笔者克隆的时候特别慢。笔者直接下载的源代码

# 从提供的示例文件创建.env文件
cd /data/snipeit
sudo cp .env.example .env

# 编辑.env文件，根据提供的说明找到以下行并修改
# REQUIRED: BASIC APP SETTINGS
# --------------------------------------------
APP_ENV=production
APP_DEBUG=false # 排错的时候这个改为true
APP_URL=192.168.0.220
APP_TIMEZONE='Asia/Shanghai'


# --------------------------------------------
# REQUIRED: DATABASE SETTINGS
# --------------------------------------------
DB_CONNECTION=mysql
DB_HOST=192.168.0.222
DB_DATABASE=snipeit
DB_USERNAME=snipe_user
DB_PASSWORD=Aniusnipeit123.
DB_PREFIX=null
DB_DUMP_PATH='/usr/bin'
DB_CHARSET=utf8mb4
DB_COLLATION=utf8mb4_unicode_ci



[root@ops-01 snipeit]# php artisan key:generate
**************************************
*     Application In Production!     *
**************************************

 Do you really wish to run this command? (yes/no) [no]:
 > yes

Application key [base64:yRuvb8BjQhuBDo6tYRToAbQ8PwiIKt0xko2TOVk5QqM=] set successfully.
```

- 权限设置

```
# /data/snipeit
cd /data/snipeit
chown -R nginx:nginx 
chmod -R 755 storage
chmod -R 755 public/uploads
```

- COMPOSER (这一步会执行很久)
```
cd ~
curl - sS https://getcomposer.org/installer | php
sudo mv composer.phar /data/snipeitsnipe-it
php composer.phar install --no - dev --prefer - source
```

- APP_KEY

```
[root@ops-01 snipeit]# php artisan key:generate
**************************************
*     Application In Production!     *
**************************************

 Do you really wish to run this command? (yes/no) [no]:
 > yes

Application key [base64:yRuvb8BjQhuBDo6tYRToAbQ8PwiIKt0xko2TOVk5QqM=] set successfully.
```

- nginx 配置

```
[root@ops-01 conf.d]# cat snipeit.aniu.so.conf 
server {
    listen 80;
    server_name snipeit.aniu.so;

    root /data/snipeit/public;
    index index.php index.html index.htm;
    access_log /var/log/nginx/snipeit/snipeit.aniu.so.access.log  main;
    error_log /var/log/nginx/snipeit/snipeit.aniu.so.error.log;  
    
    location =/.env{ 
        return 404; 
    } 

    location / {
        try_files $uri $uri/ /index.php$is_args$args;
    }

    location ~ \.php$ {
        root /data/snipeit/public;
        try_files $uri $uri/ =404;
        fastcgi_pass phpfpm-pool;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
}
# 具体优化参数在nginx.conf配置
```

- 通过浏览器访问：




- 参考：https://psathul.wordpress.com/2018/05/21/snipe-it-in-centos-7-using-nginx/




