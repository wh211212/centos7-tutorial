# 在CentOS/RHEL7上禁用IPv6

- 在内核模块中禁用IPv6（需要重启）
- 使用sysctl设置禁用IPv6（无需重新启动）

## 在内核模块中禁用IPv6

- 编辑/etc/default/grub并在行GRUB_CMDLINE_LINUX中添加ipv6.disable = 1，如下：

```
# cat /etc/default/grub
GRUB_TIMEOUT=5
GRUB_DEFAULT=saved
GRUB_DISABLE_SUBMENU=true
GRUB_TERMINAL_OUTPUT="console"
GRUB_CMDLINE_LINUX="ipv6.disable=1 crashkernel=auto rhgb quiet"
GRUB_DISABLE_RECOVERY="true"
```

- 重新生成GRUB配置文件并覆盖现有文件

```
grub2-mkconfig -o /boot/grub2/grub.cfg 
shutdown -r now

# 重启之后查看ipv6模块
ip addr show | grep net6
```

## 使用sysctl设置禁用IPv6

- 在/etc/sysctl.conf中添加以下行

```
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1

# 或者执行
sed -i '$ a\net.ipv6.conf.all.disable_ipv6 = 1\nnet.ipv6.conf.default.disable_ipv6 = 1' /etc/sysctl.conf
```

- 要使设置生效，请执行

```
sysctl -p
```

> 确保文件/etc/ssh/sshd_config包含AddressFamily inet行，以避免在使用sysctl方法时破坏SSH Xforwarding

- 将AddressFamily行添加到sshd_config

```
sed -i '$ a\AddressFamily inet' /etc/ssh/sshd_config
systemctl restart sshd
```

- 参考：https://www.thegeekdiary.com/centos-rhel-7-how-to-disable-ipv6/