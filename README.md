### deploy k8s using kubeadm
```
scp kubeadm-master.config master:
cat deploy.sh | ssh master "bash -"
cat node.sh | ssh node1 "bash -"
cat node.sh | ssh node2 "bash -"

```

### Apply flannel network
```
scp kube-flannel-aliyun.yml master:
ssh master "kubectl create -f kube-flannel-aliyun.yml"
ssh master "iptables -P FORWARD ACCEPT"
ssh node1 "iptables -P FORWARD ACCEPT"
ssh node2 "iptables -P FORWARD ACCEPT"
```

