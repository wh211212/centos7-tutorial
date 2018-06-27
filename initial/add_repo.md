# centos7配置第三方yum源

## 安装一个插件为每个已安装的存储库添加优先级

yum -y install yum-plugin-priorities

- epel

yum -y install epel-release

- CentOS SCLo

yum -y install centos-release-scl-rh centos-release-scl
sed -i -e "s/enabled=1/enabled=0/g" /etc/yum.repos.d/CentOS-SCLo-scl-rh.repo
sed -i -e "s/enabled=1/enabled=0/g" /etc/yum.repos.d/CentOS-SCLo-scl.repo 

yum --enablerepo=centos-sclo-rh install [Package]

- remi


