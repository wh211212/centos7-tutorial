# docker挂载卷提示权限错误

```
touch: cannot touch '/var/jenkins_home/copy_reference_file.log': Permission denied
Can not write to /var/jenkins_home/copy_reference_file.log. Wrong volume permissions?
```

将jenkins数据存储在主机上的/your/home中。确保容器中的jenkins用户（jenkins user - uid 1000）可以访问/your/home，或者在docker run中使用-u some_other_user参数。

笔者以root用户为例：
docker run -d -p 8080:8080 -p 50000:50000 --env JAVA_OPTS="-Djava.util.logging.config.file=/var/jenkins_home/log.properties" -v /data/jenkins_home:/var/jenkins_home -u 0 jenkins