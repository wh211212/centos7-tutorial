1、gitlab备份与恢复
> 参考：https://docs.gitlab.com/ce/raketasks/backup_restore.html
创建系统备份
sudo gitlab-rake gitlab:backup:create
备份文件存在/var/opt/gitlab/backups，可编辑/etc/gitlab/gitlab.rb修改
源码安装使用下面命令备份
sudo -u git -H bundle exec rake gitlab:backup:create RAILS_ENV=production
docker安装使用下面命令备份
docker exec -t <container name：gitlab> gitlab-rake gitlab:backup:create
将备份上传到远程存储（暂无）
将备份文件存储到本地
gitlab_rails['backup_upload_connection'] = {
  :provider => 'Local',
  :local_root => '/mnt/backups'
}
# The directory inside the mounted folder to copy backups to
# Use '.' to store them in the root directory
gitlab_rails['backup_upload_remote_directory'] = 'gitlab_backups'
备份档案权限
# In /etc/gitlab/gitlab.rb, for omnibus packages
gitlab_rails['backup_archive_permissions'] = 0644 # Makes the backup archives world-readable
备份配置文件
针对（Omnibus）备份：/etc/gitlab/gitlab.rb 、/etc/gitlab/gitlab-secrets.json
添加定时备份
每天凌晨两点备份
0 2 * * * /opt/gitlab/bin/gitlab-rake gitlab:backup:create CRON=1
保留备份30天，单位秒
gitlab_rails['backup_keep_time'] = 2592000

2、Omnibus安装恢复
确认备份档案放到gitlab.rb定义的备份目录（默认/var/opt/gitlab/backups）
sudo cp 1504793137_2017_09_07_9.5.3_gitlab_backup.tar /var/opt/gitlab/backups/
停止连接数据库的进程
sudo gitlab-ctl stop unicorn
sudo gitlab-ctl stop sidekiq
# Verify
sudo gitlab-ctl status
恢复备份档案，指定时间戳
sudo gitlab-rake gitlab:backup:restore BACKUP=1504793137_2017_09_07_9.5.3
> Unpacking backup ... tar: 1504796591_2017_09_07_9.5.3_gitlab_backup.tar: Cannot open: Permission denied
chmod git:git 1504796591_2017_09_07_9.5.3_gitlab_backup.tar
重启并检查恢复情况
sudo gitlab-ctl restart
sudo gitlab-rake gitlab:check SANITIZE=true






