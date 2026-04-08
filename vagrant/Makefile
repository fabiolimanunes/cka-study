.PHONY: up stop halt destroy status ssh-master ssh-worker1 ssh-worker2

# Inicia as VMs (cria se não existirem) e executa o provisionamento (scripts)
up:
	vagrant up

# Para as VMs de forma graciosa (Desliga / Halt)
stop: halt
halt:
	vagrant halt

# Destrói as VMs e perde todo o estado do cluster
destroy: delete
delete:
	vagrant destroy -f

# Verifica o status atual das VMs
status:
	vagrant status

# Acessa rapidamente as VMs via SSH
ssh-master:
	vagrant ssh master

ssh-worker1:
	vagrant ssh worker1

ssh-worker2:
	vagrant ssh worker2
