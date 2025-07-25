#!/bin/bash

# Arquivo .zshrc do usuário
ZSHRC="$HOME/.zshrc"

# Aliases do kubectl
ALIASES=$(cat <<EOF

# Alias para kubectl
alias kg='kubectl get'
alias kgp='kubectl get pods'
alias kdp='kubectl describe pod'
alias kep='kubectl edit pod'
alias kgd='kubectl get deploy'
alias kdd='kubectl decribe deploy'
alias ked='kubectl edit deploy'
alias kgs='kubectl get secret'
alias kds='kubectl describe secret'
alias kes='kubectl edit secret'
alias kgsvc='kubectl get service'
alias kesvc='kubectl edit service'
alias kdsvc='kubectl describe service'
alias kgcm='kubectl get secret'
alias kecm='kubectl edit secret'
alias kdcm='kubectl describe secret'
alias kga='kubectl get all'
alias kd='kubectl describe'
alias kdel='kubectl delete'
alias ka='kubectl apply -f'
alias ke='kubectl edit'
alias kl='kubectl logs'
alias kpf='kubectl port-forward'


EOF
)

# Adiciona os aliases ao .zshrc se ainda não estiverem presentes
if ! grep -q "Alias para kubectl" "$ZSHRC"; then
  echo "Adicionando aliases para kubectl no $ZSHRC..."
  echo "$ALIASES" >> "$ZSHRC"
  echo "Aliases adicionados com sucesso!"
else
  echo "Aliases já existem no $ZSHRC. Nada foi alterado."
fi

# Carregar o arquivo atualizado
echo "Recarregando o .zshrc..."
source "$ZSHRC"

echo "Tudo pronto! Agora você pode usar os aliases do kubectl."
