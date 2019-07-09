tmp=host.tmp
cat > ${tmp} <<EOF
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

10.0.0.201 master.k8s
10.0.0.202 node1.k8s
10.0.0.203 node2.k8s
10.0.0.204 node3.k8s
EOF
ssh m1 "hostnamectl --static set-hostname master.k8s"
ssh m2 "hostnamectl --static set-hostname node1.k8s"
ssh m3 "hostnamectl --static set-hostname node2.k8s"
ssh m4 "hostnamectl --static set-hostname node2.k8s"

scp ${tmp} m1:/etc/hosts 
scp ${tmp} m2:/etc/hosts 
scp ${tmp} m3:/etc/hosts 
scp ${tmp} m4:/etc/hosts 