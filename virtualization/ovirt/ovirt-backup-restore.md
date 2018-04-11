# ovirt engine备份和迁移

## 备份ovirt engine

- 使用engine-backup命令创建备份

```
[root@ovirtengine ~]# engine-backup --scope=all --mode=backup --file=engine-backup.txt --log=engine-backup.log
Backing up:
Notifying engine
- Files
- Engine database 'engine'
- DWH database 'ovirt_engine_history'
Packing into file 'engine-backup.txt'
Notifying engine
Done.
```