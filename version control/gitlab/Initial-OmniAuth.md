# Omnibus GitLab文档

- https://docs.gitlab.com/omnibus/

## 安装

> GitLab可以通过各种方式进行安装。检查安装方法的概述。

## 安装要求

> 安装GitLab之前，请确保检查需求文档，其中包含有关受支持操作系统的有用信息以及硬件要求（https://docs.gitlab.com/ce/install/requirements.html）。

## 安装方式

- 推荐使用Omnibus软件包(https://about.gitlab.com/downloads/)进行安装 - 使用我们的官方deb/rpm存储库安装GitLab。
- 源码包安装（https://docs.gitlab.com/ce/install/installation.html）
- Docker - 使用Docker安装GitLab
- 在Kubernetes中安装（https://docs.gitlab.com/ce/install/kubernetes/index.html） - 使用我们的官方Helm Chart Repository将GitLab安装到Kubernetes群集中。

## 数据库要求

> 虽然推荐的数据库是PostgreSQL，但是我们提供了使用MySQL安装GitLab的信息。检查MySQL文档以获取更多信息(https://docs.gitlab.com/ce/install/database_mysql.html)。


## 维护

- 获取服务状态
- 开始和停止
- 调用耙子任务
- 启动Rails控制台会话

##

## SMTP设置

> 如果您希望通过SMTP服务器而不是通过Sendmail发送应用程序电子邮件，请将以下配置信息添加到/etc/gitlab/gitlab.rb并运行gitlab-ctl reconfigure。

https://docs.gitlab.com/omnibus/settings/smtp.html

gitlab_rails['smtp_enable'] = true
gitlab_rails['smtp_address'] = "smtp-mail.outlook.com"
gitlab_rails['smtp_port'] = 587
gitlab_rails['smtp_user_name'] = "username@outlook.com"
gitlab_rails['smtp_password'] = "password"
gitlab_rails['smtp_domain'] = "smtp-mail.outlook.com"
gitlab_rails['smtp_authentication'] = "login"
gitlab_rails['smtp_enable_starttls_auto'] = true
gitlab_rails['smtp_openssl_verify_mode'] = 'peer'

## 通过电子邮件回复

GitLab可以设置为允许用户通过回复通知电子邮件来评论问题并合并请求。


gitlab_rails['incoming_email_enabled'] = true
gitlab_rails['incoming_email_address'] = "incoming+%{key}@gitlab.example.com"
gitlab_rails['incoming_email_email'] = "incoming"
gitlab_rails['incoming_email_password'] = "[REDACTED]"
gitlab_rails['incoming_email_host'] = "gitlab.example.com"
gitlab_rails['incoming_email_port'] = 143
gitlab_rails['incoming_email_ssl'] = false
gitlab_rails['incoming_email_start_tls'] = false
gitlab_rails['incoming_email_mailbox_name'] = "inbox"
gitlab_rails['incoming_email_idle_timeout'] = 60


## 设置Postfix通过电子邮件回复
