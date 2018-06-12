# Gitlab 管理员设置

> 了解如何管理您的GitLab实例。普通用户无权访问GitLab管理工具和设置。

## 安装，更新，升级，迁移

- 安装（http://docs.gitlab.com/ce/install/README.html）：来源的要求，目录结构和安装。
- Mattermost: 安装Gitlab集成Mattermost（https://about.mattermost.com/）
- 将GitLab CI迁移到CE/EE：如果您有一个旧的GitLab安装（早于8.0），请按照本指南将现有的GitLab CI数据迁移到GitLab CE/EE（http://docs.gitlab.com/ce/migrate_ci_to_ce/README.html）。
- 重新启动GitLab（http://docs.gitlab.com/ce/administration/restart_gitlab.html）：了解如何重新启动GitLab及其组件。
- 更新：升级安装的更新指南

## 用户权限

- 访问限制（http://docs.gitlab.com/ce/user/admin_area/settings/visibility_and_access_controls.html#enabled-git-access-protocols）：定义可以使用哪个Git访问协议来与GitLab通信
- 身份验证/授权（http://docs.gitlab.com/ce/topics/authentication/index.html#gitlab-administrators）：强制执行2FA，使用LDAP，SAML，CAS和其他Omniauth提供程序配置外部身份验证

## GitLab管理员超级权限

- 容器注册表：使用GitLab配置Docker注册表
- 自定义的Git挂钩：基于文件系统自定义Git钩子
- Git LFS配置：了解如何在GitLab下使用LFS
- GitLab页面配置：配置GitLab页面。
- 高可用性：配置多个服务器进行缩放或高可用性。
- 用户队列随着时间的推移查看用户活动
- Web终端：提供终端访问GitLab内的环境
- GitLab CI
  - CI管理设置：定义最大工件大小和到期时间

## 集成

- 集成（http://docs.gitlab.com/ce/integration/README.html）：如何与JIRA，Redmine，Twitter等系统集成。
- Koding：设置Koding与GitLab配合使用
- Mattermost（http://docs.gitlab.com/ce/user/project/integrations/mattermost.html）：设置GitLab与Mattermost

## 监控

- 使用InfluxDB进行GitLab性能监控：配置GitLab和InfluxDB以测量性能指标。
- 使用Prometheus进行GitLab性能监控：配置GitLab和Prometheus来衡量性能指标。
- 监视正常运行时间：使用运行状况检查端点检查服务器状态

## 性能

- 管家：保持您的Git仓库整齐，快速
- 运维：保持GitLab的运行
- 轮询：配置GitLab UI轮询更新的频率
- 请求分析：获取关于缓慢请求的详细配置文件

## 定制

- 调整实例的时区：自定义GitLab的默认时区
- 环境变量：支持的环境变量，可用于覆盖其默认值以配置GitLab
- 标题标识：更改整个页面和电子邮件标题上的徽标
- 问题关闭模式：自定义如何从提交消息中关闭问题
- 欢迎消息：将自定义欢迎消息添加到登录页面

## 管理工具

- Raketasks：备份，维护，自动Webhook设置和项目导入
  - 备份和还原：备份和还原您的GitLab实例
- 通过电子邮件回复：允许用户通过回复通知电子邮件来评论问题并合并请求
- 存储库检查：定期Git存储库检查
- 安全性：了解如何进一步保护您的GitLab实例
- 系统挂钩：用户，项目和密钥更改时的通知

## 故障排除

- 调试提示：出现问题时调试问题的提示
- 日志系统：从查找日志分析问题
- Sidekiq疑难解答：当Sidekiq出现挂起并且未处理作业时调试

## 贡献者文档

- 开发者：所有风格的指导和解释如何贡献
- 法律：供应商许可协议
- 写文档：贡献GitLab文档
