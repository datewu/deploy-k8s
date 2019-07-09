CONFIG_FILE=kubeadm-master.config

${CONFIG_FILE}:
	@echo dump kubeadm master config ${CONFIG_FILE}
	@IP="10.0.0.201" \
	M_HOSTNAME="master.k8s" \
	K8S_VER="v1.15.0" \
	CONFIG_FILE=${CONFIG_FILE} \
	./config.sh

setEnv: ${CONFIG_FILE}
	CONFIG_FILE=${CONFIG_FILE} \
	./env.sh

master: setEnv
	@echo deploy master
	cat deploy.sh | ssh m1
	@echo take note:

node:
	@echo deploy node
	@echo YOU MUST comment OUT node.sh last LINE
	cat node.sh | ssh m2
	cat node.sh | ssh m3
	cat node.sh | ssh m4

.PHONY: ${CONFIG_FILE} setEnv master node