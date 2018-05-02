# 配置SSH免密登录

- 为yunwei创建密钥对，

[yunwei@wanghui ~]$  ssh-keygen -t rsa
Generating public/private rsa key pair.
Enter file in which to save the key (/home/yunwei/.ssh/id_rsa): 
Created directory '/home/yunwei/.ssh'.
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/yunwei/.ssh/id_rsa.
Your public key has been saved in /home/yunwei/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:dd9J3hk98AgcpHE4XOy21jWMvkQ87xDL7dol0nGzSJ0 yunwei@wanghui.io
The key's randomart image is:
+---[RSA 2048]----+
|        ..**..   |
|         ++o. + .|
|         .+ o.o=.|
|         . + B+=B|
|        S . *.XE=|
|           o.O.=o|
|          . o.B..|
|             o.+.|
|             ... |
+----[SHA256]-----+

mv ~/.ssh/id_rsa.pub ~/.ssh/authorized_keys 
chmod 600 ~/.ssh/authorized_keys 

上面操作是在统一服务器上设置ssh免密认证，第一次ssh登录时，需要密码 第二次就不需要啦


## 不同服务器上，为yunwei设置免密登录

- 在server2上，yunwei用户下执行

ssh-keygen -t rsa # 会自动生成.ssh目录 

或者手动创建：

mkdir ~/.ssh 

chmod 700 ~/.ssh

- 拷贝server1上，yunwei用户的公钥

[yunwei@ecs-07 ~]$ scp yunwei@192.168.0.111:/home/yunwei/.ssh/id_rsa.pub ~/.ssh/id_rsa.pub_key
yunwei@192.168.0.111's password: 
id_rsa.pub  


cat ~/.ssh/id_rsa.pub_key >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

- 到server1上，在yunwei上 ssh登录到server2

[yunwei@wanghui ~]$ ssh yunwei@192.168.0.110 # server1
The authenticity of host '192.168.0.110 (192.168.0.110)' can't be established.
ECDSA key fingerprint is SHA256:PMh21nLllg43mGbQ4lGswPBv8pFkESckgTyLWxNzM8g.
ECDSA key fingerprint is MD5:45:4a:3f:61:c6:57:d5:38:1d:03:cf:a9:3d:7c:8d:38.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '192.168.0.110' (ECDSA) to the list of known hosts.
Last login: Sat Apr 28 22:55:59 2018 from 192.168.0.51
[yunwei@ecs-07 ~]$  # server2



