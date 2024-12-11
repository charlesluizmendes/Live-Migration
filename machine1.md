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

sudo ovs-vsctl add-port br0 vxlan2 -- set interface vxlan2 type=vxlan options:remote_ip=192.168.0.144 options:key=2

sudo ovs-vsctl show

machine1@machine1-VirtualBox:~$ sudo ovs-vsctl show
8842506c-2946-44b0-85a4-ab55471ff10f
    Bridge br0
        Controller "tcp:192.168.0.143:6653"
            is_connected: true
        Port br0
            Interface br0
                type: internal
        Port vxlan2
            Interface vxlan2
                type: vxlan
                options: {key="2", remote_ip="192.168.0.144"}
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

machine1@machine1-VirtualBox:~/criu$ sudo criu check
Looks good.
```

# LXC

```
sudo lxc-create -n app-container -t download -- --dist ubuntu --release focal --arch amd64

sudo nano /var/lib/lxc/app-container/config

# Habilitar suporte a containers aninhados
lxc.include = /usr/share/lxc/config/nesting.conf

# hax for criu
lxc.console.path = none
lxc.tty.max = 0
lxc.cgroup.devices.deny = c 5:1 rwm
lxc.seccomp.profile =

sudo lxc-attach -n app-container -- umount /sys/devices/system/cpu
sudo lxc-attach -n app-container -- systemctl stop systemd-logind
sudo lxc-attach -n app-container -- systemctl disable systemd-logind

sudo lxc-ls -f

sudo lxc-start -n app-container
sudo lxc-attach -n app-container

sudo apt update
```

# App

```
sudo apt-get install nano
sudo apt-get install net-tools
sudo apt install python3 python3-pip -y

nano simple_http_server.py
```

```
from http.server import SimpleHTTPRequestHandler, HTTPServer

host = "0.0.0.0"
port = 8080

class RequestHandler(SimpleHTTPRequestHandler):
    def log_message(self, format, *args):
        pass  # Remove logging for simplicity

print(f"Starting server on {host}:{port}...")
httpd = HTTPServer((host, port), RequestHandler)
httpd.serve_forever()
```

```
python3 simple_http_server.py

# Abra um novo terminal e execute o cURL para testar o app dentro do container
curl http://10.0.3.172:8080
```

# SSH

```
sudo -i
ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
ssh-copy-id -i ~/.ssh/id_rsa.pub machine2@192.168.0.144
```

# Migration

```
sudo chmod +x migrate.sh

sudo ./migrate.sh app-container machine2@192.168.0.144
```
