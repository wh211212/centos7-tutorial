# ovirt guest agent 安装

## CentOS

- 如何在CentOS中安装guest代理(CentOS7)

```
# 通过终端使用YUM来安装oVirt Guest Tools
sudo yum install centos-release-ovirt42
sudo yum install ovirt-guest-agent-common
```

- CentOS6

```
sudo yum install centos-release-ovirt36
yum install ovirt-guest-agent -y
/etc/init.d/ovirt-guest-agent start
chkconfig ovirt-guest-agent on
```

- 开始服务

```
sudo systemctl enable --now ovirt-guest-agent.service
```

- 查看状态排错

```
sudo systemctl status ovirt-guest-agent.service
```

## Debian

- 如何在Debian中安装guest代理

```
# 使用apt-get通过终端安装oVirt Guest Tools
 # echo "deb http://download.opensuse.org/repositories/home:/evilissimo:/deb/Debian_7.0/ ./" >> /etc/apt/sources.list
 # gpg -v -a --keyserver http://download.opensuse.org/repositories/home:/evilissimo:/deb/Debian_7.0/Release.key --recv-keys D5C7F7C373A1A299
 # gpg --export --armor 73A1A299 | apt-key add -
 # apt-get update
 # apt-get install ovirt-guest-agent

# 使用gnome中的添加/删除软件安装oVirt Guest Tools
```

- 开始服务

```
#su -
#service ovirt-guest-agent enable &&  service ovirt-guest-agent start
```

- 查看状态排错

```
# su -
# service ovirt-guest-agent start
```

## Ubuntu

- 如何在Ubuntu中安装guest代理(Ubuntu 16.04)

```
# 使用apt-get通过终端安装oVirt Guest Tools
# sudo nano -w /etc/apt/sources.list.d/ovirt-guest-agent.list
deb http://download.opensuse.org/repositories/home:/evilissimo:/ubuntu:/16.04/xUbuntu_16.04/ /
# wget http://download.opensuse.org/repositories/home:/evilissimo:/ubuntu:/16.04/xUbuntu_16.04//Release.key
# sudo apt-key add - < Release.key  
# sudo apt-get update
# sudo apt-get install ovirt-guest-agent
```

- 开始服务

安装程序将自动启动ovirt-guest-agent并将其设置为在启动时自动启动。

- 参考链接：https://www.ovirt.org/documentation/how-to/guest-agent/




