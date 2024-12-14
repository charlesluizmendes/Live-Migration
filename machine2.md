# Pacotes

```
sudo apt-get update && sudo apt-get install -y \
    libnet1-dev \
    libnl-3-dev \
    libbsd-dev \
    libnl-route-3-dev \
    libnftables-dev \
    libprotobuf-c-dev \
    autoconf \
    libtool \
    protobuf-c-compiler \
    protobuf-compiler \
    build-essential \
    bsdmainutils \
    git-core \
    asciidoc \
    htop \
    curl \
    libnl-genl-3-dev \
    pkg-config \
    git \
    supervisor \
    cgroup-lite \
    libapparmor-dev \
    libseccomp-dev \
    libcap-dev \
    libaio-dev \
    apparmor

sudo apt --fix-broken install

sudo apt-get update && sudo apt-get install -y \
    python3-setuptools \
    python3-pip

sudo apt-get update && sudo apt-get install -y \
    openvswitch-switch \
    iptables-persistent \
    net-tools

sudo apt-get install openssh-server -y

sudo apt-get install lxc-templates debootstrap
```

# kernel

```
sudo apt install linux-image-generic
```

# SDN

```
# Adicionar o switch s3
sudo ovs-vsctl add-br s3

# Adicionando IP ao Switch
sudo ip add add 192.168.0.53/24 dev s3

# Configurar controlador para o switch
sudo ovs-vsctl set-controller s3 tcp:192.168.0.226:6653

# Configurar protocolo OpenFlow13 para o switch
sudo ovs-vsctl set Bridge s3 protocols=OpenFlow13

# Reiniciar o Open vSwitch
sudo systemctl restart openvswitch-switch

# Adicionar portas ao switch
sudo ovs-vsctl add-port s3 s3-eth1 -- set Interface s3-eth1 type=internal
sudo ovs-vsctl add-port s3 s3-eth2 -- set Interface s3-eth2 type=internal

# Configurar túneis VXLAN para comunicação com s1 e s2 (machine1)
sudo ovs-vsctl add-port s3 vxlan0 -- set interface vxlan0 type=vxlan options:remote_ip=192.168.0.127 options:key=1
sudo ovs-vsctl add-port s3 vxlan1 -- set interface vxlan1 type=vxlan options:remote_ip=192.168.0.127 options:key=2

sudo ovs-vsctl show

machine2@machine2-VirtualBox:~$ sudo ovs-vsctl show
3ef5d5f2-2174-478b-b2c7-d484fb968241
    Bridge s3
        Controller "tcp:192.168.0.226:6653"
            is_connected: true
        Port s3-eth1
            Interface s3-eth1
                type: internal
        Port s3
            Interface s3
                type: internal
        Port gre1
            Interface gre1
                type: gre
                options: {key="2", remote_ip="192.168.0.127"}
        Port gre0
            Interface gre0
                type: gre
                options: {key="1", remote_ip="192.168.0.127"}
        Port s3-eth2
            Interface s3-eth2
                type: internal
    ovs_version: "2.17.9"
```

Criar Script para a conexão do Container com o OVS:

```
sudo nano /etc/lxc/ifup
sudo chmod +x /etc/lxc/ifup
```
```
#!/bin/bash

BRIDGE=s3

ovs-vsctl --may-exist add-br $BRIDGE
ovs-vsctl --if-exists del-port $BRIDGE $5
ovs-vsctl --may-exist add-port $BRIDGE $5
```
```
sudo nano /etc/lxc/ifdown
sudo chmod +x /etc/lxc/ifdown
```
```
#!/bin/bash

ovsBr=s3
ovs-vsctl --if-exists del-port ${ovsBr} $5
```

# Criu 

```
git clone https://github.com/checkpoint-restore/criu.git
cd criu/
git checkout master
make clean
sudo make
sudo make install

sudo criu check --all

machine1@machine1-VirtualBox:~/criu$ sudo criu check --all
Looks good.
```

# SSH

```
sudo systemctl status ssh

sudo visudo
```
```
# Adicione a linha:
machine2 ALL=(ALL) NOPASSWD: ALL
```
```
sudo nano /etc/ssh/sshd_config
```
```
PubkeyAuthentication yes
PasswordAuthentication yes
AuthorizedKeysFile .ssh/authorized_keys
```
```
sudo chmod 700 ~/.ssh
sudo chmod 600 ~/.ssh/authorized_keys

sudo systemctl restart sshd
```
