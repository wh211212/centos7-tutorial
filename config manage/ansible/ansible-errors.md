# 使用普通用户进行ansible分发

[yunwei@wanghui ~]$ ansible web -m command -a "ls -l /home/yunwei"
[DEPRECATION WARNING]: DEFAULT_SUDO_USER option, In favor of Ansible Become, which is a generic framework. See become_user. , use become instead. This feature will be removed in version 2.8. 
Deprecation warnings can be disabled by setting deprecation_warnings=False in ansible.cfg.

## 编辑sudo vim /etc/ansible/ansible.cfg,注释#sudo_user      = yunwei，执行ansible时添加--become-user=yunwei参数

[yunwei@wanghui ~]$ ansible web -m command -a "ls -l /home/yunwei" --become-user=yunwei 
192.168.0.51 | SUCCESS | rc=0 >>
total 0
-rw------- 1 yunwei yunwei 0 Apr 28 15:06 test.conf

192.168.0.50 | SUCCESS | rc=0 >>
total 0
-rw------- 1 yunwei yunwei 0 Apr 28 15:06 test.conf


