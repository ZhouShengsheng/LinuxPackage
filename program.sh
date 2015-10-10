#!/bin/sh

#功能: 为一个二进制文件生成相应的.sh文件，解决程序运行时的库依赖问题
#Function: create an .sh file for a binary file to deal with the liarary dependecy probrom
#作者: 周圣盛
#Author: Jack Jones
#单位: 南昌大学软件学院
#Region: School of Software of Nanchang University
#时间: 2014-12-3
#Date: 2014-12-3
#修改时间: 2014-12-5
#Modified date: 2014-12-5


export PATH=$PATH:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin

#检查是否设置PACKAGE_HOME
#test whether the PACKAGE_HOME is set
if [ -z "$PACKAGE_HOME" ]
then
        PACKAGE_DIR=${PROGRAM}Installer
fi

#判断输入参数是否正确
#test whether the arguments are proper
if [ $# -ne 1 ] && [ $# -ne 2 ]
then
        echo "Usage: ./program.sh binary_file [lib_dir]"
        exit 1
fi

#接收二进制文件名
#get the program name
PROGRAM=$1

#如果用户没有指定打包路径，则默认在当前目录打包
#if the PACKAGE_DIR is not set, use the default PACKAGE_DIR
if [ $# -eq 1 ]
then
        PACKAGE_DIR=${PROGRAM}Installer
else
        PACKAGE_DIR=$2
fi

if [ ! -e $PACKAGE_DIR ]
then
        echo "mkdir -p PACKAGE_DIR"
        mkdir -p PACKAGE_DIR
elif [ -f $PACKAGE_DIR ]
then
        echo "$PACKAGE_DIR is not a directory!"
        exit 1
fi

#创建$PROGRAM.sh
#create $PROGRAM.sh
if [ -e $PACKAGE_DIR/$PROGRAM.sh ]
then
        echo "rm -rf $PACKAGE_DIR/$PROGRAM.sh"
        rm -rf $PACKAGE_DIR/$PROGRAM.sh
fi
echo "touch $PACKAGE_DIR/$PROGRAM.sh"
touch $PACKAGE_DIR/$PROGRAM.sh

#向$PROGRAM.sh写入下列信息
#write following codes to $PROGRAM.sh
cat $PACKAGE_HOME/template/program.sh.template > $PACKAGE_DIR/$PROGRAM.sh
echo "PROGRAM=$PROGRAM" >> $PACKAGE_DIR/$PROGRAM.sh
echo 'exec "$DIR/$PROGRAM" ${1+"$@"}' >> $PACKAGE_DIR/$PROGRAM.sh

#设置可执行权限
#set executable permisson to install.sh
echo "chmod +x $PACKAGE_DIR/$PROGRAM.sh"
chmod +x $PACKAGE_DIR/$PROGRAM.sh

#复制$PROGRAM.sh至打包目录
#copy $PROGRAM.sh to $PACKAGE_DIR
echo "cp $PROGRAM $PACKAGE_DIR"
cp $PROGRAM $PACKAGE_DIR

exit 0
