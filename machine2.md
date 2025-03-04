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

sudo apt-get update && sudo apt-get install -y \
    python3-setuptools \
    python3-pip

sudo apt-get update && sudo apt-get install -y \
    openvswitch-switch \
    iptables-persistent \
    isc-dhcp-client \ 
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

# Configurar controlador para o switch
sudo ovs-vsctl set-controller s3 tcp:192.168.0.173:6653

# Configurar protocolo OpenFlow13 para o switch
sudo ovs-vsctl set Bridge s3 protocols=OpenFlow13

# Reiniciar o Open vSwitch
sudo systemctl restart openvswitch-switch

# Adicionar portas ao switch
sudo ovs-vsctl add-port s3 s3-eth1 -- set Interface s3-eth1 type=internal
sudo ovs-vsctl add-port s3 s3-eth2 -- set Interface s3-eth2 type=internal

# Configurar túneis VXLAN para comunicação com s1 e s2 (machine1)
sudo ovs-vsctl add-port s3 vxlan0 -- set interface vxlan0 type=vxlan options:remote_ip=192.168.0.36 options:key=1
sudo ovs-vsctl add-port s3 vxlan1 -- set interface vxlan1 type=vxlan options:remote_ip=192.168.0.36 options:key=2

sudo ovs-vsctl show

machine2@machine2-VirtualBox:~$ sudo ovs-vsctl show
ff478e61-e27f-4c34-a7cb-7ea30177ad55
    Bridge s3
        Controller "tcp:192.168.0.173:6653"
            is_connected: true
        Port vxlan1
            Interface vxlan1
                type: vxlan
                options: {key="2", remote_ip="192.168.0.36"}
        Port vxlan0
            Interface vxlan0
                type: vxlan
                options: {key="1", remote_ip="192.168.0.36"}
        Port s3-eth2
            Interface s3-eth2
                type: internal
        Port s3
            Interface s3
                type: internal
        Port s3-eth1
            Interface s3-eth1
                type: internal
    ovs_version: "2.17.9"
```

# LXC

Atribuir IP ao Container Server:

```
sudo lxc-attach -n server-container

ip addr add 192.168.0.54/24 dev eth0
ip route add default via 192.168.0.1 dev eth0

ip link set eth0 up
exit
```

# Criu 

```
git clone https://github.com/checkpoint-restore/criu.git
cd criu/
git checkout master
sudo make clean
sudo make
sudo make install
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