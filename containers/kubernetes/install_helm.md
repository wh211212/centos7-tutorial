#  helm 安装与使用

- 参考：https://helm.sh/docs/using_helm/#installing-helm
- https://blog.csdn.net/bbwangj/article/details/81087911
- https://www.hi-linux.com/posts/21466.html

## 安装helm

- 一键安装

```
curl -L https://git.io/get_helm.sh | bash
```

- 二进制安装

```
#从官网下载最新版本的二进制安装包到本地：https://github.com/kubernetes/helm/releases
tar -zxvf helm-v2.14.1-linux-amd64.tgz # 解压压缩包
# 把 helm 指令放到bin目录下
mv linux-amd64/helm /usr/local/bin/helm
helm help # 验证
```

- 源码安装

```
$ cd $GOPATH
$ mkdir -p src/k8s.io
$ cd src/k8s.io
$ git clone https://github.com/helm/helm.git
$ cd helm
$ make bootstrap build
```

## 安装TILLER

- 