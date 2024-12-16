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
    
machine3@machine3-VirtualBox:/opt/onos/bin$ /opt/onos/bin/onos -l onos
Password authentication
(onos@localhost) Password: 
Welcome to Open Network Operating System (ONOS)!
     ____  _  ______  ____     
    / __ \/ |/ / __ \/ __/   
   / /_/ /    / /_/ /\ \     
   \____/_/|_/\____/___/     
                               
Documentation: wiki.onosproject.org      
Tutorials:     tutorials.onosproject.org 
Mailing lists: lists.onosproject.org     

Come help out! Find out how at: contribute.onosproject.org 

Hit '<tab>' for a list of available commands
and '[cmd] --help' for help on a specific command.
Hit '<ctrl-d>' or type 'logout' to exit ONOS session.

onos@root > devices                                                     16:41:13
id=of:0000162a93cd3f42, available=true, local-status=connected 12m18s ago, role=MASTER, type=SWITCH, mfr=Nicira, Inc., hw=Open vSwitch, sw=2.17.9, serial=None, chassis=162a93cd3f42, driver=ovs, channelId=192.168.0.36:59398, managementAddress=192.168.0.36, protocol=OF_13
id=of:00005abf70ad3a41, available=true, local-status=connected 12m18s ago, role=MASTER, type=SWITCH, mfr=Nicira, Inc., hw=Open vSwitch, sw=2.17.9, serial=None, chassis=5abf70ad3a41, driver=ovs, channelId=192.168.0.36:59412, managementAddress=192.168.0.36, protocol=OF_13
id=of:0000c68ba4250b42, available=true, local-status=connected 13m1s ago, role=MASTER, type=SWITCH, mfr=Nicira, Inc., hw=Open vSwitch, sw=2.17.9, serial=None, chassis=c68ba4250b42, driver=ovs, channelId=192.168.0.30:34890, managementAddress=192.168.0.30, protocol=OF_13
onos@root > hosts                                                       16:41:15
id=A2:B6:7B:C4:D0:37/None, mac=A2:B6:7B:C4:D0:37, locations=[of:00005abf70ad3a41/3], vlan=None, ip(s)=[192.168.0.55], innerVlan=None, outerTPID=unknown, provider=of:org.onosproject.provider.host, configured=false
id=DA:80:B6:6A:3B:55/None, mac=DA:80:B6:6A:3B:55, locations=[of:0000162a93cd3f42/3], vlan=None, ip(s)=[192.168.0.54], innerVlan=None, outerTPID=unknown, provider=of:org.onosproject.provider.host, configured=false
onos@root > flows                                                       16:41:19
deviceId=of:0000162a93cd3f42, flowRuleCount=4
    id=100004bf8907a, state=ADDED, bytes=65764, packets=468, duration=740, liveType=UNKNOWN, priority=40000, tableId=0, appId=org.onosproject.core, payLoad=null, selector=[ETH_TYPE:bddp], treatment=DefaultTrafficTreatment{immediate=[OUTPUT:CONTROLLER], deferred=[], transition=None, meter=[], cleared=true, StatTrigger=null, metadata=null}
    id=100004fb1c10e, state=ADDED, bytes=126, packets=3, duration=740, liveType=UNKNOWN, priority=40000, tableId=0, appId=org.onosproject.core, payLoad=null, selector=[ETH_TYPE:arp], treatment=DefaultTrafficTreatment{immediate=[OUTPUT:CONTROLLER], deferred=[], transition=None, meter=[], cleared=true, StatTrigger=null, metadata=null}
    id=100007a899afa, state=ADDED, bytes=65764, packets=468, duration=740, liveType=UNKNOWN, priority=40000, tableId=0, appId=org.onosproject.core, payLoad=null, selector=[ETH_TYPE:lldp], treatment=DefaultTrafficTreatment{immediate=[OUTPUT:CONTROLLER], deferred=[], transition=None, meter=[], cleared=true, StatTrigger=null, metadata=null}
    id=10000e11231fd, state=ADDED, bytes=0, packets=0, duration=740, liveType=UNKNOWN, priority=5, tableId=0, appId=org.onosproject.core, payLoad=null, selector=[ETH_TYPE:ipv4], treatment=DefaultTrafficTreatment{immediate=[OUTPUT:CONTROLLER], deferred=[], transition=None, meter=[], cleared=true, StatTrigger=null, metadata=null}
deviceId=of:00005abf70ad3a41, flowRuleCount=4
    id=100000ded59c8, state=ADDED, bytes=65345, packets=465, duration=740, liveType=UNKNOWN, priority=40000, tableId=0, appId=org.onosproject.core, payLoad=null, selector=[ETH_TYPE:bddp], treatment=DefaultTrafficTreatment{immediate=[OUTPUT:CONTROLLER], deferred=[], transition=None, meter=[], cleared=true, StatTrigger=null, metadata=null}
    id=1000068028010, state=ADDED, bytes=65345, packets=465, duration=740, liveType=UNKNOWN, priority=40000, tableId=0, appId=org.onosproject.core, payLoad=null, selector=[ETH_TYPE:lldp], treatment=DefaultTrafficTreatment{immediate=[OUTPUT:CONTROLLER], deferred=[], transition=None, meter=[], cleared=true, StatTrigger=null, metadata=null}
    id=10000c29d90e1, state=ADDED, bytes=252, packets=6, duration=740, liveType=UNKNOWN, priority=40000, tableId=0, appId=org.onosproject.core, payLoad=null, selector=[ETH_TYPE:arp], treatment=DefaultTrafficTreatment{immediate=[OUTPUT:CONTROLLER], deferred=[], transition=None, meter=[], cleared=true, StatTrigger=null, metadata=null}
    id=10000b79bd68a, state=ADDED, bytes=0, packets=0, duration=740, liveType=UNKNOWN, priority=5, tableId=0, appId=org.onosproject.core, payLoad=null, selector=[ETH_TYPE:ipv4], treatment=DefaultTrafficTreatment{immediate=[OUTPUT:CONTROLLER], deferred=[], transition=None, meter=[], cleared=true, StatTrigger=null, metadata=null}
deviceId=of:0000c68ba4250b42, flowRuleCount=4
    id=1000057db2b7b, state=ADDED, bytes=64308, packets=466, duration=785, liveType=UNKNOWN, priority=40000, tableId=0, appId=org.onosproject.core, payLoad=null, selector=[ETH_TYPE:bddp], treatment=DefaultTrafficTreatment{immediate=[OUTPUT:CONTROLLER], deferred=[], transition=None, meter=[], cleared=true, StatTrigger=null, metadata=null}
    id=10000d844df1d, state=ADDED, bytes=64308, packets=466, duration=785, liveType=UNKNOWN, priority=40000, tableId=0, appId=org.onosproject.core, payLoad=null, selector=[ETH_TYPE:lldp], treatment=DefaultTrafficTreatment{immediate=[OUTPUT:CONTROLLER], deferred=[], transition=None, meter=[], cleared=true, StatTrigger=null, metadata=null}
    id=10000f8701695, state=ADDED, bytes=0, packets=0, duration=785, liveType=UNKNOWN, priority=40000, tableId=0, appId=org.onosproject.core, payLoad=null, selector=[ETH_TYPE:arp], treatment=DefaultTrafficTreatment{immediate=[OUTPUT:CONTROLLER], deferred=[], transition=None, meter=[], cleared=true, StatTrigger=null, metadata=null}
    id=1000026e8471f, state=ADDED, bytes=0, packets=0, duration=785, liveType=UNKNOWN, priority=5, tableId=0, appId=org.onosproject.core, payLoad=null, selector=[ETH_TYPE:ipv4], treatment=DefaultTrafficTreatment{immediate=[OUTPUT:CONTROLLER], deferred=[], transition=None, meter=[], cleared=true, StatTrigger=null, metadata=null}
onos@root > intents                                                     16:41:23
```