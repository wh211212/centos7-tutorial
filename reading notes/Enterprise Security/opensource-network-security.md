# 开软软件与网络安全

## 安全相关名词记录学习

CNCERT：国家互联网应急中心

PDR：主动防御的安全模型，protection保护、detection检测、response响应

protection：加密、认证、访问控制、防火墙及防病毒
detection：入侵检测、漏洞扫描
response：应急响应机制建立

P2DR：策略policy是模型的核心，PDR依据安全策略实施

互联网企业安全基础组件：

运营SOC
检测：扫描器、HIDS、DLP、NIDS
防护：WAF、杀毒、准入、网络隔离
预测：威胁情报
响应：EDR、NDR

商业软件

商业：sourcefire
开源：snort、calmAV、razorback

## 业务网纵深防御体系建设

抗DDOS、保障业务持续性取
放后门、防止黑客非法获取服务器权限

边界防护：UTM、WAF
纵深防御：社工

安全产品

数据库：数据库审计、数据库防火墙
服务器端：主机IDS、服务器杀毒、内核加固、主机WAF
网路层：IDS、Web威胁感知、Web审计
网络边界：防火墙、UTM、WAF、IPS、本地流量清洗设备

河防体系：控
塔防体系：

新一代纵深防御：基于预测、检测、协同、防御、响应、溯源

WAF:Web Application Firewall 是通过执行一系列针对http、https的安全策略为web应用提供保护的一种产品，可防御：SQL注入、XSS、远程命令执行、目录遍历

自建WAF系统

OpenResty是一个基于Nginx与Lua的高性能Web平台