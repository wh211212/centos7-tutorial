# 搬瓦工VPS安装ShadowSocks服务

## CentOS7 Install ShadowSocks 

- 推荐：wget --no-check-certificate -O shadowsocks-libev-debian.sh https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocks-libev-debian.sh

- 添加epel源

```
yum update -y && yum install python-pip -y  

pip install shadowsocks

# 编辑配置文件
cat /etc/shadowsocks-libev/config.json 
{
    "server":"0.0.0.0",
    "server_port":8888,
    "local_port":1080,
    "password":"nrmzRbYCHJvXEPLN",
    "timeout":60,
    "method":"aes-256-cfb"
}
```

- 启动shadowsocks服务

```
systemctl start shadowsocks-libev
systemctl status shadowsocks-libev
systemctl enable shadowsocks-libev
```

- 防火墙设置

```
firewall-cmd --permanent --add-port=8888/tcp
firewall-cmd --permanent --add-port=8888/udp
firewall-cmd --reload

# ssh端口
firewall-cmd --permanent --add-port=27043/tcp
```



## 报错解决

- /usr/bin/ss-server: error while loading shared libraries: libmbedcrypto.so.0: cannot open shared object file: No such file or directory

```
cd /usr/lib64
ln -s libmbedcrypto.so.1 libmbedcrypto.so.0
```

- 参考：http://radzhang.iteye.com/blog/2414919



## 使用repo安装shadsocks

- https://copr.fedorainfracloud.org/coprs/librehat/shadowsocks/
- https://github.com/shadowsocks/shadowsocks-libev

- 配置


wget https://copr.fedorainfracloud.org/coprs/librehat/shadowsocks/repo/epel-7/librehat-shadowsocks-epel-7.repo

yum install gcc gettext autoconf libtool automake make pcre-devel asciidoc xmlto c-ares-devel libev-devel libsodium-devel mbedtls-devel -y

yum install shadowsocks-libev

# Edit the configuration file
sudo vim /etc/shadowsocks-libev/config.json

# Edit the default configuration for debian
sudo vim /etc/default/shadowsocks-libev

# Start the service
sudo /etc/init.d/shadowsocks-libev start    # for sysvinit, or
sudo systemctl start shadowsocks-libev      # for systemd


cd /usr/lib/node_modules/shadowsocks-manager/
npm install sqlite3 --save

=

