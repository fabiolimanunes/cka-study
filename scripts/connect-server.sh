#!/bin/bash

SERVER_IP="192.168.10.148"
REMOTE_REPO_PATH="/home/fabio/Documentos/certification-cka/cka-study/configs"

read -sp "Digite a senha para o servidor SSH: " SERVER_PASSWORD
echo

echo "Conectando ao servidor remoto no IP $SERVER_IP..."
sshpass -p "$SERVER_PASSWORD" ssh -t fabio@$SERVER_IP "cd $REMOTE_REPO_PATH && vagrant ssh master-1"