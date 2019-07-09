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

#kubeadm join 10.0.0.88:6443 --token yjm0ud.pg3vzz6l37y665x0 --discovery-token-ca-cert-hash sha256:90d9b4a99f82ecaaf04f15ea8dd0729617740dc3b016a9e12dd8039527d20b60
#kubeadm join 10.0.0.88:6443 --token yjm0ud.pg3vzz6l37y665x0 --discovery-token-ca-cert-hash sha256:90d9b4a99f82ecaaf04f15ea8dd0729617740dc3b016a9e12dd8039527d20b60