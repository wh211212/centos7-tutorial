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
