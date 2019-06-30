# 按时间查看tomcat慢访问日志

- 查看早上九点到十点的访问日志：

sed -n '/03\/Jul\/2018:09/,/03\/Jul\/2018:10/p' /data/tomcats/tomcat-7081/logs/localhost_access_log.2018-07-03.txt  | less

# 接口故障处理


web访问响应慢 - 查看接口日志 接口日志有报错，acces慢日志特别多  接口取数据慢  数据源有问题  缓存问题  缓存所在服务器redis做持久化导致进程堵塞  关闭持久化  重启接口  页面恢复 加载速度变快

