# CKA Study Environment (Vagrant)

Este repositório contém a automação necessária para provisionar um cluster Kubernetes local focado em simular um ambiente realista para os estudos da **Certified Kubernetes Administrator (CKA)**.

Optamos por utilizar **Vagrant** para atingir o maior nível de realismo, pois a prova demanda experiência com componentes de Sistema Operacional (Ubuntu), reinicialização do `kubelet` via `systemd`, e acesso raiz para troubleshooting e instalação completa com o utilitário `kubeadm`.

## Pré-requisitos
*   [Vagrant](https://developer.hashicorp.com/vagrant/downloads) instalado
*   [VirtualBox](https://www.virtualbox.org/) instalado

## Como Funciona

As máquinas iniciam com o Ubuntu 24.04 LTS.
Durante a etapa de provisionamento, os scripts automaticamente instalm as pré-dependências de rede, desativam o *swap*, configuram e instalam o `containerd`, e em seguida instalem o `kubeadm`, `kubelet` e `kubectl` (na versão **v1.34**).

> **Importante:** Nós optamos por parar "no meio" propositalmente!
> O script apenas baixa as ferramentas. Cabe a você rodar o `kubeadm init`, e o `kubeadm join` nos _workers_, visto que essa é muitas vezes uma das tarefas (ou pelo menos um conhecimento exigido) na CKA.

*   `master`: 192.168.56.10
*   `worker1`: 192.168.56.11
*   `worker2`: 192.168.56.12

A porta `6443` (Kubernetes API Server) do master está exposta para o seu computador (Host) na mesma porta `6443`.

---

## 🚀 Utilização Rápida

Os comandos abaixo são acionáveis através de um simples arquivo `Makefile` contido na pasta `/vagrant`. 
Basta navegar para ela:

```bash
cd vagrant/
```

### Iniciar o Ambiente
```bash
make up
```

### Acessar as Máquinas e Iniciar o Cluster
Para acessar o master e iniciar a configuração do Kubernetes:

```bash
make ssh-master
```

Lá dentro, se você **NÃO PRECISAR** acessar o cluster de outro PC na sua rede, basta rodar:
```bash
sudo kubeadm init --apiserver-advertise-address=192.168.56.10 --pod-network-cidr=10.244.0.0/16
```

#### 🌐 Acessando via `kubectl` de OUTRO PC na sua rede local
Se você quiser gerenciar o cluster conectando o seu Notebook/PC Secundário, na hora de fazer o init você precisa dizer ao kubeadm para colocar o **IP da máquina atual (o PC que está rodando o VirtualBox)** no certificado SSL gerado para a API TLS. (Neste caso, com base na sua rede atual, o IP é `192.168.10.148`).

Dentro do bash do `master` faça:
```bash
# Como combinado, já estou setando com o IP do seu PC/Notebook na rede Wifi atual!
sudo kubeadm init --apiserver-advertise-address=192.168.56.10 --pod-network-cidr=10.244.0.0/16 --apiserver-cert-extra-sans="192.168.10.148"
```

Após o término da instalação, **para conseguir usar o comando `kubectl`** ali mesmo dentro do master, você precisa configurar a credencial de admin (conforme o kubeadm te avisa no painel final):
```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

Feito isso, teste com `kubectl get nodes`.

### 🌐 Configurando a Rede (CNI)
Você vai notar que o seu Master ficará com o status **NotReady**. Isso ocorre porque o Kubernetes precisa de um provedor de rede instalado para rotear pacotes. Instale o clássico Flannel executando no master:
```bash
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
```

### ➕ Adicionando os Workers ao Cluster
O `kubeadm init` emitido no master imprimiu na tela um comando grandão contendo um token.
Para registrar os workers, abra duas novas abas/terminais no seu PC principal e rode:
```bash
make ssh-worker1
# E na outra aba:
make ssh-worker2
```
Dentro dessas máquinas virtuais dos workers, basta colar o comando impresso usando `sudo`. Exemplo:
```bash
sudo kubeadm join 192.168.56.10:6443 --token xyz123 --discovery-token-ca-cert-hash sha256:abc456
```
*(Se perdeu o token porque limpou a tela, volte no master e rode `kubeadm token create --print-join-command`)*.

> 💡 **Conceito Importante (Dica CKA):** Note que **não copiamos** arquivos `~/.kube/config` igual fizemos no master. Por padrão na arquitetura do K8s, workers não exigem e não devem ter o utilitário `kubectl` gerindo o cluster localmente, quem faz o trabalho pesado de gerir são os Masters. 
> Se por curiosidade em testes você quiser rodar `kubectl get pods` estando plugado no shell de um worker, você deve copiar o arquivo de `/etc/kubernetes/admin.conf` do master, criar esse arquivo `.kube/config` no seu worker manualmente e colar os dados dentro!

---

### Exportar credenciais
Após o cluster ter sido criado, exiba o seu `admin.conf` para exportá-lo para sua máquina host:
```bash
cat /etc/kubernetes/admin.conf
```
Copie este arquivo, cole no `~/.kube/config` do seu OUTRO PC na rede, e **substitua o IP interno** lá dentro (que estará `192.168.56.10:6443`) pelo IP desta máquina Host (ficando: `https://192.168.10.148:6443`). O Kubernetes verificará o certificado localmente e permitirá a comunicação originada do seu PC Secundário!

### Pausar / Parar (Sem Perder Dados)
```bash
make stop
```

### Destruir e Resetar Tudo!
```bash
make destroy
```
