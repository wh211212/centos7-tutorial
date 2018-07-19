#  shell批量设置免密认证

> 实验背景：笔者想使用ansible同步一批虚拟机的配置，需要对这些虚拟机进行免密设置

- 实验所需文件及脚本如下图
![这里写图片描述](https://img-blog.csdn.net/20180712091333907?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3doMjExMjEy/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 生成ip列表

```
#!/bin/bash
####################################
# Function: generate ip list for use
####################################
# auther: shaobean@qq.com
# Changelog:
# 2018-07-11 wanghui initial
####################################
# set -x

# define ip Subnet

SUBNET=192.168.10.

for ip in `seq 20 25`;
  do
  echo "$SUBNET$ip" >> /root/ip.txt
  done

[ $? -eq 0 ] && echo "Generate Ip List Complete."
```

## 生成密码文件

```
#!/bin/bash
##########################################
# Function: generate password list for use
##########################################
# auther: shaobean@qq.com
# Changelog:
# 2018-07-11 wanghui initial
##########################################
# set -x

# define ip Subnet

PASSWORD=password

for pd in `seq 20 25`;
  do
  echo "$PASSWORD$pd" >> /root/password.txt
  done

[ $? -eq 0 ] && echo "Generate Password List Complete."
```

- 合并ip文件和密码文件

```
/usr/bin/paste -d: /root/ip.txt /root/password.txt > /root/ip-password.txt
```

- 笔者ip-password文件格式：

```
[root@wanghui ~]# cat ip-password.txt
192.168.10.20:211212
192.168.10.21:211212
192.168.10.22:211212
192.168.10.23:211212
192.168.10.24:211212
192.168.10.25:211212
# 由于笔者虚拟机初始密码都一样，这里为了实验方便，建议使用不同的密码
```

## 创建批量设置ssh免密认证脚本

```
#!/bin/bash  
#########################################################
# Functions: batch ssh free secret login
#########################################################
# Author: shaonbean@qq.com
# Changelog:
# 2018-07-11 wanghui initial create
#########################################################
# set -x

# generate ip-password.txt for paste_ip_password.sh

IP_PASSWORD=/root/ip-password.txt

# if expect exists

rpm -qa | grep expect >> /dev/null

if [ $? -eq 0 ];then
  echo "expect already install."
  else
  yum install expect -y
fi

# batch ssh Certification
for IP in $(cat $IP_PASSWORD)
  do
  ip=$(echo "$IP" | cut -f1 -d ":") 
  password=$(echo "$IP" | cut -f2 -d ":")
     
  # begin expect 
  expect -c "   
  spawn ssh-copy-id -i /root/.ssh/id_rsa.pub root@$ip  
        expect {   
                  \"*yes/no*\" {send \"yes\r\"; exp_continue}   
                  \"*password*\" {send \"$password\r\"; exp_continue}   
                  \"*Password*\" {send \"$password\r\";}   
        }   
    "   
  done   
     
# use ssh batch excute command
     
for hostip in $(cat $IP_PASSWORD | cut -f1 -d ":")  
    do  
    ssh root@$hostip 'uptime'    
    done  
```

- 本地重新生成ssh私钥公钥

```
[root@wanghui ~]# rm -rf .ssh/
[root@wanghui ~]# ssh-keygen -t rsa
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa): 
Created directory '/root/.ssh'.
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /root/.ssh/id_rsa.
Your public key has been saved in /root/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:+QrZGBOpZciJqG9QnDmT2d5wLDoJiuXLmob7avcWYFk root@wanghui.io
The key's randomart image is:
+---[RSA 2048]----+
|                 |
| o O E .         |
|o % X B          |
|+= X O . .       |
|= * + + S        |
| + o . * .       |
|. =   = . .      |
|.* . . . .       |
|B+o o.  .        |
+----[SHA256]-----+
```

## 执行脚本、批量设置免密认证

```
[root@wanghui ~]# bash batch_set_ssh_secret.sh 
expect already install.
spawn ssh-copy-id -i /root/.ssh/id_rsa.pub root@192.168.10.20
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/root/.ssh/id_rsa.pub"
The authenticity of host '192.168.10.20 (192.168.10.20)' can't be established.
ECDSA key fingerprint is SHA256:WV7KiVaITK4NnnYC1ebdmXg+QEmUAKtpD4bH0To7uPU.
ECDSA key fingerprint is MD5:f3:c9:59:14:cd:b1:bf:08:9e:cf:3a:cc:63:02:46:8b.
Are you sure you want to continue connecting (yes/no)? yes
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
root@192.168.10.20's password: 

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'root@192.168.10.20'"
and check to make sure that only the key(s) you wanted were added.

spawn ssh-copy-id -i /root/.ssh/id_rsa.pub root@192.168.10.21
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/root/.ssh/id_rsa.pub"
The authenticity of host '192.168.10.21 (192.168.10.21)' can't be established.
ECDSA key fingerprint is SHA256:WV7KiVaITK4NnnYC1ebdmXg+QEmUAKtpD4bH0To7uPU.
ECDSA key fingerprint is MD5:f3:c9:59:14:cd:b1:bf:08:9e:cf:3a:cc:63:02:46:8b.
Are you sure you want to continue connecting (yes/no)? yes
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
root@192.168.10.21's password: 

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'root@192.168.10.21'"
and check to make sure that only the key(s) you wanted were added.

spawn ssh-copy-id -i /root/.ssh/id_rsa.pub root@192.168.10.22
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/root/.ssh/id_rsa.pub"
The authenticity of host '192.168.10.22 (192.168.10.22)' can't be established.
ECDSA key fingerprint is SHA256:WV7KiVaITK4NnnYC1ebdmXg+QEmUAKtpD4bH0To7uPU.
ECDSA key fingerprint is MD5:f3:c9:59:14:cd:b1:bf:08:9e:cf:3a:cc:63:02:46:8b.
Are you sure you want to continue connecting (yes/no)? yes
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
root@192.168.10.22's password: 

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'root@192.168.10.22'"
and check to make sure that only the key(s) you wanted were added.

spawn ssh-copy-id -i /root/.ssh/id_rsa.pub root@192.168.10.23
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/root/.ssh/id_rsa.pub"
The authenticity of host '192.168.10.23 (192.168.10.23)' can't be established.
ECDSA key fingerprint is SHA256:DDyxtC8wq06dGmngNcX7xU4XprZ/WCz7vfVikiSUix8.
ECDSA key fingerprint is MD5:97:32:a0:7c:5a:59:06:f5:cf:f3:87:df:e0:e0:fb:b6.
Are you sure you want to continue connecting (yes/no)? yes
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
root@192.168.10.23's password: 

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'root@192.168.10.23'"
and check to make sure that only the key(s) you wanted were added.

spawn ssh-copy-id -i /root/.ssh/id_rsa.pub root@192.168.10.24
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/root/.ssh/id_rsa.pub"
The authenticity of host '192.168.10.24 (192.168.10.24)' can't be established.
ECDSA key fingerprint is SHA256:DDyxtC8wq06dGmngNcX7xU4XprZ/WCz7vfVikiSUix8.
ECDSA key fingerprint is MD5:97:32:a0:7c:5a:59:06:f5:cf:f3:87:df:e0:e0:fb:b6.
Are you sure you want to continue connecting (yes/no)? yes
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
root@192.168.10.24's password: 

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'root@192.168.10.24'"
and check to make sure that only the key(s) you wanted were added.

spawn ssh-copy-id -i /root/.ssh/id_rsa.pub root@192.168.10.25
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/root/.ssh/id_rsa.pub"
The authenticity of host '192.168.10.25 (192.168.10.25)' can't be established.
ECDSA key fingerprint is SHA256:DDyxtC8wq06dGmngNcX7xU4XprZ/WCz7vfVikiSUix8.
ECDSA key fingerprint is MD5:97:32:a0:7c:5a:59:06:f5:cf:f3:87:df:e0:e0:fb:b6.
Are you sure you want to continue connecting (yes/no)? yes
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
root@192.168.10.25's password: 

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'root@192.168.10.25'"
and check to make sure that only the key(s) you wanted were added.

 17:33:26 up 5 days, 23:55,  0 users,  load average: 0.15, 0.05, 0.06
 09:33:23 up 5 days, 23:56,  0 users,  load average: 0.00, 0.01, 0.05
 17:33:28 up 5 days, 23:56,  1 user,  load average: 0.00, 0.01, 0.05
 09:33:22 up 5 days, 23:38,  1 user,  load average: 0.08, 0.08, 0.10
 09:33:24 up 5 days, 23:38,  1 user,  load average: 0.01, 0.02, 0.05
 09:33:23 up 5 days, 23:38,  1 user,  load average: 0.00, 0.01, 0.05
```

- 到此通过shell批量设置ssh免密登录完成



