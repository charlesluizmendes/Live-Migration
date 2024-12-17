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
```

Antes da migração:

```
machine3@machine3-VirtualBox:~$ /opt/onos/bin/onos -l onos
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

onos@root > devices                                                                             14:03:24
id=of:000036a82a811042, available=true, local-status=connected 11m33s ago, role=MASTER, type=SWITCH, mfr=Nicira, Inc., hw=Open vSwitch, sw=2.17.9, serial=None, chassis=36a82a811042, driver=ovs, channelId=192.168.0.36:47142, managementAddress=192.168.0.36, protocol=OF_13
id=of:000076f1b6076846, available=true, local-status=connected 11m33s ago, role=MASTER, type=SWITCH, mfr=Nicira, Inc., hw=Open vSwitch, sw=2.17.9, serial=None, chassis=76f1b6076846, driver=ovs, channelId=192.168.0.36:47130, managementAddress=192.168.0.36, protocol=OF_13
id=of:0000c68ba4250b42, available=true, local-status=connected 11m36s ago, role=MASTER, type=SWITCH, mfr=Nicira, Inc., hw=Open vSwitch, sw=2.17.9, serial=None, chassis=c68ba4250b42, driver=ovs, channelId=192.168.0.30:60886, managementAddress=192.168.0.30, protocol=OF_13
onos@root > hosts                                                                               14:03:32
id=00:16:3E:3F:AB:45/None, mac=00:16:3E:3F:AB:45, locations=[of:000076f1b6076846/4], vlan=None, ip(s)=[192.168.0.54], innerVlan=None, outerTPID=unknown, provider=of:org.onosproject.provider.host, configured=false
id=AA:3A:0B:9E:EF:52/None, mac=AA:3A:0B:9E:EF:52, locations=[of:000036a82a811042/3], vlan=None, ip(s)=[192.168.0.55], innerVlan=None, outerTPID=unknown, provider=of:org.onosproject.provider.host, configured=false
onos@root > flows                                                                               14:03:36
deviceId=of:000036a82a811042, flowRuleCount=4
    id=1000062363cec, state=ADDED, bytes=252, packets=6, duration=695, liveType=UNKNOWN, priority=40000, tableId=0, appId=org.onosproject.core, payLoad=null, selector=[ETH_TYPE:arp], treatment=DefaultTrafficTreatment{immediate=[OUTPUT:CONTROLLER], deferred=[], transition=None, meter=[], cleared=true, StatTrigger=null, metadata=null}
    id=10000831955b4, state=ADDED, bytes=63082, packets=449, duration=695, liveType=UNKNOWN, priority=40000, tableId=0, appId=org.onosproject.core, payLoad=null, selector=[ETH_TYPE:bddp], treatment=DefaultTrafficTreatment{immediate=[OUTPUT:CONTROLLER], deferred=[], transition=None, meter=[], cleared=true, StatTrigger=null, metadata=null}
    id=1000084a79cf0, state=ADDED, bytes=63082, packets=449, duration=695, liveType=UNKNOWN, priority=40000, tableId=0, appId=org.onosproject.core, payLoad=null, selector=[ETH_TYPE:lldp], treatment=DefaultTrafficTreatment{immediate=[OUTPUT:CONTROLLER], deferred=[], transition=None, meter=[], cleared=true, StatTrigger=null, metadata=null}
    id=1000091c77415, state=ADDED, bytes=0, packets=0, duration=695, liveType=UNKNOWN, priority=5, tableId=0, appId=org.onosproject.core, payLoad=null, selector=[ETH_TYPE:ipv4], treatment=DefaultTrafficTreatment{immediate=[OUTPUT:CONTROLLER], deferred=[], transition=None, meter=[], cleared=true, StatTrigger=null, metadata=null}
deviceId=of:000076f1b6076846, flowRuleCount=4
    id=1000069ce3572, state=ADDED, bytes=378, packets=9, duration=695, liveType=UNKNOWN, priority=40000, tableId=0, appId=org.onosproject.core, payLoad=null, selector=[ETH_TYPE:arp], treatment=DefaultTrafficTreatment{immediate=[OUTPUT:CONTROLLER], deferred=[], transition=None, meter=[], cleared=true, StatTrigger=null, metadata=null}
    id=10000f6c7b0a1, state=ADDED, bytes=63225, packets=450, duration=695, liveType=UNKNOWN, priority=40000, tableId=0, appId=org.onosproject.core, payLoad=null, selector=[ETH_TYPE:bddp], treatment=DefaultTrafficTreatment{immediate=[OUTPUT:CONTROLLER], deferred=[], transition=None, meter=[], cleared=true, StatTrigger=null, metadata=null}
    id=10000f8852b24, state=ADDED, bytes=62944, packets=448, duration=690, liveType=UNKNOWN, priority=40000, tableId=0, appId=org.onosproject.core, payLoad=null, selector=[ETH_TYPE:lldp], treatment=DefaultTrafficTreatment{immediate=[OUTPUT:CONTROLLER], deferred=[], transition=None, meter=[], cleared=true, StatTrigger=null, metadata=null}
    id=10000d661a8d5, state=ADDED, bytes=0, packets=0, duration=695, liveType=UNKNOWN, priority=5, tableId=0, appId=org.onosproject.core, payLoad=null, selector=[ETH_TYPE:ipv4], treatment=DefaultTrafficTreatment{immediate=[OUTPUT:CONTROLLER], deferred=[], transition=None, meter=[], cleared=true, StatTrigger=null, metadata=null}
deviceId=of:0000c68ba4250b42, flowRuleCount=4
    id=1000057db2b7b, state=ADDED, bytes=62514, packets=453, duration=700, liveType=UNKNOWN, priority=40000, tableId=0, appId=org.onosproject.core, payLoad=null, selector=[ETH_TYPE:bddp], treatment=DefaultTrafficTreatment{immediate=[OUTPUT:CONTROLLER], deferred=[], transition=None, meter=[], cleared=true, StatTrigger=null, metadata=null}
    id=10000d844df1d, state=ADDED, bytes=62514, packets=453, duration=700, liveType=UNKNOWN, priority=40000, tableId=0, appId=org.onosproject.core, payLoad=null, selector=[ETH_TYPE:lldp], treatment=DefaultTrafficTreatment{immediate=[OUTPUT:CONTROLLER], deferred=[], transition=None, meter=[], cleared=true, StatTrigger=null, metadata=null}
    id=10000f8701695, state=ADDED, bytes=0, packets=0, duration=700, liveType=UNKNOWN, priority=40000, tableId=0, appId=org.onosproject.core, payLoad=null, selector=[ETH_TYPE:arp], treatment=DefaultTrafficTreatment{immediate=[OUTPUT:CONTROLLER], deferred=[], transition=None, meter=[], cleared=true, StatTrigger=null, metadata=null}
    id=1000026e8471f, state=ADDED, bytes=0, packets=0, duration=700, liveType=UNKNOWN, priority=5, tableId=0, appId=org.onosproject.core, payLoad=null, selector=[ETH_TYPE:ipv4], treatment=DefaultTrafficTreatment{immediate=[OUTPUT:CONTROLLER], deferred=[], transition=None, meter=[], cleared=true, StatTrigger=null, metadata=null}
```

Depois da migração:

```
achine3@machine3-VirtualBox:~$ /opt/onos/bin/onos -l onos
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

onos@root > devices                                                                             14:05:38
id=of:000036a82a811042, available=true, local-status=connected 19m47s ago, role=MASTER, type=SWITCH, mfr=Nicira, Inc., hw=Open vSwitch, sw=2.17.9, serial=None, chassis=36a82a811042, driver=ovs, channelId=192.168.0.36:47142, managementAddress=192.168.0.36, protocol=OF_13
id=of:000076f1b6076846, available=true, local-status=connected 19m47s ago, role=MASTER, type=SWITCH, mfr=Nicira, Inc., hw=Open vSwitch, sw=2.17.9, serial=None, chassis=76f1b6076846, driver=ovs, channelId=192.168.0.36:47130, managementAddress=192.168.0.36, protocol=OF_13
id=of:0000c68ba4250b42, available=true, local-status=connected 19m50s ago, role=MASTER, type=SWITCH, mfr=Nicira, Inc., hw=Open vSwitch, sw=2.17.9, serial=None, chassis=c68ba4250b42, driver=ovs, channelId=192.168.0.30:60886, managementAddress=192.168.0.30, protocol=OF_13
onos@root > hosts                                                                               14:11:46
id=00:16:3E:3F:AB:45/None, mac=00:16:3E:3F:AB:45, locations=[of:0000c68ba4250b42/5], vlan=None, ip(s)=[192.168.0.54], innerVlan=None, outerTPID=unknown, provider=of:org.onosproject.provider.host, configured=false
id=AA:3A:0B:9E:EF:52/None, mac=AA:3A:0B:9E:EF:52, locations=[of:000036a82a811042/3], vlan=None, ip(s)=[192.168.0.55], innerVlan=None, outerTPID=unknown, provider=of:org.onosproject.provider.host, configured=false
onos@root > flows                                                                               14:11:48
deviceId=of:000036a82a811042, flowRuleCount=4
    id=1000062363cec, state=ADDED, bytes=252, packets=6, duration=1190, liveType=UNKNOWN, priority=40000, tableId=0, appId=org.onosproject.core, payLoad=null, selector=[ETH_TYPE:arp], treatment=DefaultTrafficTreatment{immediate=[OUTPUT:CONTROLLER], deferred=[], transition=None, meter=[], cleared=true, StatTrigger=null, metadata=null}
    id=10000831955b4, state=ADDED, bytes=107904, packets=768, duration=1190, liveType=UNKNOWN, priority=40000, tableId=0, appId=org.onosproject.core, payLoad=null, selector=[ETH_TYPE:bddp], treatment=DefaultTrafficTreatment{immediate=[OUTPUT:CONTROLLER], deferred=[], transition=None, meter=[], cleared=true, StatTrigger=null, metadata=null}
    id=1000084a79cf0, state=ADDED, bytes=107904, packets=768, duration=1190, liveType=UNKNOWN, priority=40000, tableId=0, appId=org.onosproject.core, payLoad=null, selector=[ETH_TYPE:lldp], treatment=DefaultTrafficTreatment{immediate=[OUTPUT:CONTROLLER], deferred=[], transition=None, meter=[], cleared=true, StatTrigger=null, metadata=null}
    id=1000091c77415, state=ADDED, bytes=0, packets=0, duration=1190, liveType=UNKNOWN, priority=5, tableId=0, appId=org.onosproject.core, payLoad=null, selector=[ETH_TYPE:ipv4], treatment=DefaultTrafficTreatment{immediate=[OUTPUT:CONTROLLER], deferred=[], transition=None, meter=[], cleared=true, StatTrigger=null, metadata=null}
deviceId=of:000076f1b6076846, flowRuleCount=4
    id=1000069ce3572, state=ADDED, bytes=378, packets=9, duration=1190, liveType=UNKNOWN, priority=40000, tableId=0, appId=org.onosproject.core, payLoad=null, selector=[ETH_TYPE:arp], treatment=DefaultTrafficTreatment{immediate=[OUTPUT:CONTROLLER], deferred=[], transition=None, meter=[], cleared=true, StatTrigger=null, metadata=null}
    id=10000f6c7b0a1, state=ADDED, bytes=108047, packets=769, duration=1190, liveType=UNKNOWN, priority=40000, tableId=0, appId=org.onosproject.core, payLoad=null, selector=[ETH_TYPE:bddp], treatment=DefaultTrafficTreatment{immediate=[OUTPUT:CONTROLLER], deferred=[], transition=None, meter=[], cleared=true, StatTrigger=null, metadata=null}
    id=10000f8852b24, state=ADDED, bytes=107766, packets=767, duration=1185, liveType=UNKNOWN, priority=40000, tableId=0, appId=org.onosproject.core, payLoad=null, selector=[ETH_TYPE:lldp], treatment=DefaultTrafficTreatment{immediate=[OUTPUT:CONTROLLER], deferred=[], transition=None, meter=[], cleared=true, StatTrigger=null, metadata=null}
    id=10000d661a8d5, state=ADDED, bytes=0, packets=0, duration=1190, liveType=UNKNOWN, priority=5, tableId=0, appId=org.onosproject.core, payLoad=null, selector=[ETH_TYPE:ipv4], treatment=DefaultTrafficTreatment{immediate=[OUTPUT:CONTROLLER], deferred=[], transition=None, meter=[], cleared=true, StatTrigger=null, metadata=null}
deviceId=of:0000c68ba4250b42, flowRuleCount=4
    id=1000057db2b7b, state=ADDED, bytes=106122, packets=769, duration=1190, liveType=UNKNOWN, priority=40000, tableId=0, appId=org.onosproject.core, payLoad=null, selector=[ETH_TYPE:bddp], treatment=DefaultTrafficTreatment{immediate=[OUTPUT:CONTROLLER], deferred=[], transition=None, meter=[], cleared=true, StatTrigger=null, metadata=null}
    id=10000d844df1d, state=ADDED, bytes=106122, packets=769, duration=1190, liveType=UNKNOWN, priority=40000, tableId=0, appId=org.onosproject.core, payLoad=null, selector=[ETH_TYPE:lldp], treatment=DefaultTrafficTreatment{immediate=[OUTPUT:CONTROLLER], deferred=[], transition=None, meter=[], cleared=true, StatTrigger=null, metadata=null}
    id=10000f8701695, state=ADDED, bytes=126, packets=3, duration=1190, liveType=UNKNOWN, priority=40000, tableId=0, appId=org.onosproject.core, payLoad=null, selector=[ETH_TYPE:arp], treatment=DefaultTrafficTreatment{immediate=[OUTPUT:CONTROLLER], deferred=[], transition=None, meter=[], cleared=true, StatTrigger=null, metadata=null}
    id=1000026e8471f, state=ADDED, bytes=0, packets=0, duration=1190, liveType=UNKNOWN, priority=5, tableId=0, appId=org.onosproject.core, payLoad=null, selector=[ETH_TYPE:ipv4], treatment=DefaultTrafficTreatment{immediate=[OUTPUT:CONTROLLER], deferred=[], transition=None, meter=[], cleared=true, StatTrigger=null, metadata=null}
```