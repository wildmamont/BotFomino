#!/bin/bash
STILL_LOGGED=`last -F |grep still|wc -l`
if [ "$STILL_LOGGED" -ne "0" ]; then 
 exit
fi
UPTIME=`awk '{ print $1 }' /proc/uptime`
len=`expr index "$UPTIME" .`
uptimes=${UPTIME:0:$len-1} 
PING=`ping -c 5 ya.ru 2>&1 `
PING_RES=$?
if [ "$PING_RES" -ne "0" ] && [ $uptimes -gt 900 ]; then
 sleep 60
### echo  second test
  PING2=`ping -c 5 ya.ru 2>&1`
  PING_RES2=$?
    if [ "$PING_RES2" -ne "0" ]; then
     echo REBOOT
#     echo -n '1-1.3' /sys/bus/usb/drivers/usb/unbind
     /sbin/shutdown -r
     fi
  fi
