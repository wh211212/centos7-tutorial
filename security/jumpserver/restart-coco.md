# 重启coco解决ssh session不释放问题

```
[root@ecs-110 ~]# cd /opt/
[root@ecs-110 opt]# source /opt/py3/bin/activate
(py3) [root@ecs-110 opt]# cd coco/  
(py3) [root@ecs-110 coco]# ./cocod stop
Stop coco process
(py3) [root@ecs-110 coco]# ./cocod start -d
Start coco process
(py3) [root@ecs-110 coco]# ./cocod status
Coco is running: 10555
```