#!/bin/bash

# command from office website （https://docs.docker.com/）

# remove old docker
sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine

# config docker_ce repo
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
#sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum-config-manager --add-repo  https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

# install latest docker ce
sudo yum install docker-ce docker-ce-cli containerd.io -y 
sudo systemctl start docker && sudo systemctl enable docker

# use office shell

#curl -fsSL https://get.docker.com -o get-docker.
#sudo sh get-docker.sh



docker pull prom/node-exporter
docker pull grafana/grafana
docker pull prom/prometheus

# start node_exporter

docker run -d -p 9100:9100 \
  -v "/proc:/host/proc:ro" \
  -v "/sys:/host/sys:ro" \
  -v "/:/rootfs:ro" \
  --net="host" \
  prom/node-exporter



# start prometheus

mkdir /etc/prometheus

vim prometheus.yml

global:
  scrape_interval:     60s
  evaluation_interval: 60s
 
scrape_configs:
  - job_name: prometheus
    static_configs:
      - targets: ['localhost:9090']
        labels:
          instance: prometheus
 
  - job_name: linux
    static_configs:
      - targets: ['10.10.124.58:9100']
        labels:
          instance: localhost

docker run -d \
  -p 9090:9090 \
  -v /etc/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml  \
  prom/prometheus

# start grafana

mkdir /data/grafana-storage

docker run -d \
  -p 3000:3000 \
  --name=grafana \
  -v /data/grafana-storage:/var/lib/grafana \
  grafana/grafana


  # start elk

  grafana 3000
  prometheus 9090 9100
  consul 8500
  elastic 9200
  kibana 5601
  rancher 80/443

# start influxdb

docker run -p 8086:8086 -v /data/influxdb:/var/lib/influxdb influxdb

mkdir /etc/influxdb
docker run -p 8086:8086 \
      -v /data/influxdb/influxdb.conf:/etc/influxdb/influxdb.conf:ro \
      influxdb -config /etc/influxdb/influxdb.conf

 docker run --name=influxdb -d -p 8086:8086 -v /data/influxdb:/var/lib/influxdb -v /data/influxdb/influxdb.conf:/etc/influxdb/influxdb.conf:ro influxdb     
/data
 # start consul
 docker run -d --net=host -e 'CONSUL_LOCAL_CONFIG={"skip_leave_on_interrupt": true}' consul agent -server -bind=<external ip> -retry-join=<root agent ip> -bootstrap-expect=<number of server agents>


 docker run -p 8500:8500 -p 8600:8600/udp -v /data/consul:/etc/consul.d --name=consul consulconsul agent -server -bootstrap -ui -client=0.0.0.0 -advertise=10.10.124.58 -bind=10.10.124.58 -data-dir=/var/lib/consul -node=consul-1 -config-dir=/etc/consul.d
# dev
docker run -d --name=c1 -p 8500:8500 consul agent -dev -client=0.0.0.0 -bind=0.0.0.0
# prod

docker run -d --name=c1 -p 8500:8500 consul agent -server -bootstrap -ui -client=0.0.0.0 -bind=0.0.0.0 -node=consul-1

IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' c1); echo $IP
172.17.0.5

docker run -d -p 8500:8500 -p 8600:8600/udp --name=consul consul agent -server -bootstrap -ui -client=0.0.0.0

docker run -d -p 8500:8500 --name=consul consul agent -server -ui \
    -bind="10.10.124.58" \
    -client="0.0.0.0" \
    -bootstrap-expect="1"

docker run -d --name c2 consul agent -dev -bind=0.0.0.0 -join=$IP
