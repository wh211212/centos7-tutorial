# 
CHECK [memory_availability : master.aniu.so] **********************************************************************************************************************************************************
fatal: [master.aniu.so]: FAILED! => {"changed": true, "checks": {"disk_availability": {"failed": true, "failures": [["OpenShiftCheckException", "Available disk space in \"/var\" (23.8 GB) is below minimum recommended (40.0 GB)"]], "msg": "Available disk space in \"/var\" (23.8 GB) is below minimum recommended (40.0 GB)"}, "docker_image_availability": {"changed": true}, "docker_storage": {"changed": true}, "memory_availability": {}, "package_availability": {"changed": false, "invocation": {"module_args": {"packages": ["PyYAML", "bash-completion", "bind", "ceph-common", "cockpit-bridge", "cockpit-docker", "cockpit-system", "cockpit-ws", "dnsmasq", "docker", "etcd", "firewalld", "flannel", "glusterfs-fuse", "httpd-tools", "iptables", "iptables-services", "iscsi-initiator-utils", "libselinux-python", "nfs-utils", "ntp", "openssl", "origin", "origin-clients", "origin-master", "origin-node", "origin-sdn-ovs", "pyparted", "python-httplib2", "yum-utils"]}}}, "package_version": {"changed": false, "invocation": {"module_args": {"package_list": [{"check_multi": false, "name": "openvswitch", "version": ["2.6", "2.7", "2.8", "2.9"]}, {"check_multi": false, "name": "docker", "version": ["1.12", "1.13"]}, {"check_multi": false, "name": "origin", "version": ""}, {"check_multi": false, "name": "origin-master", "version": ""}, {"check_multi": false, "name": "origin-node", "version": ""}], "package_mgr": "yum"}}}}, "msg": "One or more checks failed", "playbook_context": "install"}

NO MORE HOSTS LEFT ************************************************************************************************************************************************************************************
 [WARNING]: Could not create retry file '/usr/share/ansible/openshift-ansible/playbooks/deploy_cluster.retry'.         [Errno 13] Permission denied: u'/usr/share/ansible/openshift-
ansible/playbooks/deploy_cluster.retry'


PLAY RECAP ********************************************************************************************************************************************************************************************
localhost                  : ok=11   changed=0    unreachable=0    failed=0   
master.aniu.so             : ok=38   changed=2    unreachable=0    failed=1   
node1.aniu.so              : ok=13   changed=0    unreachable=0    failed=1   
node2.aniu.so              : ok=13   changed=0    unreachable=0    failed=1   


INSTALLER STATUS **************************************************************************************************************************************************************************************
Initialization             : Complete (0:00:50)
Health Check               : In Progress (0:02:18)
        This phase can be restarted by running: playbooks/openshift-checks/pre-install.yml



Failure summary:


  1. Hosts:    node1.aniu.so, node2.aniu.so
     Play:     Initialize cluster facts
     Task:     Gather Cluster facts
     Message:  MODULE FAILURE

  2. Hosts:    master.aniu.so
     Play:     OpenShift Health Checks
     Task:     Run health checks (install) - EL
     Message:  One or more checks failed
     Details:  check "disk_availability":
               Available disk space in "/var" (23.8 GB) is below minimum recommended (40.0 GB)

The execution of "/usr/share/ansible/openshift-ansible/playbooks/deploy_cluster.yml" includes checks designed to fail early if the requirements of the playbook are not met. One or more of these checks failed. To disregard these results,explicitly disable checks by setting an Ansible variable:
   openshift_disable_check=disk_availability
Failing check names are shown in the failure details above. Some checks may be configurable by variables if your requirements are different from the defaults; consult check documentation.
Variables can be set in the inventory or passed on the command line using the -e flag to ansible-playbook.