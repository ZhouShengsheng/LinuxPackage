#!/bin/sh

#功能: 获取二进制文件依赖的所有库文件和库文件的符号链接文件
#Function: get symblinks and libraries of a binary file
#作者: 周圣盛
#Author: Jack Jones
#单位: 南昌大学软件学院
#Region: Software College of Nanchang University
#创建时间: 2014-12-3
#Created date: 2014-12-3
#修改时间: 2014-12-4
#Modified date: 2014-12-4


export PATH=$PATH:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin

#判断输入参数是否正确
#test whether the arguments are proper
if [ $# -ne 1 ] && [ $# -ne 2 ]
then
        echo "Usage: ./getlibs binary_file [lib_dir]"
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

#getLinks(): 获取二进制文件所需要的所有库文件链接
#            get all symbol link files of every lib for a binary file
getLinks()
{
        #获取系统中的ldd信息用于测试ldd是否存在
        #get the info of ldd to test whether the ldd exsists
        ldd=`type ldd 2> /dev/null` || ldd=
        #测试ldd是否存在
        #test whether the ldd exsists
        if [ -n "$ldd" ]
        then
                #(1) 使用ldd获取二进制文件依赖的库文件信息
                #    use ldd to get library info of a binary file
                #(2) 获取具有路径的库链接文件，没有路径的库链接文件由内核提供，不需要复制
                #    get the link files which starts with /
                #(3) 删除路径前面的名称及其他字符
                #    delete the name before the path
                #(4) 删除路径之前的所有字符
                #    delete all the characters before the path
                #(5) 删除路径之前的所有空白字符
                #    delete all the white charaters before the path
                #(6) 删除末尾的括号以及括号里的内容
                #    delete all the charaters in the last bracket and also the bracket
                ldd $1 \
                | grep '/' \
                | sed 's,^.*=> ,,' \
                | sed -r 's,^[^/]+/,/,' \
                | sed -r 's,^[[:space:]]+/,/,' \
                | sed 's, (.*),,'
        else
                #ldd不存在则结束程序
                #exit if there is not a ldd
                echo "failed! ldd not found!"
                exit 1
        fi
}

#getLib(): 获取库文件符号链接所对应的真实文件
#          get real file of a symbol link file 
getLib()
{
        #测试传递的文件是否为符号链接文件
        #test to see whether the given file is a symbolic link file
	if [ -L "$1" ]
	then
	        #获取符号链接的绝对路径
	        #get the absolute path of the given symbolink file
	        #(1) 使用ls -l获得文件的完整路径信息
                #    use ls -l to get the absolute path of the given file
                #(2) 删除路径前面的名称及其他字符
                #    delete all the characters before the path
                #(3) 删除从" -> "到末尾的所有字符
                #    delete all the characters after " -> " also with " -> "
		link=`ls -l $1 \
		| sed 's,^[^/]*/,/,' \
		| sed 's, ->.*$,,'`
		#获取符号链接指向的库文件
		#get the real library file pointed by the given symbolink file
		#(1) 使用ls -l获得文件的完整路径信息
                #    use ls -l to get the absolute path of the given file
                #(2) 删除从" -> "到末尾的所有字符
                #    delete all the characters after " -> " also with " -> "
                #(3) 删除末尾的*(比如Ubuntu)
                #    delete the last *(for Ubuntu)
		lib=`ls -l $1 \
		| sed 's,^.* -> ,,' \
		| sed 's,\*$,,'`
		#测试库文件是否以/开头，如果以/开头则库文件与符号链接文件不在同一个目录中
		#test whether the library file is in the same directory with the symbolink file
		isInDifferentDir=`echo $lib | grep '^/'`
		if [ -n "$isInDifferentDir" ]
		then
		        #如果不在同一个目录，则直接打印
		        #if not in the same directory, print it
			echo $lib
			return 1
		else
		        #如果在同一个目录，则给库文件加上目录
		        #if in the same directory, add path to the library file
		        #(1) 使用ls -l获得文件的完整路径信息
                        #    use ls -l to get the absolute path of the given file
                        #(2) 删除从第一个/到"-> "之间的字符
                        #    delete all the characters between the first / and the "-> "
                        #(3) 删除路径之前的所有字符
                        #    delete all the characters before the path
			lib=`ls -l $1 \
        			| sed 's,/[^/]*-> ,/,' \
        			| sed -r 's,^[^/]+/,/,'`
        		echo $lib
		fi
	else
		echo $1
	fi
	return 0
}

#建立libs文件夹
#make libs directory
if [ -e "$PACKAGE_DIR/libs" ]
then
        echo "rm -rf $PACKAGE_DIR/libs"
        rm -rf $PACKAGE_DIR/libs
fi
echo "mkdir -p $PACKAGE_DIR/libs"
mkdir -p $PACKAGE_DIR/libs

#获取库文件与链接文件(因为链接文件也需要复制)
#get libs and links(because links need to be copied too)
links=`getLinks $PROGRAM`
for link in $links
do
        lib=`getLib $link`
        #记录getLib()函数的返回值
        #save the return value of getLib()
        retval=$?
        #复制库文件到库目录
        #copy library file
        echo "cp $lib $PACKAGE_DIR/libs"
        cp $lib $PACKAGE_DIR/libs
        #测试返回值
        #test the return value
        if [ $retval -eq 0 ]
        then
                #如果返回值为0，则直接复制符号链接文件
                #if retval equals 0, copy the symbolink file
                echo "cp -P $link $PACKAGE_DIR/libs"
        	cp -P $link $PACKAGE_DIR/libs
        else
                #如果返回值为1，则创建符号链接
                #else, create a symbolink file
                #(1) 去除符号链接的路径
                #    remove the path of the symbolink file
                #(2) 去除库文件的路径
                #    remove the path of the library file
                #(4) 创建符号链接
                #    create a symbolink file for the library file
        	link=`echo $link | sed 's,^.*/,,'`
        	lib=`echo $lib | sed 's,^.*/,,'`
        	echo "ln -s $lib $PACKAGE_DIR/libs/$link"
        	ln -s $lib $PACKAGE_DIR/libs/$link
        fi
done

exit 0
