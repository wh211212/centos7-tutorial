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

## 将备份恢复到全新安装

- FATAL: Engine service is active - can not restore backup

- FATAL: Existing database 'engine' or user 'engine' found and temporary ones created - Please clean up everything and try again


[root@ovirtengine ~]# engine-backup --scope=all --mode=restore --file=engine-backup.txt --log=engine-backup.log --restore-permissions               
Preparing to restore:
- Unpacking file 'engine-backup.txt'
Restoring:
- Files
FATAL: Can't connect to database 'ovirt_engine_history'. Please see '/usr/bin/engine-backup --help'.


## 恢复备份以覆盖现有安装

先engine-cleanup

[root@ovirtengine ~]# engine-cleanup
[ INFO  ] Stage: Initializing
[ INFO  ] Stage: Environment setup
          Configuration files: ['/etc/ovirt-engine-setup.conf.d/10-packaging-jboss.conf', '/etc/ovirt-engine-setup.conf.d/10-packaging.conf', '/etc/ovirt-engine-setup.conf.d/20-setup-ovirt-post.conf']
          Log file: /var/log/ovirt-engine/setup/ovirt-engine-remove-20180411135056-qiy9rw.log
          Version: otopi-1.7.7 (otopi-1.7.7-1.el7.centos)
[ INFO  ] Stage: Environment packages setup
[ INFO  ] Stage: Programs detection
[ INFO  ] Stage: Environment customization
          Do you want to remove all components? (Yes, No) [Yes]: 
[WARNING] Failed to resolve ovirtengine.aniu.so using DNS, it can be resolved only locally
         
          --== PRODUCT OPTIONS ==--
         
[ INFO  ] Stage: Setup validation
          All the installed ovirt components are about to be removed, data will be lost (OK, Cancel) [Cancel]: OK
[ INFO  ] Stage: Transaction setup
[ INFO  ] Stopping engine service
[ INFO  ] Stopping ovirt-fence-kdump-listener service
[ INFO  ] Stopping dwh service
[ INFO  ] Stopping Image I/O Proxy service
[ INFO  ] Stopping vmconsole-proxy service
[ INFO  ] Stopping websocket-proxy service
[ INFO  ] Stage: Misc configuration
[ INFO  ] Stage: Package installation
[ INFO  ] Stage: Misc configuration
[ INFO  ] Backing up PKI configuration and keys
[ INFO  ] Backing up database localhost:engine to '/var/lib/ovirt-engine/backups/engine-20180411135119.qeex90.dump'.
[ INFO  ] Clearing Engine database engine
[ INFO  ] Backing up database localhost:ovirt_engine_history to '/var/lib/ovirt-engine-dwh/backups/dwh-20180411135132.NMG9Up.dump'.
[ INFO  ] Clearing DWH database ovirt_engine_history
[ INFO  ] Removing files
[ INFO  ] Reverting changes to files
[ INFO  ] Stage: Transaction commit
[ INFO  ] Stage: Closing up
         
          --== SUMMARY ==--
         
          Engine setup successfully cleaned up
          A backup of PKI configuration and keys is available at /var/lib/ovirt-engine/backups/engine-pki-201804111351194HN0Gw.tar.gz
          ovirt-engine has been removed
          A backup of the Engine database is available at /var/lib/ovirt-engine/backups/engine-20180411135119.qeex90.dump
          A backup of the DWH database is available at /var/lib/ovirt-engine-dwh/backups/dwh-20180411135132.NMG9Up.dump
         
          --== END OF SUMMARY ==--
         
[ INFO  ] Stage: Clean up
          Log file is located at /var/log/ovirt-engine/setup/ovirt-engine-remove-20180411135056-qiy9rw.log
[ INFO  ] Generating answer file '/var/lib/ovirt-engine/setup/answers/20180411135137-cleanup.conf'
[ INFO  ] Stage: Pre-termination
[ INFO  ] Stage: Termination
[ INFO  ] Execution of cleanup completed successfully


[root@ovirtengine ~]# engine-backup --scope=all --mode=restore --file=engine-backup.txt --log=engine-backup.log --restore-permissions
Preparing to restore:
- Unpacking file 'engine-backup.txt'
Restoring:
- Files
- Engine database 'engine'
  - Cleaning up temporary tables in engine database 'engine'
  - Updating DbJustRestored VdcOption in engine database
  - Resetting DwhCurrentlyRunning in dwh_history_timekeeping in engine database
  - Resetting HA VM status
------------------------------------------------------------------------------
Please note:

The engine database was backed up at 2018-04-11 09:15:58.000000000 +0800 .

Objects that were added, removed or changed after this date, such as virtual
machines, disks, etc., are missing in the engine, and will probably require
recovery or recreation.
------------------------------------------------------------------------------
- DWH database 'ovirt_engine_history'
You should now run engine-setup.
Done.

engine-setup # 重新setup


## 使用不同的凭证恢复备份

## 日常备份

- /home/wh/ovirt下：

```
engine-backup --scope=all --mode=backup --file=engine-backup-20180413.txt --log=engine-backup-20180413.log
``