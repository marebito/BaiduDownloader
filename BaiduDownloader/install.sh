#!/bin/bash

#检查是否安装gmp
$gmp=$(brew info gmp)
echo $gmp
if [$gmp in $]
then
    
fi
#检查是否安装aria2c
type aria2c >/dev/null 2>&1 || { echo >&2 "I require aria2c but it's not installed.  Aborting."; exit 1;}
#检查是否安装brew
type brew >/dev/null 2>&1 || { echo >&2 "I require aria2c but it's not installed.  Aborting."; exit 1;}

#启动aria2c服务配置(后台运行)
aria2c --conf-path="/Users/zll/.aria2/aria2.conf" -D
#启动aria2服务
aria2c
#关闭aria2c服务
ps -A|grep "aria2c"|awk '{print $1}'|xargs kill -9
