#!/bin/sh

#功能: 为应用程序创建uninstall.sh文件(程序卸载脚本)
#Function: create uninstall.sh file for our program
#作者: 周圣盛
#Author: Jack Jones
#单位: 南昌大学软件学院
#Region: School of Software of Nanchang University
#创建时间: 2014-12-3
#Created date: 2014-12-3
#修改时间: 2014-12-5
#Modified date: 2014-12-5

export PATH=$PATH:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin

#检查是否设置PACKAGE_HOME
#test whether the PACKAGE_HOME is set
if [ -z "$PACKAGE_HOME" ]
then
        PACKAGE_HOME=.
fi

#判断输入参数是否正确
#test whether the arguments are proper
if [ $# -ne 1 ] && [ $# -ne 2 ]
then
        echo "Usage: ./uninstall.sh binary_file [package_dir]"
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
        echo "mkdir -p $PACKAGE_DIR"
        mkdir -p $PACKAGE_DIR
elif [ -f $PACKAGE_DIR ]
then
        echo "$PACKAGE_DIR is not a directory!"
        exit 1
fi

#创建uninstall.sh
#create uninstall.sh
if [ -e $PACKAGE_DIR/uninstall.sh ]
then
        echo "rm -rf $PACKAGE_DIR/uninstall.sh"
        rm -rf $PACKAGE_DIR/uninstall.sh
fi
echo "touch $PACKAGE_DIR/uninstall.sh"
touch $PACKAGE_DIR/uninstall.sh

#向uninstall.sh写入下列信息
#write following codes to uninstall.sh
echo "#!/bin/sh" > $PACKAGE_DIR/uninstall.sh
echo "" >> $PACKAGE_DIR/uninstall.sh
echo "PROGRAM=$PROGRAM" >> $PACKAGE_DIR/uninstall.sh
echo "DEFAULT_INSTALL_DIR=/home/$USER/$PROGRAM" >> $PACKAGE_DIR/uninstall.sh
cat $PACKAGE_HOME/template/uninstall.sh.template >> $PACKAGE_DIR/uninstall.sh

#设置可执行权限
#set executable permisson to install.sh
echo "chmod +x $PACKAGE_DIR/uninstall.sh"
chmod +x $PACKAGE_DIR/uninstall.sh

exit 0
