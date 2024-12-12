#!/bin/sh
 
# Apaga conteúdo do diretório checkpoint se ele existir, para evitar erros
if [ -e /tmp/checkpoint/ ]; then
  rm -rf /tmp/checkpoint/*
fi
usage() {
  echo $0 container user@host.to.migrate.to
  exit 1
}
 
# Verificação de erros e argumentos passados na hora de chamar a execução do script
if [ "$(id -u)" != "0" ]; then
  echo "ERROR: Must run as root."
  usage
fi
if [ "$#" != "2" ]; then
  echo "Bad number of args."
  usage
fi

# Variáveis de execução
name=$1
host=$2
checkpoint_dir=/tmp/checkpoint
 
# Função responsável por sincronizar as pastas onde estão os arquivos dos containers entre os servidores
do_rsync() {
  rsync -aAXHltzh --progress --numeric-ids --devices --rsync-path="sudo rsync" $1 $host:$1
}
 
# Cria um path para ser utilizado no container de destino
LXCPATH=$(lxc-config lxc.lxcpath)
 
# Ação responsável por criar o checkpoint
sudo lxc-checkpoint -v -n $name -s -D $checkpoint_dir
 
# Ação responsável por fazer a sincronização entre os servidores
do_rsync $LXCPATH/$name/
do_rsync $checkpoint_dir/
 
# Executa um comando via ssh para “levantar” o container no servidor para o qual ele foi migrado
ssh $host "sudo lxc-checkpoint -v -n $name -r -d -D $checkpoint_dir"

# Printo de resultados
echo "Migração do container $name para $host concluída com sucesso!"
