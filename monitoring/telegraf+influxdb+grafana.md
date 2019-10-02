# 使用InfluxDB，Grafana和Telegraf监控Docker环境

## 安装Grafana

- 创建持久存储卷，确保在销毁并重新创建grafana docker以进行升级时，将保留应用的配置

mkdir /data/grafana-storage 

docker run -d --name=grafana -p 3000:3000 --name=grafana -v /data/grafana-storage:/var/lib/grafana grafana/grafana


- 安装插件

grafana-cli plugins ls | grep -v Restart | grep -v installed | awk '{print $1}'            
alexanderzobnin-zabbix-app
grafana-clock-panel
grafana-kubernetes-app
grafana-piechart-panel
grafana-simple-json-datasource
grafana-worldmap-panel
michaeldmoore-annunciator-panel


docker run -d --name node-exporter \
  -v "/proc:/host/proc" \
  -v "/sys:/host/sys" \
  -v "/:/rootfs" \
  --net="host" \
  prom/node-exporter:latest \
    -collector.procfs /host/proc \
    -collector.sysfs /host/sys \
    -collector.filesystem.ignored-mount-points "^/(sys|proc|dev|host|etc)($|/)"