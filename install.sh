#!/bin/sh

#功能: 为应用程序创建install.sh文件(程序安装脚本)
#Function: create install.sh file for our program
#作者: 周圣盛
#Author: Jack Jones
#单位: 南昌大学软件学院
#Region: School of Software of Nanchang University
#创建时间: 2014-12-4
#Created date: 2014-12-4
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
        echo "Usage: ./install.sh binary_file [package_dir]"
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
fi

#创建install.sh
#create install.sh
if [ -e $PACKAGE_DIR/install.sh ]
then
        echo "rm -rf $PACKAGE_DIR/install.sh"
        rm -rf $PACKAGE_DIR/install.sh
fi
echo "touch $PACKAGE_DIR/install.sh"
touch $PACKAGE_DIR/install.sh

#向install.sh写入下列信息
#write following codes to install.sh
echo "#!/bin/sh" > $PACKAGE_DIR/install.sh
echo "" >> $PACKAGE_DIR/install.sh
echo "#$PROGRAM安装脚本" >> $PACKAGE_DIR/install.sh
echo "" >> $PACKAGE_DIR/install.sh
echo "PROGRAM=$PROGRAM" >> $PACKAGE_DIR/install.sh
echo "DEFAULT_INSTALL_DIR=/home/$USER/$PROGRAM" >> $PACKAGE_DIR/install.sh
cat $PACKAGE_HOME/template/install.sh.template >> $PACKAGE_DIR/install.sh

#设置可执行权限
#set executable permisson to install.sh
echo "chmod +x $PACKAGE_DIR/install.sh"
chmod +x $PACKAGE_DIR/install.sh

exit 0
