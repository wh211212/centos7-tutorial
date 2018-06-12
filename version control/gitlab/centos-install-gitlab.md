# 安装gitlab
https://about.gitlab.com/installation/#centos-6

sudo yum install -y curl openssh-server openssh-clients cronie
sudo lokkit -s http -s ssh

sudo yum install postfix
sudo service postfix start
sudo chkconfig postfix on

curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | sudo bash
sudo yum install -y gitlab-ce

sudo gitlab-ctl reconfigure

# 访问

http://192.168.0.222/users/password/edit?reset_password_token=ehgPfKd56C92NgYHaNPi

设置新密码 fangbuxia..0

- 重置密码

https://docs.gitlab.com/ce/security/reset_root_password.html

## 编辑gitlab.rb

- 更改域名
vim  /etc/gitlab/gitlab.rb

编辑：external_url '你的网址'
例如：external_url 'http://gitlab.aniu.so'
编辑完成后，再sudo gitlab-ctl reconfigure一下，使配置生效

GitLab设置IP或者域名有两个配置文件： 
1、GitLab的：/home/git/gitlab/config/gitlab.yml
2、GitLab-Shell的：/home/git/gitlab-shell/config.yml




