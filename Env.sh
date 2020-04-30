#! /bin/bash
#! Author:     guxfei@outlook.com

yum_config(){
	mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
	wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
	yum clean all && yum makecache
}


if [ $UID -eq 0 ];then
	yum_config
else
	echo "您不是root管理员，没有权限安装"
fi