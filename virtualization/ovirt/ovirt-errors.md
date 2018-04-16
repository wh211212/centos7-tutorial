# ovirt安装故障排查

An error has occurred during installation of Host ovirt1: Yum [u'vdsm-4.20.23-1.el7.centos.x86_64 requires glusterfs-cli >= 3.12', u'ovirt-hosted-engine-setup-2.2.15-1.el7.centos.noarch requires glusterfs-cli >= 3.12.0', u'vdsm-4.20.23-1.el7.centos.x86_64 requires glusterfs-fuse >= 3.12'].


An error has occurred during installation of Host ovirt1: Failed to execute stage 'Package installation': [u'vdsm-4.20.23-1.el7.centos.x86_64 requires glusterfs-cli >= 3.12', u'ovirt-hosted-engine-setup-2.2.15-1.el7.centos.noarch requires glusterfs-cli >= 3.12.0', u'vdsm-4.20.23-1.el7.centos.x86_64 requires glusterfs-fuse >= 3.12'].

# 故障原因是笔者的CentOS Base repo设置了优先级，默认下载安装包时从base源下载，导致版本过低

- 解决：还原CentOS Base repo的优先级

yum install centos-release-gluster  # 安装centos-release-gluster，

yum clean all

yum update

## 升级ovirt导致ovirt登录加载的时间特别久, 安装ovirt engine的机器配置双网卡binding导致主机失败

# ovirt账号过期问题

Unable to log in because the user account has expired. Contact the system administrator.

# 添加主机报错

An error has occurred during installation of Host cloud.aniu.so: Unexpected error during execution: bash: line 1:  7021 Segmentation fault      "${MYTMP}"/ovirt-host-deploy DIALOG/dialect=str:machine DIALOG/customization=bool:True

# ovirt engine 上重新reinstall host报错

2018-04-10 11:45:02,822+08 ERROR [org.ovirt.engine.core.bll.hostdeploy.InstallVdsInternalCommand] (EE-ManagedThreadFactory-engine-Thread-2) [44eb8932] Exception: org.ovirt.engine.core.bll.network.NetworkConfigurator$NetworkConfiguratorException: Failed to configure management network
        at org.ovirt.engine.core.bll.network.NetworkConfigurator.configureManagementNetwork(NetworkConfigurator.java:242) [bll.jar:]
        at org.ovirt.engine.core.bll.network.NetworkConfigurator.createManagementNetworkIfRequired(NetworkConfigurator.java:90) [bll.jar:]
        at org.ovirt.engine.core.bll.hostdeploy.InstallVdsInternalCommand.configureManagementNetwork(InstallVdsInternalCommand.java:304) [bll.jar:]
        at org.ovirt.engine.core.bll.hostdeploy.InstallVdsInternalCommand.installHost(InstallVdsInternalCommand.java:217) [bll.jar:]
        at org.ovirt.engine.core.bll.hostdeploy.InstallVdsInternalCommand.executeCommand(InstallVdsInternalCommand.java:113) [bll.jar:]
        at org.ovirt.engine.core.bll.CommandBase.executeWithoutTransaction(CommandBase.java:1133) [bll.jar:]
        at org.ovirt.engine.core.bll.CommandBase.executeActionInTransactionScope(CommandBase.java:1285) [bll.jar:]
        at org.ovirt.engine.core.bll.CommandBase.runInTransaction(CommandBase.java:1934) [bll.jar:]
        at org.ovirt.engine.core.utils.transaction.TransactionSupport.executeInSuppressed(TransactionSupport.java:164) [utils.jar:]
        at org.ovirt.engine.core.utils.transaction.TransactionSupport.executeInScope(TransactionSupport.java:103) [utils.jar:]
        at org.ovirt.engine.core.bll.CommandBase.execute(CommandBase.java:1345) [bll.jar:]
        at org.ovirt.engine.core.bll.CommandBase.executeAction(CommandBase.java:400) [bll.jar:]
        at org.ovirt.engine.core.bll.PrevalidatingMultipleActionsRunner.executeValidatedCommand(PrevalidatingMultipleActionsRunner.java:204) [bll.jar:]
        at org.ovirt.engine.core.bll.PrevalidatingMultipleActionsRunner.runCommands(PrevalidatingMultipleActionsRunner.java:176) [bll.jar:]
        at org.ovirt.engine.core.bll.PrevalidatingMultipleActionsRunner.lambda$invokeCommands$3(PrevalidatingMultipleActionsRunner.java:182) [bll.jar:]
        at org.ovirt.engine.core.utils.threadpool.ThreadPoolUtil$InternalWrapperRunnable.run(ThreadPoolUtil.java:96) [utils.jar:]
        at java.util.concurrent.Executors$RunnableAdapter.call(Executors.java:511) [rt.jar:1.8.0_161]
        at java.util.concurrent.FutureTask.run(FutureTask.java:266) [rt.jar:1.8.0_161]
        at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1149) [rt.jar:1.8.0_161]
        at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:624) [rt.jar:1.8.0_161]
        at java.lang.Thread.run(Thread.java:748) [rt.jar:1.8.0_161]
        at org.glassfish.enterprise.concurrent.ManagedThreadFactoryImpl$ManagedThread.run(ManagedThreadFactoryImpl.java:250) [javax.enterprise.concurrent-1.0.jar:]
        at org.jboss.as.ee.concurrent.service.ElytronManagedThreadFactory$ElytronManagedThread.run(ElytronManagedThreadFactory.java:78)

# 执行 添加存储连接 操作时出错: 在指定路径上的权限设置不允许对存储的访问。请检验指定存储路径上的权限设置。


## 新加集群的时候启用gluster服务


-  Unable to RefreshCapabilities: NoRouteToHostException: No route to host


- 添加主机报错

2018-04-15 12:38:09,018+08 ERROR [org.ovirt.engine.core.uutils.ssh.SSHDialog] (EE-ManagedThreadFactory-engine-Thread-41719) [b1231d75-cc37-4bd9-a94c-ca77b8535017] SSH error running command root@192.168.10.10:'umask 0077; MYTMP="$(TMPDIR="${OVIRT_TMPDIR}" mktemp -d -t ovirt-XXXXXXXXXX)"; trap "chmod -R u+rwX \"${MYTMP}\" > /dev/null 2>&1; rm -fr \"${MYTMP}\" > /dev/null 2>&1" 0; tar --warning=no-timestamp -C "${MYTMP}" -x &&  "${MYTMP}"/ovirt-host-deploy DIALOG/dialect=str:machine DIALOG/customization=bool:True': IOException: Command returned failure code 1 during SSH session 'root@192.168.10.10'
2018-04-15 12:38:09,018+08 ERROR [org.ovirt.engine.core.bll.hostdeploy.VdsDeployBase] (EE-ManagedThreadFactory-engine-Thread-41719) [b1231d75-cc37-4bd9-a94c-ca77b8535017] Error during host 192.168.10.10 install
2018-04-15 12:38:09,021+08 ERROR [org.ovirt.engine.core.bll.hostdeploy.InstallVdsInternalCommand] (EE-ManagedThreadFactory-engine-Thread-41719) [b1231d75-cc37-4bd9-a94c-ca77b8535017] Host installation failed for host '78c79c41-3923-43ff-b224-4dd21cd18a08', 'pre-ovirt1': Command returned failure code 1 during SSH session 'root@192.168.10.10'
2018-04-15 12:38:09,024+08 INFO  [org.ovirt.engine.core.vdsbroker.SetVdsStatusVDSCommand] (EE-ManagedThreadFactory-engine-Thread-41719) [b1231d75-cc37-4bd9-a94c-ca77b8535017] START, SetVdsStatusVDSCommand(HostName = pre-ovirt1, SetVdsStatusVDSCommandParameters:{hostId='78c79c41-3923-43ff-b224-4dd21cd18a08', status='InstallFailed', nonOperationalReason='NONE', stopSpmFailureLogged='false', maintenanceReason='null'}), log id: 42650ff1
2018-04-15 12:38:09,031+08 INFO  [org.ovirt.engine.core.vdsbroker.SetVdsStatusVDSCommand] (EE-ManagedThreadFactory-engine-Thread-41719) [b1231d75-cc37-4bd9-a94c-ca77b8535017] FINISH, SetVdsStatusVDSCommand, log id: 42650ff1
2018-04-15 12:38:09,036+08 ERROR [org.ovirt.engine.core.dal.dbbroker.auditloghandling.AuditLogDirector] (EE-ManagedThreadFactory-engine-Thread-41719) [b1231d75-cc37-4bd9-a94c-ca77b8535017] EVENT_ID: VDS_INSTALL_FAILED(505), Host pre-ovirt1 installation failed. Command returned failure code 1 during SSH session 'root@192.168.10.10'.


Apr 16 10:14:36 pre-ovirt1 libvirtd[1329]: 2018-04-16 02:14:36.178+0000: 1329: error : virNetSocketReadWire:1808 : End of file while reading data: Input/output error
Apr 16 10:14:36 pre-ovirt1 libvirtd[1329]: 2018-04-16 02:14:36.380+0000: 1429: error : virNetSASLSessionServerStart:541 : authentication failed: Failed to start SASL negotiation: -20 (SASL(-13): user not found: unable to canonify user and get auxprops)


An error has occurred during installation of Host pre-ovirt1: Failed to execute stage 'Setup validation': Hardware does not support virtualization.
