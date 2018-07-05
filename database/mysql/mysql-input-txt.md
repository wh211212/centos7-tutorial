# mysql表字段导入文本数据

load data infile '/data/mysql/tysx_s/filter.txt' into table aniu_message_filter lines terminated by'\r\n' (name);