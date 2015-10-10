#!/bin/sh

#功能: 为应用程序创建.desktop文件(桌面快捷方式)
#Function: create .desktop file for our program
#作者: 周圣盛
#Author: Jack Jones
#单位: 南昌大学软件学院
#Region: Software College of Nanchang University
#创建时间: 2014-12-4
#Created date: 2014-12-4
#修改时间: 2014-12-4
#Modified date: 2014-12-4

export PATH=$PATH:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin

#检查是否设置了PACKAGE_HOME
#test whether the PACKAGE_HOME is set
if [ -z "$PACKAGE_HOME" ]
then
        #如果没有设置，则使用当前目录作为package的家目录
        #if not set, consider the current directory as the home of package
        PACKAGE_HOME=.
fi

#判断输入参数是否正确
#test whether the arguments are proper
if [ $# -ne 1 ] && [ $# -ne 2 ]
then
        echo "Usage: ./install.sh binary_file [package_dir]"
        exit 1
fi

#接收二进制文件名
#get the program name
PROGRAM=$1

#如果用户没有指定打包路径，则使用默认打包目录
#if the PACKAGE_DIR is not set, use the default PACKAGE_DIR
if [ $# -eq 1 ]
then
        PACKAGE_DIR=${PROGRAM}Installer
else
        PACKAGE_DIR=$2
fi

#测试打包目录是否存在
#test whether the PACKAGE_DIR exists
if [ ! -e $PACKAGE_DIR ]
then
        mkdir -p $PACKAGE_DIR
elif [ -f $PACKAGE_DIR ]
then
        echo "$PACKAGE_DIR is not a directory!"
        exit 1
fi

#创建$PROGRAM.desktop文件
#create $PROGRAM.desktop
if [ -e $PACKAGE_DIR/software/$PROGRAM.desktop ]
then
        echo "rm -rf $PACKAGE_DIR/$PROGRAM.desktop"
        rm -rf $PACKAGE_DIR/$PROGRAM.desktop
fi
echo "touch $PACKAGE_DIR/$PROGRAM.desktop"
touch $PACKAGE_DIR/$PROGRAM.desktop

#向$PROGRAM.desktop写入下列信息
#write following codes to $PROGRAM.desktop
echo "\
#!/usr/bin/env xdg-open
[Desktop Entry]
Type=Application
Version=1.0
Terminal=false
Name=$PROGRAM
Comment=Run $PROGRAM
" > $PACKAGE_DIR/$PROGRAM.desktop

#设置图标
#set icon
DEFAULT_ICON=icon.ico
read -p "Please input desktop icon:[$DEFAULT_ICON] " ICON
if [ -z "$ICON" ]
then
        ICON=$DEFAULT_ICON
        echo "cp $ICON $PACKAGE_DIR"
        cp $ICON $PACKAGE_DIR
else
        echo "cp $ICON $PACKAGE_DIR/icon.ico 2>/dev/null"
        cp $ICON $PACKAGE_DIR/icon.ico 2>/dev/null
fi

#设置可执行权限
#set executable permisson to $PROGRAM.desktop
echo "chmod +x $PACKAGE_DIR/$PROGRAM.desktop"
chmod +x $PACKAGE_DIR/$PROGRAM.desktop

exit 0
