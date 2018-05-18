# ovirt告警邮件设置

## 启用ovirt-engine-notifier服务来根据指定是事件发出邮件通知

- 配置ovirt-engine-notifier

```
# 从174行开始修改
# vi /usr/share/ovirt-engine/services/ovirt-engine-notifier/ovirt-engine-notifier.conf
# The SMTP mail server address. Required.
MAIL_SERVER=smtp.163.com

# The SMTP port (usually 25 for plain SMTP, 465 for SMTP with SSL, 587 for SMTP with TLS)
MAIL_PORT=465

# Required if SSL or TLS enabled to authenticate the user. Used also to specify 'from' user address if mail server
# supports, when MAIL_FROM is not set. Address is in RFC822 format
MAIL_USER=xxxxxx@163.com

# Required to authenticate the user if mail server requires authentication or if SSL or TLS is enabled
SENSITIVE_KEYS="${SENSITIVE_KEYS},MAIL_PASSWORD"
MAIL_PASSWORD=xxxxxx

# Indicates type of encryption (none, ssl or tls) should be used to communicate with mail server.
MAIL_SMTP_ENCRYPTION=ssl # 更改使用ssl，默认none收不到邮件

# If set to true, sends a message in HTML format.
HTML_MESSAGE_FORMAT=true

# Specifies 'from' address on sent mail in RFC822 format, if supported by mail server.
MAIL_FROM=xxxxxx@163.com
```

- 管理界面配置

> 在 ovirt-engine “管理”-“用户” ,选定用户（admin），在下方的菜单中选择：“事件通知器”-“管理事件”,选定需要告警的事件，配置邮件接收者。


- 配置完成，启动服务：

```
# systemctl start ovirt-engine-notifier     
# systemctl enable ovirt-engine-notifier    
```
