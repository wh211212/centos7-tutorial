# CentOS7安装使用svn

## 安装版本控制工具Subversion

- 安装Subversion

```
[root@vm-06 ~]# yum -y install subversion
```

- 创建一个存储库。例如，笔者这里创建“/var/svn/repos/project”

```
[root@vm-06 ~]# mkdir -p /var/svn/repos/project 
[root@vm-06 ~]# svnadmin create /var/svn/repos/project
[root@vm-06 ~]# svn mkdir file:///var/svn/repos/project/trunk -m "create"

Committed revision 1.
[root@vm-06 ~]# svn mkdir file:///var/svn/repos/project/branches -m "create" 

Committed revision 2.
[root@vm-06 ~]# svn mkdir file:///var/svn/repos/project/tags -m "create"

Committed revision 3.
```

- 如果存在一些开发文件，可以将其导入到存储库。例如，将“/home/project”下的文件导入上面的存储库。

```
[root@vm-06 ~]# svn import /home/project file:///var/svn/repos/project/trunk -m "initial import"
Adding         /home/project/index.html
Adding         /home/project/readme.md
Adding         /home/project/index.php

Committed revision 4.
[root@vm-06 ~]# svn list file:///var/svn/repos/project/trunk 
index.html
index.php
readme.md
```

- 可以从其他客户端访问以运行svnserve。 svnserve监听3690 / TCP，

```
# vm-05上测试
# yum -y install subversion
[root@vm-05 ~]# svn list svn://192.168.1.124/repos/project
branches/
tags/
trunk/
[root@vm-05 ~]# svn checkout svn://192.168.1.124/repos/project
A    project/tags
A    project/trunk
A    project/trunk/index.html
A    project/trunk/readme.md
A    project/trunk/index.php
A    project/branches
Checked out revision 4.
```

- 可以在没有svnserve的情况下使用SSH进行访问

```
# vm-06上停止systemctl stop svnserve 
[root@vm-05 ~]# svn list svn+ssh://root@192.168.1.124/var/svn/repos/project
root@192.168.1.124's password: 
branches/
tags/
trunk/
```

## 权限控制

- 在“/var/svn/repos/project”上设置访问控制

```
[root@dlp ~]# vi /var/svn/repos/project/conf/svnserve.conf
# 第9行添加：
[general]
anon-access = none
# 28行取消注释
password-db = passwd
# 35行取消注释
authz-db = authz

[root@dlp ~]# vi /var/svn/repos/project/conf/passwd
# 针对这个项目定义用户名和密码
[users]
redhat = password
cent = password
fedora = password
[root@dlp ~]# vi /var/svn/repos/project/conf/authz
# 定义用户组合用户
[groups]
developer = redhat,cent
# 允许developer对项目进行读写
[/]
@developer = rw
# 允许在Fedora用户的trunk文件夹上读
[/trunk]
fedora = r
```

- 确保从客户端访问

```
# vm-05上操作
[root@vm-05 ~]# cd /root/project/trunk
[root@vm-05 trunk]# svn --username yunwei list svn://192.168.1.124/repos/project/trunk
Authentication realm: <svn://192.168.1.124:3690> 7f142303-72cf-45df-9261-ae3f50870db9
Password for 'yunwei': 

-----------------------------------------------------------------------
ATTENTION!  Your password for authentication realm:

   <svn://192.168.1.124:3690> 7f142303-72cf-45df-9261-ae3f50870db9

can only be stored to disk unencrypted!  You are advised to configure
your system so that Subversion can store passwords encrypted, if
possible.  See the documentation for details.

You can avoid future appearances of this warning by setting the value
of the 'store-plaintext-passwords' option to either 'yes' or 'no' in
'/root/.subversion/servers'.
-----------------------------------------------------------------------
Store password unencrypted (yes/no)? yes
index.html
index.php
readme.md
```
