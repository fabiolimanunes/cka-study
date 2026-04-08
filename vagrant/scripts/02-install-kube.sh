#!/bin/bash
set -e

K8S_VERSION="v1.34"

echo "=== Instalando dependências e adicionando Repositório Kubernetes ${K8S_VERSION} ==="
apt-get update
apt-get install -y apt-transport-https ca-certificates curl gpg

mkdir -p /etc/apt/keyrings
if [ ! -f /etc/apt/keyrings/kubernetes-apt-keyring.gpg ]; then
    curl -fsSL "https://pkgs.k8s.io/core:/stable:/${K8S_VERSION}/deb/Release.key" | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
fi

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/${K8S_VERSION}/deb/ /" | tee /etc/apt/sources.list.d/kubernetes.list

echo "=== Instalando kubeadm, kubelet, kubectl ==="
apt-get update
apt-get install -y kubelet kubeadm kubectl

# Prevents automated apt upgrades from changing k8s versions (important for CKA)
apt-mark hold kubelet kubeadm kubectl

echo "=== Componentes do Kubernetes Instalados! ==="
