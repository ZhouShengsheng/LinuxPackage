#!/bin/sh

#功能: 为一个二进制文件生成安装程序并打包
#Function: create an installization program for a binary file and package it
#作者: 周圣盛
#Author: Jack Jones
#单位: 南昌大学软件学院
#Region: Software College of Nanchang University
#时间: 2014-12-3
#Date: 2014-12-3
#修改时间: 2014-12-5
#Modified date: 2014-12-5


export PATH=$PATH:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin

#检查是否设置PACKAGE_HOME
#test whether the PACKAGE_HOME is set
if [ -z "$PACKAGE_HOME" ]
then
        echo "PACKAGE_HOME is not set, use ."
        PACKAGE_HOME=.
else
        echo "PACKAGE_HOME is set"
fi

#判断输入参数是否正确
#test whether the arguments are proper
if [ $# -ne 1 ] && [ $# -ne 2 ]
then
        echo "Usage: package(or package.sh) binary_file [package_dir]"
        exit 1
fi

#接收程序名称
#get the program name
PROGRAM=$1
if [ ! -f "$PROGRAM" ] && [ ! -x "$PROGRAM" ]
then
        echo "$PROGRAM is not a binary_file!"
        exit 1
fi
#复制程序到当前目录
#copy program to current directory
cp -r $PROGRAM . 2>/dev/null
#去掉程序名称的路径
#remove the path of the program
PROGRAM=`echo -n $PROGRAM | sed 's,^.*/,,'`
echo "Program: $PROGRAM"

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
        mkdir -p $PACKAGE_DIR
elif [ -f $PACKAGE_DIR ]
then
        echo "$PACKAGE_DIR is not a directory!"
        exit 1
elif [ -d $PACKAGE_DIR ]
then
        rm -rf $PACKAGE_DIR/*
fi
echo "Installer dir: $PACKAGE_DIR"
echo ""

#不可以在打包程序目录为其他程序打包
#can't package in the PACKAGE_HOME
if [ -e "./package.sh" ]
then
        echo "can't create package in the PACKAGE_HOME($PACKAGE_HOME)!"
        exit 1
fi

#解决库依赖
#get libraries
echo "try to get libraries..."
if [ -e $PACKAGE_HOME/getlibs.sh ]
then
        $PACKAGE_HOME/getlibs.sh $PROGRAM $PACKAGE_DIR/software
        if [ $? -eq 1 ]
        then
                echo "getlis failed!"
                exit 1
        fi
else
        echo "failed! not found getlibs!"
        exit 1
fi
echo "get libraries successfull!"
echo ""

#为程序创建.sh脚本，解决程序在执行时的库依赖问题
#create $PROGRAM.sh
echo "try to create $PROGRAM.sh..."
if [ -e $PACKAGE_HOME/program.sh ]
then
        $PACKAGE_HOME/program.sh $PROGRAM $PACKAGE_DIR/software
        if [ $? -eq 1 ]
        then
                echo "create $PROGRAM.sh failed!"
                exit 1
        fi
else
        echo "failed! not found program.sh!"
        exit 1
fi
echo "$PROGRAM.sh created!"
echo ""

DEFAULT_NEED_DESKTOP="y"
read -p "Need .desktop file?(Y/n):[$DEFAULT_NEED_DESKTOP] " NEED_DESKTOP
if [ -z "$NEED_DESKTOP" ]
then
        NEED_DESKTOP=$DEFAULT_NEED_DESKTOP
fi
if [ "$NEED_DESKTOP" = "Y" ] || [ "$NEED_DESKTOP" = "y" ]
then
        #为程序创建.desktop桌面快捷方式
        #create .desktop
        echo "try to create $PROGRAM.desktop..."
        if [ -e $PACKAGE_HOME/desktop.sh ]
        then
                $PACKAGE_HOME/desktop.sh $PROGRAM $PACKAGE_DIR/software
                if [ $? -eq 1 ]
                then
                        echo "create $PROGRAM.Desktop failed!"
                        exit 1
                fi
        else
                echo "failed! not found desktop.sh!"
                exit 1
        fi

        echo "$PROGRAM.desktop created!"
        echo ""
fi

#为程序创建install.sh安装脚本
echo "try to create install.sh..."
#create install.sh
if [ -e $PACKAGE_HOME/install.sh ]
then
        $PACKAGE_HOME/install.sh $PROGRAM $PACKAGE_DIR
        if [ $? -eq 1 ]
        then
                echo "create install.sh failed!"
                exit 1
        fi
else
        echo "failed! not found install.sh!"
        exit 1
fi
echo "install.sh created!"
echo ""

#为程序创建uninstall.sh卸载脚本
#create uninstall.sh
echo "try to create uninstall.sh..."
if [ -e $PACKAGE_HOME/uninstall.sh ]
then
        $PACKAGE_HOME/uninstall.sh $PROGRAM $PACKAGE_DIR
        if [ $? -eq 1 ]
        then
                echo "create uninstall.sh failed!"
                exit 1
        fi
else
        echo "failed! not found uninstall.sh!"
        exit 1
fi
echo "uninstall.sh created!"
echo ""

#复制README
#copy README
if [ -d $PACKAGE_HOME/readme ]
then
        echo "cp -r $PACKAGE_HOME/readme/* $PACKAGE_DIR"
        cp -r $PACKAGE_HOME/readme/* $PACKAGE_DIR
fi

echo "package created!"
echo ""

#压缩安装包
#compress the installer
DEFAULT_NEED_COMPRESS="y"
read -p "do you need compress the package to ${PACKAGE_DIR}.tar.gz?(Y/n):[y] " NEED_COMPRESS
if [ -z "$NEED_COMPRESS" ]
then
        NEED_COMPRESS=$DEFAULT_NEED_COMPRESS
fi
if [ "$NEED_COMPRESS" = "Y" ] || [ "$NEED_COMPRESS" = "y" ]
then
        echo "try to compress the package to ${PACKAGE_DIR}.tar.gz..."
        echo "tar -zcvf ${PACKAGE_DIR}.tar.gz $PACKAGE_DIR"
        tar -zcvf ${PACKAGE_DIR}.tar.gz $PACKAGE_DIR
        echo "${PACKAGE_DIR}.tar.gz created!"
        echo ""
fi
NEED_COMPRESS=""
read -p "do you need compress the package to ${PACKAGE_DIR}.tar.bz2?(Y/n):[y] " NEED_COMPRESS
if [ -z "$NEED_COMPRESS" ]
then
        NEED_COMPRESS=$DEFAULT_NEED_COMPRESS
fi
if [ "$NEED_COMPRESS" = "Y" ] || [ "$NEED_COMPRESS" = "y" ]
then
        echo "try to compress the package to ${PACKAGE_DIR}.tar.bz2..."
        echo "tar -jcvf ${PACKAGE_DIR}.tar.bz2 $PACKAGE_DIR"
        tar -jcvf ${PACKAGE_DIR}.tar.bz2 $PACKAGE_DIR
        echo "${PACKAGE_DIR}.tar.bz2 created!"
        echo ""
fi

