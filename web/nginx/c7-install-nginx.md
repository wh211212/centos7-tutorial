# CentOS7 安装Nginx

## 配置nginx源

# cat nginx.repo 

echo '[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=0
enabled=1
' | sudo tee /etc/yum.repos.d/nginx.repo
## 安装nginx

yum install nginx -y

- 启动设置自启

systemctl start nginx 
systemctl enable nginx 

firewall-cmd --add-service=http --permanent 
firewall-cmd --reload 
