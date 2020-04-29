# deploy k8s using kubeadm

```shell
make master
# note down kubeadm JOIN TOKEN
# to join worker nodes
make node
```

## Apply flannel network

```shell
scp kube-flannel-aliyun.yml master:
ssh master "kubectl create -f kube-flannel-aliyun.yml"
ssh master "iptables -P FORWARD ACCEPT"
ssh node1 "iptables -P FORWARD ACCEPT"
ssh node2 "iptables -P FORWARD ACCEPT"
```

## kubeadm config debug

```shell
kubeadm config print init-defaults
```
