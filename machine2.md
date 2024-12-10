# Pacotes

```
sudo apt-get update

sudo apt-get install build-essential
sudo apt-get install libprotobuf-dev protobuf-compiler libnet1-dev libcap-dev libnl-3-dev libbsd-dev libnl-route-3-dev python3-protobuf python3-distutils

sudo apt-get install libnftables-dev

sudo apt-get install libprotobuf-c-dev
sudo apt-get install autoconf curl g++ libtool
sudo apt-get install asciidoc xmlto

sudo apt-get install pkg-config
sudo apt-get install protobuf-c-compiler

sudo apt install --install-recommends linux-generic

sudo apt-get install python3-setuptools
sudo apt install -y python3-pip

sudo apt-get install openvswitch-switch
sudo apt-get install iptables-persistent
sudo apt-get install net-tools

sudo apt install openssh-server -y

sudo apt-get install git
sudo apt-get install -y lxc-templates debootstrap
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

sudo criu check

machine2@machine2-VirtualBox:~/criu$ sudo criu check
Looks good.
```

# SSH

```
sudo systemctl status ssh

sudo visudo

# Adicione a linha:
machine2 ALL=(ALL) NOPASSWD: ALL
```
