# centos7+docker+netdata+prometheus+grafana

## 默认docker已安装

- 参考：https://docs.netdata.cloud/backends/walkthrough/

- 创建自定义网络

docker network create --driver bridge netdata-tutorial

- 启动容器制定自定义的网络

docker run -it --name netdata --hostname netdata --network=netdata-tutorial -p 19999:19999  centos:latest '/bin/bash'

