cat >${CONFIG_FILE}<<EOF
apiVersion: kubeadm.k8s.io/v1alpha2
kind: MasterConfiguration
kubernetesVersion: ${K8S_VER}
imageRepository: registry.cn-hangzhou.aliyuncs.com/google_containers

apiServerCertSANs:
- "master.k8s"
- "${IP}"
- "127.0.0.1"

api:
  advertiseAddress: ${IP}
  #controlPlaneEndpoint: 172.16.0.5:8443
  controlPlaneEndpoint: ${IP}:6443

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

controllerManagerExtraArgs:
  node-monitor-grace-period: 10s
  pod-eviction-timeout: 10s

networking:
  podSubnet: 10.244.0.0/16
  
kubeProxy:
  config:
    mode: ipvs
    #mode: iptables
EOF