# C7添加硬盘

- 添加新硬盘时创建分区的示例

[root@aniu ~]# fdisk /dev/sdb# enter operation mode for partitions
Welcome to fdisk (util-linux 2.23.2).

Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Command (m for help): p# show partition table
Disk /dev/vdb: 21.5 GB, 21474836480 bytes, 41943040 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0xd97d5b18

   Device Boot      Start         End      Blocks   Id  System
 # none
Command (m for help): n# create a partition
Partition type:
   p   primary (0 primary, 0 extended, 4 free)
   e   extended
Select (default p): p# primary
Partition number (1-4, default 1): 1# specify partition number
First sector (2048-41943039, default 2048):   # starting cylinder
Using default value 2048
Last sector, +sectors or +size{K,M,G} (2048-41943039, default 41943039):   # end cylinder
Using default value 41943039
Partition 1 of type Linux and of size 20 GiB is set
Command (m for help): p# show partition table
Disk /dev/vdb: 21.5 GB, 21474836480 bytes, 41943040 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0xd97d5b18

   Device Boot      Start         End      Blocks   Id  System
/dev/vdb1            2048    41943039    20970496   83  Linux
 # just created
Command (m for help): 5# change type
Selected partition 1
Hex code (type L to list all codes): L# show list
 0  Empty           24  NEC DOS         81  Minix / old Lin bf  Solaris
 1  FAT12           27  Hidden NTFS Win 82  Linux swap / So c1  DRDOS/sec (FAT-
 2  XENIX root      39  Plan 9          83  Linux           c4  DRDOS/sec (FAT-
 3  XENIX usr       3c  PartitionMagic  84  OS/2 hidden C:  c6  DRDOS/sec (FAT-
 4  FAT16 <32M      40  Venix 80286     85  Linux extended  c7  Syrinx
 5  Extended        41  PPC PReP Boot   86  NTFS volume set da  Non-FS data
 6  FAT16           42  SFS             87  NTFS volume set db  CP/M / CTOS / .
 7  HPFS/NTFS/exFAT 4d  QNX4.x          88  Linux plaintext de  Dell Utility
 8  AIX             4e  QNX4.x 2nd part 8e  Linux LVM       df  BootIt
 9  AIX bootable    4f  QNX4.x 3rd part 93  Amoeba          e1  DOS access
 a  OS/2 Boot Manag 50  OnTrack DM      94  Amoeba BBT      e3  DOS R/O
 b  W95 FAT32       51  OnTrack DM6 Aux 9f  BSD/OS          e4  SpeedStor
 c  W95 FAT32 (LBA) 52  CP/M            a0  IBM Thinkpad hi eb  BeOS fs
 e  W95 FAT16 (LBA) 53  OnTrack DM6 Aux a5  FreeBSD         ee  GPT
 f  W95 Ext'd (LBA) 54  OnTrackDM6      a6  OpenBSD         ef  EFI (FAT-12/16/
10  OPUS            55  EZ-Drive        a7  NeXTSTEP        f0  Linux/PA-RISC b
11  Hidden FAT12    56  Golden Bow      a8  Darwin UFS      f1  SpeedStor
12  Compaq diagnost 5c  Priam Edisk     a9  NetBSD          f4  SpeedStor
14  Hidden FAT16 <3 61  SpeedStor       ab  Darwin boot     f2  DOS secondary
16  Hidden FAT16    63  GNU HURD or Sys af  HFS / HFS+      fb  VMware VMFS
17  Hidden HPFS/NTF 64  Novell Netware  b7  BSDI fs         fc  VMware VMKCORE
18  AST SmartSleep  65  Novell Netware  b8  BSDI swap       fd  Linux raid auto
1b  Hidden W95 FAT3 70  DiskSecure Mult bb  Boot Wizard hid fe  LANstep
1c  Hidden W95 FAT3 75  PC/IX           be  Solaris boot    ff  BBT
1e  Hidden W95 FAT1 80  Old Minix
Hex code (type L to list all codes): 8e# specify Linux LVM
Changed type of partition 'Linux' to 'Linux LVM'
Command (m for help): p# show partition table
Disk /dev/vdb: 21.5 GB, 21474836480 bytes, 41943040 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0xd97d5b18

   Device Boot      Start         End      Blocks   Id  System
/dev/vdb1            2048    41943039    20970496   8e  Linux LVM
 # changed
Command (m for help): w# save and quit
The partition table has been altered!

Calling ioctl() to re-read partition table.

WARNING: Re-reading the partition table failed with error 16: Device or resource busy.
The kernel still uses the old table. The new table will be used at
the next reboot or after you run partprobe(8) or kpartx(8)
Syncing disks.

[root@aniu ~]# sfdisk -l /dev/sdb# show status

Disk /dev/vdb: 41610 cylinders, 16 heads, 63 sectors/track
sfdisk: Warning: The partition table looks like it was made
  for C/H/S=*/3/34 (instead of 41610/16/63).
For this listing I'll assume that geometry.

Units: cylinders of 52224 bytes, blocks of 1024 bytes, counting from 0

   Device Boot Start     End   #cyls    #blocks   Id  System
/dev/vdb1         20+ 411206- 411187-  20970496   8e  Linux LVM
sfdisk:                 start: (c,h,s) expected (20,0,9) found (2,0,33)

sfdisk:                 end: (c,h,s) expected (1023,2,34) found (650,2,34)

/dev/vdb2          0       -       0          0    0  Empty
/dev/vdb3          0       -       0          0    0  Empty
/dev/vdb4          0       -       0          0    0  Empty

