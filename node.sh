#! /usr/bin/bash
hostname
swapoff -a && sed -i '/ swap / s/^/#/' /etc/fstab
setenforce 0
systemctl disable firewalld && systemctl stop firewalld
#### should run after ali-vpc-flannel-ds deployed
#### and on every node
iptables -P FORWARD ACCEPT
#iptables -P INPUT ACCEPT
#iptables -P OUTPUT ACCEPT

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
yum install -y docker kubelet kubeadm kubectl kubernetes-cni
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
vm.swappiness=0
net.ipv4.ip_forward = 1
EOF
sysctl --system

systemctl enable docker && systemctl start docker
systemctl enable kubelet && systemctl start kubelet

DOCKER_CGROUPS=$(docker info | grep 'Cgroup' | cut -d' ' -f3)
cat >/etc/sysconfig/kubelet<<EOF
KUBELET_EXTRA_ARGS="--cgroup-driver=$DOCKER_CGROUPS --pod-infra-container-image=registry.cn-hangzhou.aliyuncs.com/google_containers/pause-amd64:3.1"
EOF
systemctl daemon-reload
systemctl restart kubelet

cat  <<EOF > /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

172.16.0.5 master.k8s
172.16.0.9 node1.k8s
172.16.0.16 node2.k8s
EOF
