# shell脚本学习指南

- 基本I/O重定向

标准输入、标准输出、标准错误输出


- awk

awk -F: -v 'OFS=**' '{print $1, $5}' /etc/passwd

sort -t: -k1,1 /etc/passwd

sort -t: -k3nr /etc/passwd

sort -t: -k4n -k3n /etc/passwd


uniq -c : 计数唯一的、排序后的记录


- 查看文件前n条记录

head -n n   files
head -n     files
awk 'FNR <= 3' files
sed -e nq   files
sed nq

- 以：分割，截取打印显示第五个字段

awk -F: '{print $5}'
cut -d: -f5



