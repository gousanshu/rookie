#! /bin/bash
#! Author:     guxfei@outlook.com

yum_config(){
	mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
	wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
	yum clean all && yum makecache
}

ssh_config(){
	echo -e "请输入远程端口："
	read ssh_port
	sed -i "s/#Port 22/Port $ssh_port/" /etc/ssh/sshd_config
	systemctl restart sshd.service
	
	systemctl restart firewalld.service
	semanage port -a -t ssh_port_t -p tcp $ssh_port
	firewall-cmd --zone=public --add-port=$ssh_port/tcp --permanent
	systemctl restart firewalld.service 
}

if [ $UID -eq 0 ];then
	yum_config
	ssh_config
else
	echo "您不是root管理员，没有权限安装"
fi