#!/bin/bash

#内存总大小
nczong=`free -m | grep "Mem:" | awk '{print $2}'`
#使用内存大小
neicun=`free -m | grep "Mem:" | awk '{print $3}'`
#计算内存使用率
a=`expr $nczong / 100`
neucunlv=`expr $neicun / $a`
#查看CPU使用率
b=`vmstat | grep "2" | awk '{print $15}'`
cpu=$(expr 100 - $b)
#查看磁盘大小
cipan=`df -Th | grep "/$" | awk '{print $6}' | awk -F % '{print $1}'`

if [ $neicunlv > 90 ]
then
  echo "内存使用率超过90%，可能影响到正常使用"
  echo "内存使用率超过90%，可能影响到正常使用" >> /root/警告.txt
  # echo "内存使用率超过90%，可能影响到正常使用"| mail -s "Linus警告" monitor@abc.com
fi
if [ $cipan -ge 90 ]
then
  echo "磁盘使用率超过90%，可能影响到正常使用"
  echo "磁盘使用率超过90%，可能影响到正常使用" >> /root/警告.txt
  # echo "磁盘使用率超过90%，可能影响到正常使用"| mail -s "Linus警告" monitor@abc.com
fi
if [ $cpu -ge 80 ]
then
  echo "CPU使用率超过80%，可能影响到正常使用"
  echo "CPU使用率超过80%，可能影响到正常使用" >> /root/警告.txt