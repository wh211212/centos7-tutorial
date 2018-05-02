# CentOS7安装erlang

构建大规模可扩展的软实时系统

- 解决方案：https://packages.erlang-solutions.com/erlang/

## 使用存储库安装

- 添加存储库条目

```
wget https://packages.erlang-solutions.com/erlang-solutions-1.0-1.noarch.rpm
rpm -Uvh erlang-solutions-1.0-1.noarch.rpm
```

- 添加Erlang解决方案密钥，请执行命令：

```
rpm --import https://packages.erlang-solutions.com/rpm/erlang_solutions.asc
```

- 手动创建源

```
[erlang-solutions]
name=CentOS $releasever - $basearch - Erlang Solutions
baseurl=https://packages.erlang-solutions.com/rpm/centos/$releasever/$basearch
gpgcheck=0 
gpgkey=https://packages.erlang-solutions.com/rpm/erlang_solutions.asc
enabled=1

# 更改为清华大学源
#将里面的baseurl 改为：baseurl=https://mirrors4.tuna.tsinghua.edu.cn/erlang-solutions/centos/7/
```

- 使用依赖关系添加存储库

sudo yum install erlang

