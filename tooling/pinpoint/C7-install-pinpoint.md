# CentOS7 安装pinpoint

- 参考教程：http://naver.github.io/pinpoint/

Pinpoint是用Java编写的大型分布式系统的APM（应用程序性能管理）工具。 受Dapper的启发，Pinpoint提供了一种解决方案，通过在分布式应用程序中跟踪事务来帮助分析系统的整体结构以及它们中的组件之间的相互关系。




- 安装jdk

yum -y install java-1.8.0-openjdk java-1.8.0-openjdk-devel
# cat > /etc/profile.d/java8.sh <<EOF 
export JAVA_HOME=$(dirname $(dirname $(readlink $(readlink $(which javac)))))
export PATH=\$PATH:\$JAVA_HOME/bin
export CLASSPATH=.:\$JAVA_HOME/jre/lib:\$JAVA_HOME/lib:\$JAVA_HOME/lib/tools.jar
EOF

# source /etc/profile.d/java8.sh