# ovirt节点直接使用virsh操作vm需要用户名密码

```
[root@ovirt4 ~]# virsh list vdsm@ovirt
error: unexpected data 'vdsm@ovirt'
[root@ovirt4 ~]# virsh list --all
Please enter your authentication name: vdsm@ovirt
Please enter your password: 
 Id    Name                           State
----------------------------------------------------
 3     vm-03                          running
 5     vm-04                          running
```

## 用户(vdsm@ovirt)获取

```
[root@ovirt3 ~]# find / -name libvirtconnection.py 
/usr/lib/python2.7/site-packages/vdsm/common/libvirtconnection.py
[root@ovirt3 ~]# egrep vdsm@ovirt /usr/lib/python2.7/site-packages/vdsm/common/libvirtconnection.py
SASL_USERNAME = "vdsm@ovirt"
```

## 密码(shibboleth)获取

```
[root@ovirt3 ~]# find / -name libvirt_password          
/etc/pki/vdsm/keys/libvirt_password
[root@ovirt3 ~]# cat /etc/pki/vdsm/keys/libvirt_password
shibboleth  #密码
```

> 备注：不建议使用：# saslpasswd2 -a libvirt admin 创建admin用户来管理vm，但可以使用