# Pacotes

```
sudo apt-get update

sudo apt-get install openvswitch-switch 
sudo apt-get install net-tools
sudo apt install openjdk-8-jdk
```

# Redes

```
sudo ovs-vsctl add-br br0
sudo ovs-vsctl set Bridge br0 protocols=OpenFlow13
sudo systemctl restart openvswitch-switch

sudo ovs-vsctl add-port br0 vxlan1 -- set interface vxlan1 type=vxlan options:remote_ip=192.168.0.145 options:key=1
sudo ovs-vsctl add-port br0 vxlan2 -- set interface vxlan2 type=vxlan options:remote_ip=192.168.0.144 options:key=2
sudo ovs-vsctl show

machine3@machine3-VirtualBox:/opt/onos/bin$ sudo ovs-vsctl show
42d91e6a-85bb-4680-b96f-fc1825fba726
    Bridge br0
        Port br0
            Interface br0
                type: internal
        Port vxlan2
            Interface vxlan2
                type: vxlan
                options: {key="2", remote_ip="192.168.0.144"}
        Port vxlan1
            Interface vxlan1
                type: vxlan
                options: {key="1", remote_ip="192.168.0.145"}
    ovs_version: "2.17.9"
```

# Onos

```
sudo nano ~/.bashrc

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export JRE_HOME=$JAVA_HOME/jre
export CLASSPATH=.:$JAVA_HOME/lib:$JRE_HOME/lib
export PATH=$JAVA_HOME/bin:$PATH

source ~/.bashrc
	
sudo wget -c https://repo1.maven.org/maven2/org/onosproject/onos-releases/2.0.0/onos-2.0.0.tar.gz
tar zxvf onos-2.0.0.tar.gz
sudo mkdir /opt/onos
sudo cp -r onos-2.0.0/* /opt/onos

cd /opt/onos/bin
sudo /opt/onos/bin/onos-service start

# Abrir outro terminal e deixar o anterior funcionando
mkdir ~/.ssh
touch ~/.ssh/config
sudo nano ~/.ssh/config

HostKeyAlgorithms +ssh-rsa
PubkeyAcceptedKeyTypes +ssh-rsa

/opt/onos/bin/onos -l onos

app activate org.onosproject.hostprovider
app activate org.onosproject.mobility
app activate org.onosproject.lldpprovider
app activate org.onosproject.ofagent
app activate org.onosproject.openflow-base
app activate org.onosproject.openflow
app activate org.onosproject.roadm
app activate org.onosproject.proxyarp 
app activate org.onosproject.fwd
    
onos@root > devices                                                                             
```




