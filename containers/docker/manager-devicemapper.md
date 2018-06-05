# 管理devicemapper

不要单独依靠LVM自动扩展。卷组自动扩展，但卷仍可填满,使用zabbix监控

- 要查看LVM日志，使用journalctl：

```
journalctl -fu dm-event.service
```