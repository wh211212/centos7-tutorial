#!/bin/sbin

#functions:install cmd_track scripts
#date:2016-04-05
#auther:shaonbean
#set -x
# Check if user is root
   if [ $(id -u) -ne "0" ]; then
       echo "Error: You must be root to run this script, please use root to install "
       exit 1
   fi
#
cmd_path=/etc/profile.d
log_path=/etc/rsyslog.d
#
cat > $cmd_path/cmd.sh << 'EOF'
################################################
# cmd track
################################################
# CHANGELOG
#May 22, 2014  JY: * Initial Create
################################################


declare -x REAL_LOGNAME=`/usr/bin/who am i | cut -d" " -f1`
declare -x REAL_IP=`/usr/bin/who -u am i | awk '{print $NF}'|sed -e 's/[()]//g'`
if [ $USER == root ]; then
        declare -x PROMT="#"
  else
        declare -x PROMT="$"
fi


#if [ x"$SSH_USER" == x ]; then
#        declare -x REMOTE_USER=UNKNOW
#  else
#        declare -x REMOTE_USER=$SSH_USER
#fi


LAST_HISTORY="$(history 1)"
__LAST_COMMAND="${LAST_HISTORY/*:[0-9][0-9] /}"


declare -x h2l='
    THIS_HISTORY="$(history 1)"
    __THIS_COMMAND="${THIS_HISTORY/*:[0-9][0-9] /}"
    if [ "$LAST_HISTORY" != "$THIS_HISTORY" ];then
        __LAST_COMMAND="$__THIS_COMMAND"
        LAST_HISTORY="$THIS_HISTORY"
        logger -p local4.notice -i -t $REAL_LOGNAME $REAL_IP "[$USER@$HOSTNAME $PWD]$PROMT $__LAST_COMMAND"
    fi'
trap "$h2l" DEBUG
EOF
#####
if [ -d $log_path ];then
    echo "$log_path does exist"
  else 
    mkdir -p $log_path
fi
#
cat > $log_path/10-cmd_track.conf << 'EOF'
# Log nc_profile generated CMD log messages to file
local4.notice /var/log/cmd_track.log
#:msg, contains, "REM" /var/log/cmd_track.log


# Uncomment the following to stop logging anything that matches the last rule.
# Doing this will stop logging kernel generated UFW log messages to the file
# normally containing kern.* messages (eg, /var/log/kern.log)
& ~
EOF
#
systemctl restart rsyslog && source /etc/profile
