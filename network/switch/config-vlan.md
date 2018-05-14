# 交换机上配置vlan

Switch> enable  //输入账号密码进入特权模式
Switch# configure terminal  
Switch（config）#vlan 10    //创建vlan 10
Switch（config-vlan）#exit

Switch（config）#interface f0/1  //进入f0/1端口
Switch（config）#int range f0/3-4  //对端口f0/3.f0/4同时做操作
Switch（config-if）#switchport mode access  //端口模式
Switch（config-if）#switchport access vlan 10   //将端口f0/1划分到vlan 10中

Switch# show vlan //显示vlan信息

## 
