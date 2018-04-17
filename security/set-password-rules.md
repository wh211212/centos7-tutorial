# 出于安全原因设置密码规则

1、设置密码过期的天数。 用户必须在几天内更改密码。 此设置仅在创建用户时才会产生影响，而不会影响到现有用户。 如果设置为现有用户，请运行命令“chage -M（days）（user）”

```
[root@shaonbean ~]# vi /etc/login.defs
# line 25: set 60 for Password Expiration
PASS_MAX_DAYS 60
```

2、设置可用密码的最短天数。 至少在改变它之后，用户必须至少使用他们的密码。 此设置仅在创建用户时才会产生影响，而不会影响到现有用户。 如果设置为现有用户，请运行命令“chage -m（days）（user）”

```
[root@shaonbean ~]# vi /etc/login.defs
# line 26: set 2 for Minimum number of days available
PASS_MIN_DAYS 2
```

3、在到期前设置警告的天数。 此设置仅在创建用户时才会产生影响，而不会影响到现有用户。 如果设置为存在用户，请运行命令“chage -W（days）（user）”

```
[root@shaonbean ~]# vi /etc/login.defs
# line 28: set 7 for number of days for warnings
PASS_WARN_AGE 7
```

4、使用过去使用的密码进行限制。 在这一代中，用户不能设置相同的密码。

```
[root@shaonbean ~]# vi /etc/pam.d/system-auth
# near line 15: prohibit to use the same password for 5 generation in past
password     sufficient     pam_unix.so sha512 shadow nullok try_first_pass use_authtok remember=5
```

5、设置最小密码长度。 用户不能将密码长度设置为小于此参数。

```
# set 8 for minimum password length
[root@shaonbean ~]# authconfig --passminlen=8 --update
# the parameter is set in a config below
[root@shaonbean ~]# grep "^minlen" /etc/security/pwquality.conf 
minlen = 8
```

6、为新密码设置所需的最少字符类数。 （种类⇒UpperCase / LowerCase / Digits / Others）

```
# set 2 for minimum number of required classes of characters
[root@shaonbean ~]# authconfig --passminclass=2 --update
# the parameter is set in a config below
[root@shaonbean ~]# grep "^minclass" /etc/security/pwquality.conf 
minclass = 2
```

7、在新密码中设置允许的连续相同字符的最大数量。

```
# set 2 for maximum number of allowed consecutive same characters
[root@shaonbean ~]# authconfig --passmaxrepeat=2 --update
# the parameter is set in a config below
[root@shaonbean ~]# grep "^maxrepeat" /etc/security/pwquality.conf 
maxrepeat = 2
```

8、在新密码中设置同一类的最大允许连续字符数。

```

# set 4 for maximum number of allowed consecutive characters of the same class
[root@shaonbean ~]# authconfig --passmaxclassrepeat=4 --update
# the parameter is set in a config below
[root@shaonbean ~]# grep "^maxclassrepeat" /etc/security/pwquality.conf 
maxclassrepeat = 4
```

9、新密码中至少需要一个小写字符

```
[root@shaonbean ~]# authconfig --enablereqlower --update
# the parameter is set in a config below
# (if you'd like to edit the value, edit it with vi and others)
[root@shaonbean ~]# grep "^lcredit" /etc/security/pwquality.conf 
lcredit = -1
```

10、新密码中至少需要一个大写字符

```
[root@shaonbean ~]# authconfig --enablerequpper --update
# the parameter is set in a config below
# (if you'd like to edit the value, edit it with vi and others)
[root@shaonbean ~]# grep "^ucredit" /etc/security/pwquality.conf 
ucredit = -1
```

11、新密码中至少需要一位数字

```
[root@shaonbean ~]# authconfig --enablereqdigit --update
# the parameter is set in a config below
# (if you'd like to edit the value, edit it with vi and others)
[root@shaonbean ~]# grep "^dcredit" /etc/security/pwquality.conf 
dcredit = -1
```

12、新密码中至少需要一个其他字符

```
[root@shaonbean ~]# authconfig --enablereqother --update
# the parameter is set in a config below
# (if you'd like to edit the value, edit it with vi and others)
[root@shaonbean ~]# grep "^ocredit" /etc/security/pwquality.conf 
ocredit = -1
```

13、在新密码中设置单调字符序列的最大长度。 （ex⇒'12345'，'fedcb'）

```
[root@shaonbean ~]# vi /etc/security/pwquality.conf
# add to the end
maxsequence = 3
```

14、设置旧密码中不能出现的新密码中的字符数。

```
[root@shaonbean ~]# vi /etc/security/pwquality.conf
# add to the end
difok = 5
```

15、检查新密码中是否包含用户passwd项的GECOS字段中长度超过3个字符的单词

```
[root@shaonbean ~]# vi /etc/security/pwquality.conf
# add to the end
gecoscheck = 1
```

16、设置不能包含在密码中的Ssace分隔列表。

```

[root@shaonbean ~]# vi /etc/security/pwquality.conf
# add to the end
badwords = denywords1 denywords2 denywords3
```

17、为新密码设置散列/密码算法。 （默认是sha512）

```
# show current algorithm
[root@shaonbean ~]# authconfig --test | grep hashing 
password hashing algorithm is md5
# chnage algorithm to sha512
[root@shaonbean ~]# authconfig --passalgo=sha512 --update
[root@shaonbean ~]# authconfig --test | grep hashing 
password hashing algorithm is sha512
```