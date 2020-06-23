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

k8s_config(){
	systemctl stop firewalld.service && systemctl disable firewalld.service
	sed -i 's/enforcing/Permissive/' /etc/selinux/config && setenforce 0 
	sed 's/^\/dev\/mapper\/centos-swap/#\/dev\/mapper\/centos-swap/' /etc/fstab && swapoff -a 
	wget https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo -O /etc/yum.repos.d/docker-ce.repo
	yum -y install docker-ce-18.06.1.ce-3.el7 && systemctl enable docker && systemctl start docker

	cat >> /etc/hosts << EOF
192.168.49.139 master
192.168.49.142 node142
192.168.49.155 node155
EOF

	cat > /etc/sysctl.d/k8s.conf << EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
	sysctl --system
}

if [ $UID -eq 0 ];then
	yum_config;
	k8s_config;
else
	echo "您不是root管理员，没有权限安装"
fi