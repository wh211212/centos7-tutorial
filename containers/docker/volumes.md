# docker change default root dir

## 停所有docker服务

docker stop $(docker ps -aq)

docker rm $(docker ps -aq)

docker rmi $(docker images -q)

# volume
// 删除所有的数据卷
docker volume rm $(docker volume ls -q)

// 停止所有的容器
docker stop $(docker ps -a -q)

// 删除所有的容器
docker rm $(docker ps -a -q)

# change docker root dir

{
    "graph": "/data/docker",
    "storage-driver": "overlay"
}

or

[Service]
ExecStart=/usr/bin/dockerd -H fd:// --data-root="/data/docker"3 

docker volume inspect my-vol

docker volume ls -f dangling=true

docker volume ls -q

docker volume prune

