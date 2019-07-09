cat >${CONFIG_FILE}<<EOF
apiVersion: kubeadm.k8s.io/v1beta2
#bootstrapTokens:
#- groups:
#  - system:bootstrappers:kubeadm:default-node-token
#  token: abcdef.0123456789abcdef
#  ttl: 24h0m0s
#  usages:
#  - signing
#  - authentication
kind: InitConfiguration
localAPIEndpoint:
  advertiseAddress: ${IP}
  bindPort: 6443
nodeRegistration:
  criSocket: /var/run/dockershim.sock
  name: ${M_HOSTNAME}
  taints:
  - effect: NoSchedule
    key: node-role.kubernetes.io/master
---
apiServer:
  timeoutForControlPlane: 4m0s
apiVersion: kubeadm.k8s.io/v1beta2
certificatesDir: /etc/kubernetes/pki
clusterName: kubernetes
controlPlaneEndpoint: ${IP}:6443
controllerManager: {}
dns:
  type: CoreDNS
etcd:
  local:
    extraArgs:
      listen-client-urls: "https://127.0.0.1:2379,https://${IP}:2379"
      advertise-client-urls: "https://${IP}:2379"
      listen-peer-urls: "https://${IP}:2380"
      initial-advertise-peer-urls: "https://${IP}:2380"
      initial-cluster: "master.k8s=https://${IP}:2380"
    serverCertSANs:
      - ${M_HOSTNAME}
      - ${IP}
    peerCertSANs:
      - ${M_HOSTNAME}
      - ${IP}
    dataDir: /var/lib/etcd

imageRepository: registry.cn-hangzhou.aliyuncs.com/google_containers
kind: ClusterConfiguration
kubernetesVersion: ${K8S_VER}
networking:
  dnsDomain: cluster.local
  podSubnet: 10.244.0.0/16
  serviceSubnet: 10.96.0.0/12
scheduler:
  extraArgs:
    feature-gates: LocalStorageCapacityIsolation=true
EOF