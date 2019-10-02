# install docker-compose

sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose


sudo chmod +x /usr/local/bin/docker-compose

sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

docker-compose --version

curl -L https://github.com/docker/compose/releases/download/1.24.1/docker-compose-Linux-x86_64 -o /usr/local/bin/docker-compose


version: '1.0'

services:
  prometheus:
    image: 'prom/prometheus'
    container_name: prometheus
    restart: unless-stopped
    ports:
    - '9090:9090'
    command:
    - '--config.file=/etc/prometheus/prometheus.yml'
    - '--storage.tsdb.path=/prometheus/data'
    - '--storage.tsdb.retention=90d'
    - '--web.enable-lifecycle'
    - '--web.console.libraries=/usr/share/prometheus/console_libraries'
    - '--web.console.templates=/usr/share/prometheus/consoles'
    volumes:
    - './etc/prometheus:/etc/prometheus:ro'
    - './data/prometheus:/prometheus/data'
    depends_on:
    - cadvisor
    networks:
    - samplenet
  cadvisor:
    image: google/cadvisor
    container_name: cadvisor
    ports:
    - '8081:8081'
    volumes:
    - '/:/rootfs:ro'
    - '/var/run:/var/run:rw'
    - '/sys:/sys:ro'
    - '/var/lib/docker/:/var/lib/docker:ro'
    networks:
    - samplenet
  alertmanager:
    image: prom/alertmanager
    ports:
    - '9093:9093'
    volumes:
    - './alertmanager/:/etc/alertmanager/'
    restart: always
    command:
    - '--config.file=/etc/alertmanager/config.yml'
    - '--storage.path=/alertmanager'
    networks:
    - samplenet
  node-exporter:
    image: prom/node-exporter
    volumes:
     - '/proc:/host/proc:ro'
     - '/sys:/host/sys:ro'
     - '/:/rootfs:ro'
    command:
     - '--path.procfs=/host/proc'
     - '--path.sysfs=/host/sys'
     - '--collector.filesystem.ignored-mount-points'
     - ^/(sys|proc|dev|host|etc|rootfs/var/lib/docker/containers|rootfs/var/lib/docker/overlay2|rootfs/run/docker/netns|rootfs/var/lib/docker/aufs)($$|/)
    ports:
     - '9100:9100'
    networks:
     - samplenet
    restart: always
  grafana:
    image: grafana/grafana
    depends_on:
    - prometheus
    ports:
    - '3000:3000'
    volumes:
    - './data/grafana:/var/lib/grafana'
    - './data/grafana/provisioning/:/etc/grafana/provisioning/'
    env_file:
    - ./grafana/config.monitoring
    networks:
    - samplenet
    restart: always
volumes:
grafana_data: {}
prometheus_data: {}


          args = [
            "--config.file=/etc/prometheus/prometheus.yml",
            "--storage.tsdb.path=/data",
            "--storage.tsdb.no-lockfile",
            "--storage.tsdb.min-block-duration=2h",
            "--storage.tsdb.max-block-duration=2h",
            "--storage.tsdb.retention.time=1d",
            "--web.enable-lifecycle",
            "--web.console.libraries=/etc/prometheus/console_libraries",
            "--web.console.templates=/etc/prometheus/consoles",
          ]