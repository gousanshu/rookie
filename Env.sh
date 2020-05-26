#! /bin/bash
#! Author:     guxfei@outlook.com

yum_config(){
	mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
	wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
	yum clean all && yum makecache
}

ssh_config(){
	sed -i 's/#Port 22/Port 222/' /etc/ssh/sshd_config
	systemctl restart sshd.service
	semanage port -a -t ssh_port_t -p tcp 222
	firewall-cmd --zone=public --add-port=222/tcp --permanent
	systemctl start firewalld.service 
}


if [ $UID -eq 0 ];then
	yum_config
	ssh_config
else
	echo "您不是root管理员，没有权限安装"
fi