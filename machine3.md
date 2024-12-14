# Pacotes

```
sudo apt-get update

sudo apt-get install openvswitch-switch 
sudo apt-get install net-tools
sudo apt install openjdk-8-jdk
```

# SDN

```
sudo systemctl restart openvswitch-switch

sudo ovs-vsctl show

machine3@machine3-VirtualBox:/opt/onos/bin$ sudo ovs-vsctl show
6c86c9e2-aefd-4000-a92e-91b60b7a0ec2
    ovs_version: "2.17.9"
```

# Onos

```
sudo nano ~/.bashrc
```
```
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export JRE_HOME=$JAVA_HOME/jre
export CLASSPATH=.:$JAVA_HOME/lib:$JRE_HOME/lib
export PATH=$JAVA_HOME/bin:$PATH
```
```
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
```
```
HostKeyAlgorithms +ssh-rsa
PubkeyAcceptedKeyTypes +ssh-rsa
```
```
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