# centos7 repo源安装ss服务并设置代理

## 安装shadowsocks-libev

```
wget https://copr.fedorainfracloud.org/coprs/librehat/shadowsocks/repo/epel-7/librehat-shadowsocks-epel-7.repo -P /etc/yum.repos.d/
yum install -y shadowsocks-libev
```

## 配置

```
{
    "server":"x.x.x.x",  # Shadowsocks服务器地址
    "server_port":1035,  # Shadowsocks服务器端口
    "local_address": "127.0.0.1", # 本地IP
    "local_port":1080,  # 本地端口
    "password":"password", # Shadowsocks连接密码
    "timeout":300,  # 等待超时时间
    "method":"aes-256-cfb",  # 加密方式
    "fast_open": false,  # true或false。开启fast_open以降低延迟，但要求Linux内核在3.7+
    "workers": 1  #工作线程数 
}

# 启动
[root@wanghui shadowsocks-libev]# systemctl start shadowsocks-libev 
[root@wanghui shadowsocks-libev]# systemctl enable shadowsocks-libev
Created symlink from /etc/systemd/system/multi-user.target.wants/shadowsocks-libev.service to /usr/lib/systemd/system/shadowsocks-libev.service.
```

- errors

/usr/bin/ss-server: error while loading shared libraries: libmbedcrypto.so.2: cannot open shared object file: No such file or directory

```
$ yum install mbedtls-devel
$ cd /usr/lib64
$ ls |grep mbed
$ ln -sf libmbedcrypto.so.1 libmbedcrypto.so.0

```