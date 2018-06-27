#!/usr/bin/env bash
# ----------------------------------------
# Functions: onekey install redis cluster
# Auther: shaonbean@qq.com
# Changelog:
# 2018-06-15 wanghui initial
# ----------------------------------------
# define some variables
redis_cluster_ip=`ifconfig | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}'`
version=4.0.9

yum update -y && yum groupinstall -y "Development Tools" && yum -y install tcl

wget http://download.redis.io/releases/redis-$version.tar.gz -P /usr/local/src