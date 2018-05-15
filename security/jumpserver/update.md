# jumpserver更新升级

- 参考文档：http://docs.jumpserver.org/zh/docs/upgrade.html

```
[root@ecs-110 ~]# cd /opt/jumpserver/
[root@ecs-110 jumpserver]# source .env 
(py3) [root@ecs-110 jumpserver]# cat .env 
source /opt/py3/bin/activate
(py3) [root@ecs-110 jumpserver]# 

# 新版本更新了自动升级脚本，升级只需要到 utils 目录下执行 sh upgrade.sh 即可
$ git pull
$ pip install -r requirements/requirements.txt  # 如果使用其他源下载失败可以使用 -i 参数指定源
$ cd utils && sh make_migrations.sh

# 1.0.x 升级 1.2.0 需要执行迁移脚本（新版本授权管理更新）
$ sh 2018_04_11_migrate_permissions.sh

# 注意笔者git pull的时候遇到了冲突，因为笔者pull本地修改过几个文件，笔者先暂存
git stash

git stash pop [–index] [stash_id]
git stash pop 恢复最新的进度到工作区。git默认会把工作区和暂存区的改动都恢复到工作区。
git stash pop --index 恢复最新的进度到工作区和暂存区。（尝试将原来暂存区的改动还恢复到暂存区）
git stash pop stash@{1}恢复指定的进度到工作区。stash_id是通过git stash list命令得到的 

# 通过git stash pop命令恢复进度后，会删除当前进度。
```