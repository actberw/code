#!/usr/bin/env bash
#
#脚本用于监测slave的状态, 配合crontab 使用, 默认会在slave down之后或者slave延迟超过两小时时发送通知邮件
#

STATUS=$(mysql -uusername -ppasswd -D db_name -hhost_name -e "show slave status\G"|grep -Ei '(running|second)')
# 修改username， passwd， host 为自己的slave 相应的参数
IO_env=`echo $STATUS|grep IO |awk '{print $2}'`
SQL_env=`echo $STATUS|grep SQL |awk '{print $2}'`
DELAY=`echo $STATUS|grep -i secode | awk '{print $2}'`
EMAIL=actberw@gmail.com
# 通知邮件的发送地址

((DELAY=DELAY/3600))

function is_alive() {
    if [ "$IO_env" != "Yes" ] || [ "$SQL_env" != "Yes" ]; then
        echo "SQL slave is down"
        return 1
    else
        echo "SQL slave is running"
        return 0
    fi
}

function cal_delay_time() {
    echo "SQL slave delay $DELAY hours"
    if [ $DELAY -gt 2 ]; then
        echo "SQL slave delay too long"
        return 1
    else
        return 0
    fi
}

is_alive

if [ $? != 0 ]; then
    msg="on `date +'%Y-%m-%d %H:%M:%S'`, SQL slave is down"
    echo $msg| mail -s "mysql slave problem" $EMAIL 
fi

cal_delay_time

if [ $? != 0 ]; then
    msg="on `date +'%Y-%m-%d %H:%M:%S'`, SQL slave is delay too long"
    echo $msg| mail -s "mysql slave problem" $EMAIL 
fi
