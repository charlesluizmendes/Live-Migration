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

# Kernel

```
sudo apt install linux-image-generic
```

# SDN

```
# Adicionar switches
sudo ovs-vsctl add-br s1
sudo ovs-vsctl add-br s2

# Adicionando IP's aos Switchs
sudo ip add add 192.168.0.51/24 dev s1
sudo ip add add 192.168.0.52/24 dev s2

# Configurar controladores para os switches
sudo ovs-vsctl set-controller s1 tcp:192.168.0.226:6653
sudo ovs-vsctl set-controller s2 tcp:192.168.0.226:6653

# Configurar protocolo OpenFlow13 para os switches
sudo ovs-vsctl set Bridge s1 protocols=OpenFlow13
sudo ovs-vsctl set Bridge s2 protocols=OpenFlow13

# Reiniciar o Open vSwitch
sudo systemctl restart openvswitch-switch

# Adicionar portas aos switches
sudo ovs-vsctl add-port s1 s1-eth1 -- set Interface s1-eth1 type=internal
sudo ovs-vsctl add-port s1 s1-eth2 -- set Interface s1-eth2 type=internal

sudo ovs-vsctl add-port s2 s2-eth1 -- set Interface s2-eth1 type=internal
sudo ovs-vsctl add-port s2 s2-eth2 -- set Interface s2-eth2 type=internal

# Criar links entre os switches locais usando as portas configuradas
sudo ovs-vsctl add-port s1 patch-s1-s2 -- set Interface patch-s1-s2 type=patch options:peer=patch-s2-s1
sudo ovs-vsctl add-port s2 patch-s2-s1 -- set Interface patch-s2-s1 type=patch options:peer=patch-s1-s2

# Configurar túneis VXLAN para comunicação com s3 (machine2)
sudo ovs-vsctl add-port s1 vxlan0 -- set interface vxlan0 type=vxlan options:remote_ip=192.168.0.160 options:key=1
sudo ovs-vsctl add-port s2 vxlan1 -- set interface vxlan1 type=vxlan options:remote_ip=192.168.0.160 options:key=2

sudo ovs-vsctl show

machine1@machine1-VirtualBox:~$ sudo ovs-vsctl show
c477fce3-0164-4943-944c-42acbeb4bc85
    Bridge s2
        Controller "tcp:192.168.0.226:6653"
            is_connected: true
        Port patch-s2-s1
            Interface patch-s2-s1
                type: patch
                options: {peer=patch-s1-s2}
        Port s2
            Interface s2
                type: internal
        Port s2-eth1
            Interface s2-eth1
                type: internal
        Port gre-s2-s3
            Interface gre-s2-s3
                type: gre
                options: {key="2", remote_ip="192.168.0.160"}
        Port s2-eth2
            Interface s2-eth2
                type: internal
    Bridge s1
        Controller "tcp:192.168.0.226:6653"
            is_connected: true
        Port patch-s1-s2
            Interface patch-s1-s2
                type: patch
                options: {peer=patch-s2-s1}
        Port gre-s1-s3
            Interface gre-s1-s3
                type: gre
                options: {key="1", remote_ip="192.168.0.160"}
        Port s1-eth1
            Interface s1-eth1
                type: internal
        Port s1-eth2
            Interface s1-eth2
                type: internal
        Port s1
            Interface s1
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

BRIDGE=s1

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

ovsBr=s1
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

# LXC

```
sudo lxc-create -t ubuntu -n server-container -- -r trusty -a amd64
sudo lxc-create -t ubuntu -n client-container -- -r trusty -a amd64

sudo su
cd /var/lib/lxc/server-container
mv config config.tmp
cp /usr/share/lxc/config/common.conf config
exit

sudo gedit
# Procure o arquivo: /var/lib/lxc/server-container/config
```
```
lxc.tty.max = 0
lxc.console.path = none
lxc.cgroup.devices.deny = c 5:1 rwm

lxc.pty.max = 1024

lxc.cap.drop = mac_admin mac_override sys_time sys_module

lxc.hook.clone = /usr/share/lxc/hooks/clonehostname

lxc.cgroup.devices.deny = a
lxc.cgroup.devices.allow = c *:* m
lxc.cgroup.devices.allow = b *:* m
lxc.cgroup.devices.allow = c 1:3 rwm
lxc.cgroup.devices.allow = c 1:5 rwm
lxc.cgroup.devices.allow = c 1:7 rwm
lxc.cgroup.devices.allow = c 5:0 rwm
lxc.cgroup.devices.allow = c 5:2 rwm
lxc.cgroup.devices.allow = c 1:8 rwm
lxc.cgroup.devices.allow = c 1:9 rwm
lxc.cgroup.devices.allow = c 136:* rwm

lxc.seccomp.profile = /usr/share/lxc/config/common.seccomp

lxc.mount.entry = /sys/devices/system/cpu sys/devices/system/cpu none bind,optional 0 0
lxc.mount.entry = /proc proc none bind,optional 0 0
lxc.mount.entry = /sys/fs/pstore sys/fs/pstore none bind,optional 0 0
lxc.mount.entry = /sys/kernel/ sys/kernel none bind,optional 0 0
lxc.mount.entry = /sys/fs/fuse/connections sys/fs/fuse/connections none bind,optional 0 0

lxc.cgroup.devices.allow = c 254:0 rm
lxc.cgroup.devices.allow = c 10:229 rwm
lxc.cgroup.devices.allow = c 10:200 rwm
lxc.cgroup.devices.allow = c 10:228 rwm
lxc.cgroup.devices.allow = c 10:232 rwm
lxc.arch=x86_64

lxc.rootfs.path = /var/lib/lxc/server-container/rootfs
lxc.uts.name = server-container

lxc.net.0.type = veth
lxc.net.0.flags = up
lxc.net.0.script.up = /etc/lxc/ifup
lxc.net.0.script.down = /etc/lxc/ifdown
lxc.net.0.veth.pair = vethdYTnja
lxc.net.0.ipv4.address = 192.168.0.54/24
```
```
sudo gedit
# Procure o arquivo: /var/lib/lxc/client-container/config
```
```
lxc.net.0.type = veth
lxc.net.0.flags = up
lxc.net.0.link = s2
lxc.net.0.veth.pair = vethaCSkDm
lxc.net.0.ipv4.address = 192.168.0.55/24
```
```
sudo rm /var/lib/lxc/server-container/rootfs/etc/init/udev.conf

sudo lxc-ls -f

sudo lxc-start -n server-container
sudo lxc-start -n client-container

sudo lxc-attach -n server-container
sudo lxc-attach -n client-container

sudo apt update
sudo apt install net-tools
```

# SSH

```
sudo -i
ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
ssh-copy-id -i ~/.ssh/id_rsa.pub machine2@192.168.0.144

sudo chmod 700 ~/.ssh
sudo chmod 600 ~/.ssh/id_rsa
```

# Migration

Através de comandos no terminal:

```
sudo rm -rf /tmp/checkpoint

sudo lxc-checkpoint -v -n server-container -s -D /tmp/checkpoint -o /tmp/checkpoint/dump.log

sudo rsync -aAXHltzh --progress --numeric-ids --devices --rsync-path="sudo rsync" /var/lib/lxc/server-container/ machine2@192.168.0.160:/var/lib/lxc/server-container/

sudo rsync -aAXHltzh --progress --numeric-ids --devices --rsync-path="sudo rsync" /tmp/checkpoint/ machine2@192.168.0.160:/tmp/checkpoint/

ssh machine2@192.168.0.160

sudo lxc-checkpoint -v -n server-container -r -d -D /tmp/checkpoint -o /tmp/checkpoint/restore.log
```

Através do script de migração:

```
sudo chmod +x migrate.sh

sudo rm -rf /tmp/checkpoint

sudo ./migrate.sh server-container machine2@192.168.0.160
```
