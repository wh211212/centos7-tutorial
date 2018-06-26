# CentOS7 yum安装mariadb

- 参考：https://mariadb.com/kb/en/library/yum/
- https://downloads.mariadb.org/mariadb/repositories/#mirror=neusoft

## 添加MariaDB YUM存储库

echo '[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.3/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
' | sudo tee /etc/yum.repos.d/MariaDB.repo


sudo yum install MariaDB-server MariaDB-client

systemctl start mariadb
systemctl enable mariadb

- 初始化

mysql_secure_installation 
