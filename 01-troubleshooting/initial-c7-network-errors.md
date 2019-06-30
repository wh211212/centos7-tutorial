# 初始化centos7 时，使用nmcli d 查看网络设备报错如下：

```
[root@localhost ~]# nmcli d
Error: Could not create NMClient object: GDBus.Error:org.freedesktop.DBus.Error.UnknownMethod: Method "GetManagedObjects" with signature "" on interface "org.freedesktop.DBus.ObjectManager" doesn't exist

```

- 解决：重启NetworkManager服务

```
systemctl restart NetworkManager 

[root@localhost ~]# nmcli d 
DEVICE  TYPE      STATE        CONNECTION 
em1     ethernet  connected    em1        
em2     ethernet  unavailable  --         
lo      loopback  unmanaged    --  
```