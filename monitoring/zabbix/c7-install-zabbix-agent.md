# CentOS7安装zabbix

## 添加zabbix repo

rpm -i http://repo.zabbix.com/zabbix/3.0/rhel/7/x86_64/zabbix-release-3.0-1.el7.noarch.rpm
yum install zabbix-agent zabbix-get -y

ansible redis -a "systemctl start zabbix-agent"    
ansible redis -a "systemctl enable zabbix-agent"       

## 配置zabbix agent主动监控

