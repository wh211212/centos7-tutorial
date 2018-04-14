# Ovirt用户管理
 
- https://www.ovirt.org/documentation/admin-guide/chap-Users_and_Roles/

## 通过命令行管理用户任务


ovirt-aaa-jdbc-tool user add yunwei --attribute=firstName=yunwei

ovirt-aaa-jdbc-tool user edit yunwei --attribute=email=yunwei@aniu.tv

ovirt-aaa-jdbc-tool user password-reset yunwei --password-valid-to="2025-08-01 12:00:00-0800"


- 更改管理员密码

ovirt-aaa-jdbc-tool user password-reset admin --password-valid-to="2025-08-01 12:00:00Z"

- 禁用内部管理用户


## 管理组

ovirt-aaa-jdbc-tool group add ops

ovirt-aaa-jdbc-tool group add dev

ovirt-aaa-jdbc-tool group-manage useradd ops --user=yunwei

ovirt-aaa-jdbc-tool group show ops

