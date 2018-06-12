# docker运行jenkins

## 安装

[root@vm-06 ~]# docker verison 
docker: 'verison' is not a docker command.
See 'docker --help'
[root@vm-06 ~]# docker version
Client:
 Version:      18.03.1-ce
 API version:  1.37
 Go version:   go1.9.5
 Git commit:   9ee9f40
 Built:        Thu Apr 26 07:20:16 2018
 OS/Arch:      linux/amd64
 Experimental: false
 Orchestrator: swarm

Server:
 Engine:
  Version:      18.03.1-ce
  API version:  1.37 (minimum version 1.12)
  Go version:   go1.9.5
  Git commit:   9ee9f40
  Built:        Thu Apr 26 07:23:58 2018
  OS/Arch:      linux/amd64
  Experimental: false


## 使用docker直接运行jenkins

- 参考：https://docs.docker.com/samples/library/jenkins/
- https://github.com/jenkinsci/docker




docker run -d -p 8080:8080 -p 50000:50000 --env JAVA_OPTS="-Djava.util.logging.config.file=/var/jenkins_home/log.properties" -v /data/jenkins_home:/var/jenkins_home -v /usr/share/apache-maven:/var/maven_home -u 0 jenkins


docker run --name aniu-jenkins -d -p 8080:8080 -p 50000:50000 -v /data/jenkins_home:/var/jenkins_home -v /usr/share/apache-maven:/var/maven_home -u 0 jenkins

- 日志配置

cat > /data/jenkins_home/log.properties <<EOF
handlers=java.util.logging.ConsoleHandler
jenkins.level=FINEST
java.util.logging.ConsoleHandler.level=FINEST
EOF