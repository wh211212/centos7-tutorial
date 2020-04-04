# centos7安装配置prometheus

## 更新系统&禁用selinux

```
yum update -y
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
#reboot 
```

## 下载prometheus安装包

- 去官网下载地址下载相关软件包：https://prometheus.io/download/

```
# 执行下面命令下载
wget https://github.com/prometheus/prometheus/releases/download/v2.12.0/prometheus-2.12.0.linux-amd64.tar.gz
```

## 配置prometheus

- 添加用户prometheus

```
useradd --no-create-home --shell /bin/false prometheus
```

- 创建必要的目录

```
mkdir /etc/prometheus
mkdir /var/lib/prometheus
```

- 改变目录权限

```
chown prometheus:prometheus /etc/prometheus
chown prometheus:prometheus /var/lib/prometheus
```

- 移动到下载Prometheus的目录，解压Prometheus 

```
tar -xvzf prometheus-2.8.1.linux-amd64.tar.gz
mv prometheus-2.8.1.linux-amd64 prometheuspackage
```

- 将“prometheus”和“promtool”二进制文件从“prometheuspackage”文件夹复制到“/usr/local/bin”

```
cp prometheuspackage/prometheus /usr/local/bin/
cp prometheuspackage/promtool /usr/local/bin/
```

- 更改prometheus/promtool属主

```
chown prometheus:prometheus /usr/local/bin/prometheus
chown prometheus:prometheus /usr/local/bin/promtool
```

- 将“consoles”和“console_libraries”目录从“prometheuspackage”复制到“/etc/prometheus文件夹”

```
cp -r prometheuspackage/consoles /etc/prometheus
cp -r prometheuspackage/console_libraries /etc/prometheus
```

- 将所有权更改为Prometheus用户

```
chown -R prometheus:prometheus /etc/prometheus/consoles
chown -R prometheus:prometheus /etc/prometheus/console_libraries
```

- 添加和修改Prometheus配置文件

```
vim /etc/prometheus/prometheus.yml

# 将以下配置添加到该文件中
global:
  scrape_interval: 10s

scrape_configs:
  - job_name: 'prometheus_master'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9090']

# 更改文件的所有权
chown prometheus:prometheus /etc/prometheus/prometheus.yml      
```

- 配置Prometheus service

```
vim /etc/systemd/system/prometheus.service

# 将以下内容复制到该文件
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
--config.file /etc/prometheus/prometheus.yml \
--storage.tsdb.path /var/lib/prometheus/ \
--web.console.templates=/etc/prometheus/consoles \
--web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
```

- 重新加载systemd服务&启动

```
systemctl daemon-reload
# 启动
systemctl start prometheus
# 查看状态
systemctl status prometheus
```

- 如果需要，添加防火墙规则

```
firewall-cmd --zone=public --add-port=9090/tcp --permanent
systemctl reload firewalld
```

## 访问Prometheus Web界面

- 使用以下Url访问UI

```
http://Server-IP:9090/graph
```

## 使用Prometheus监控Linux服务器

- 需要在Linux服务器上配置Prometheus node exporter

```
# 下载
wget https://github.com/prometheus/node_exporter/releases/download/v0.17.0/node_exporter-0.17.0.linux-amd64.tar.gz
```

- 解压node_exporter并进行相关配置

```
tar -xvzf node_exporter-0.17.0.linux-amd64.tar.gz

# 为node_exporter创建用户
useradd -rs /bin/false nodeusr

# 移动二进制文件
mv node_exporter-0.17.0.linux-amd64/node_exporter /usr/local/bin/
```

- 为节点导出器创建服务文件

```
vim /etc/systemd/system/node_exporter.service

# 将以下内容添加到该文件中
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=nodeusr
Group=nodeusr
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
```

- 重新加载系统守护程序

```
systemctl daemon-reload
systemctl start node_exporter
systemctl enable node_exporter
```
- 如果有需要，添加防火墙规则

```
firewall-cmd --zone=public --add-port=9100/tcp --permanent
systemctl restart firewalld
```

- 查看指标浏览节点导出程序URL

```
http://IP-Address:9100/metrics
```

- 在Prometheus Server上添加已配置的节点导出程序Target

```
vim /etc/prometheus/prometheus.yml

# 在scrape配置下添加以下配置
 - job_name: 'node_exporter_centos'
    scrape_interval: 5s
    static_configs:
      - targets: ['10.94.10.209:9100']
```

- 重启Prometheus服务

```
systemctl restart prometheus
```

- 登录Prometheus服务器Web界面，并检查目标

```
http://Prometheus-Server-IP:9090/targets
```
