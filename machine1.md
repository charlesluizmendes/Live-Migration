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
sudo lxc-create -t ubuntu -n app-container -- -r trusty -a amd64

sudo su
cd /var/lib/lxc/app-container
mv config config.tmp
cp /usr/share/lxc/config/common.conf config
exit

sudo gedit
# Procure o arquivo: /var/lib/lxc/app-container/config
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

lxc.rootfs.path = /var/lib/lxc/app-container/rootfs
lxc.uts.name = app-container

lxc.net.0.type = veth
lxc.net.0.link = lxcbr0
lxc.net.0.flags = up
```
```
sudo rm /var/lib/lxc/app-container/rootfs/etc/init/udev.conf

sudo lxc-ls -f

sudo lxc-start -n app-container
sudo lxc-attach -n app-container

sudo apt update
```

# App

```
sudo apt-get update && sudo apt-get install -y \
    nano \
    net-tools \
    python3 \
    python3-pip -y

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

sudo chmod 700 ~/.ssh
sudo chmod 600 ~/.ssh/id_rsa
```

# Migration

Através de comandos no terminal:

```
sudo rm -rf /tmp/checkpoint

sudo lxc-checkpoint -v -n app-container -s -D /tmp/checkpoint -o /tmp/checkpoint/dump.log

sudo rsync -aAXHltzh --progress --numeric-ids --devices --rsync-path="sudo rsync" /var/lib/lxc/app-container/ machine2@192.168.0.160:/var/lib/lxc/app-container/

sudo rsync -aAXHltzh --progress --numeric-ids --devices --rsync-path="sudo rsync" /tmp/checkpoint/ machine2@192.168.0.160:/tmp/checkpoint/

ssh machine2@192.168.0.160

sudo lxc-checkpoint -v -n app-container -r -d -D /tmp/checkpoint -o /tmp/checkpoint/restore.log
```

Através do script de migração:

```
sudo chmod +x migrate.sh

sudo rm -rf /tmp/checkpoint

sudo ./migrate.sh app-container machine2@192.168.0.160
```
