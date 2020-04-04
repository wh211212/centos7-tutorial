#!/bin/bash

# netwoprk add-on Calico

kubeadm init --image-repository registry.aliyuncs.com/google_containers --kubernetes-version v1.15.0 --pod-network-cidr=192.168.0.0/16 --token-ttl 0

kubeadm join 192.168.1.103:6443 --token dse5zn.usj4nqvu069a7sgk \
    --discovery-token-ca-cert-hash sha256:4034c8478d1f39b873d5f661f156b911a39ce1d5081b88e54e1c08dda453d63d 

# warnings

vim /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

# node install

docker install

