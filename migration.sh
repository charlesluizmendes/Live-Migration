#!/bin/bash

# Verificar se está rodando como root
if [ "$(id -u)" != "0" ]; then
    echo "ERROR: Must run as root."
    exit 1
fi

# Verificar número correto de argumentos
if [ "$#" != "2" ]; then
    echo "Usage: $0 container user@host.to.migrate.to"
    exit 1
fi

# Verificar se CRIU está instalado e funcionando
if ! command -v criu >/dev/null 2>&1; then
    echo "ERROR: CRIU not installed"
    exit 1
fi

# Testar CRIU
if ! criu check; then
    echo "ERROR: CRIU check failed"
    exit 1
fi

name=$1
host=$2
checkpoint_dir=/tmp/checkpoint

# Limpar diretório de checkpoint se existir
if [ -e "$checkpoint_dir" ]; then
    rm -rf "${checkpoint_dir:?}/"*
fi

# Função para sincronização
do_rsync() {
    rsync -aAXHltzh --progress --numeric-ids --devices --rsync-path="sudo rsync" "$1" "$host:$1"
}

# Obtém o caminho do LXC
LXCPATH=$(lxc-config lxc.lxcpath)

# Salvar regras iptables atuais
iptables-save > /tmp/iptables.rules
ip6tables-save > /tmp/ip6tables.rules

# Sincronizar regras para máquina destino
do_rsync "/tmp/iptables.rules"
do_rsync "/tmp/ip6tables.rules"

# Criar checkpoint com suporte a TCP estabelecido
lxc-checkpoint -n "$name" -D "$checkpoint_dir" -v -v -v --tcp-established -s

# Sincronizar diretórios
do_rsync "$LXCPATH/$name/"
do_rsync "$checkpoint_dir/"

# Restaurar container no destino com as regras de firewall
ssh "$host" "sudo iptables-restore < /tmp/iptables.rules && \
             sudo ip6tables-restore < /tmp/ip6tables.rules && \
             sudo lxc-checkpoint -r -n $name -D $checkpoint_dir -v && \
             sudo lxc-wait -n $name -s RUNNING"

# Limpar arquivos temporários
rm -f /tmp/iptables.rules /tmp/ip6tables.rules
ssh "$host" "sudo rm -f /tmp/iptables.rules /tmp/ip6tables.rules"

echo "Migration completed successfully!"