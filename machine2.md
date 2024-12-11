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

# Redes

```
sudo ovs-vsctl add-br br0
sudo ovs-vsctl set-controller br0 tcp:192.168.0.143:6653
sudo ovs-vsctl set Bridge br0 protocols=OpenFlow13
sudo systemctl restart openvswitch-switch

sudo ovs-vsctl add-port br0 vxlan1 -- set interface vxlan1 type=vxlan options:remote_ip=192.168.0.145 options:key=2

sudo ovs-vsctl show

machine2@machine2-VirtualBox:~$ sudo ovs-vsctl show
6b5020ad-aeab-432d-b96e-0490c9c44213
    Bridge br0
        Controller "tcp:192.168.0.143:6653"
            is_connected: true
        Port vxlan1
            Interface vxlan1
                type: vxlan
                options: {key="2", remote_ip="192.168.0.145"}
        Port br0
            Interface br0
                type: internal
    ovs_version: "2.17.9"
```

# Criu 

```
git clone https://github.com/checkpoint-restore/criu.git
cd criu/
make clean
sudo make
sudo make install

sudo criu check --all

machine2@machine2-VirtualBox:~/criu$ sudo criu check
Looks good.
```

# SSH

```
sudo systemctl status ssh

sudo visudo

# Adicione a linha:
machine2 ALL=(ALL) NOPASSWD: ALL

sudo nano /etc/ssh/sshd_config

PubkeyAuthentication yes
PasswordAuthentication yes
AuthorizedKeysFile .ssh/authorized_keys

sudo chmod 700 ~/.ssh
sudo chmod 600 ~/.ssh/authorized_keys

sudo systemctl restart sshd
```
