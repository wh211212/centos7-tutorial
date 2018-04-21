# Sealing Linux VM

## 密封Linux VM 步骤

SSH to the VM as root
flag the system for reconfiguring
touch /.unconfigured
Remove ssh host keys:
rm -i /etc/ssh/ssh_host_*
Optionally, for environments where a host cannot determine its own name via DNS based lookups:
hostnamectl set-hostname hostname
Remove UDEV rules:
rm -i /etc/udev/rules.d/70-persistent*
Remove UUID
[optionally] Delete the logs from /var/log
[Optionally] Delete the build logs from /root.
Shut down the virtual machine.

## 