# Paso 1: Instalación del Cluster Kubernetes y Minikube

# 1.1 Actualizar e instalar dependencias necesarias
dnf makecache --refresh
dnf update -y
reboot

# 1.2 Desactivar SELinux
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
getenforce  # Verificación

# 1.3 Cargar módulos del kernel y configurarlos
modprobe overlay
modprobe br_netfilter
echo -e "overlay\nbr_netfilter" | tee /etc/modules-load.d/k8s.conf
lsmod | grep overlay  # Verificación
lsmod | grep br_netfilter  # Verificación

# 1.4 Configurar parámetros sysctl
echo -e "net.ipv4.ip_forward = 1\nnet.bridge.bridge-nf-call-ip6tables = 1\nnet.bridge.bridge-nf-call-iptables = 1" | tee /etc/sysctl.d/k8s.conf
sysctl --system
sysctl net.ipv4.ip_forward  # Verificación
sysctl net.bridge.bridge-nf-call-ip6tables  # Verificación
sysctl net.bridge.bridge-nf-call-iptables  # Verificación

# 1.5 Desactivar swap
swapoff -a
sed -i '/swap/d' /etc/fstab
swapon --show  # Verificación

# 1.6 Instalar Docker (CRI)
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
dnf install -y containerd.io
mkdir /etc/containerd
containerd config default | tee /etc/containerd/config.toml
sed -i 's/            SystemdCgroup = false/            SystemdCgroup = true/' /etc/containerd/config.toml
systemctl enable --now containerd.service
systemctl restart containerd.service
systemctl status containerd.service  # Verificación

# 1.7 Configurar firewall
firewall-cmd --permanent --add-port={6443,2379,2380,10250,10251,10252,5473}/tcp
firewall-cmd --reload
firewall-cmd --list-all  # Verificación

# 1.8 Instalar Kubernetes
cat <<EOF | tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.28/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.28/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
EOF
dnf makecache
dnf install -y kubelet-1.28.3-0 kubeadm-1.28.3-0 kubectl-1.28.3-0 --disableexcludes=kubernetes
systemctl enable --now kubelet.service
kubectl version --client  # Verificación
systemctl status kubelet  # Verificación

# 1.9 Inicializar el control plane
kubeadm config images pull
kubeadm init --pod-network-cidr=10.10.0.0/16

# 1.10 Configurar kubectl
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
kubectl get nodes  # Verificación

# 1.11 Instalar CNI (Calico)
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/tigera-operator.yaml
curl -O https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/custom-resources.yaml
sed -i 's/cidr: 192\.168\.0\.0\/16/cidr: 10.10.0.0\/16/g' custom-resources.yaml
kubectl create -f custom-resources.yaml
kubectl get pods -n calico-system  # Verificación

# 1.12 Añadir nodos Worker (Ejecutar en cada nodo Worker)
# Reemplazar '10.10.0.1' con la IP del nodo Master y 'abcdef.1234567890abcdef' con el token generado por 'kubeadm token create --print-join-command'
# Reemplazar 'sha256:0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef' con el valor de 'discovery-token-ca-cert-hash' generado por 'kubeadm init'
# Ejecutar el siguiente comando en cada nodo Worker
# kubeadm join 10.10.0.1:6443 --token abcdef.1234567890abcdef --discovery-token-ca-cert-hash sha256:0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef

# 1.13 Activar Minikube (para emergencia)
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
install minikube-linux-amd64 /usr/local/bin/minikube
minikube start --driver=none
minikube status  # Verificación