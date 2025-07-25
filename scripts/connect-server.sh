#!/bin/bash

# IP do servidor remoto
SERVER_IP="192.168.10.1"

# Caminho do repositório no servidor remoto
REMOTE_REPO_PATH="~/Documentos/certification-cka/cka-study/configs"

# Solicita a senha do usuário
read -sp "Digite a senha para o servidor SSH: " SERVER_PASSWORD
echo

# Conectando ao servidor remoto via SSH
echo "Conectando ao servidor remoto no IP $SERVER_IP..."
sshpass -p "$SERVER_PASSWORD" ssh fabio@$SERVER_IP << EOF
    echo "Navegando até o repositório $REMOTE_REPO_PATH..."
    cd $REMOTE_REPO_PATH

    echo "Executando o comando 'vagrant ssh master-ssh1'..."
    vagrant ssh master-ssh1 -c "sudo su -c 'export KUBECONFIG=/etc/kubernetes/admin.conf && bash'"
EOFs