# jvm optimization

## 

-Xms=4G -Xmx=4G 

xms 和 xmx设置一样大，避免伸缩区对内存的频繁操作

xss 线程栈 默认1m 


动态对象数组: 队列/栈/list

heap 堆内存：线程共享

年轻代：eden区/存活区
-XX：+PrintPrintGCDetails
-XX：SurrvivorRatio=8

minor GC： 年轻代GC算法：copying 

BTP bump-the-pointer 不适合多线程
TLAB thread-thread-local-thread-local-alloction-buffers： 多线程 会产生内存碎片


eden 伊甸园区：新创建的对象，最大空间
S0：from space
S1：to space

负责对象回收，对象晋级（老年代/永久代）

8:1:1 

老年代：


