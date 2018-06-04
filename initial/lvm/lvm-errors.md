#

[root@node2 ~]# vgextend cl /dev/sdb1
  WARNING: PV /dev/sdb1 is marked in use but no VG was found using it.
  WARNING: PV /dev/sdb1 might need repairing.
  PV /dev/sdb1 is used by a VG but its metadata is missing.
  Can't initialize PV '/dev/sdb1' without -ff.
  /dev/sdb1: physical volume not initialized.


恢复物理卷元数据