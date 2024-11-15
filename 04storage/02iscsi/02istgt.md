iSCSI : Configure Target (istgt)
 	
Configure Storage Server with iSCSI.

Storage server with iSCSI on network is called iSCSI Target, Client Host that connects to iSCSI Target is called iSCSI Initiator.
This example is based on the environment like follows.
```
+---------------------------+          |          +-----------------------------+
|    [   iSCSI Target   ]   |10.0.0.30 | 10.0.0.51|     [ iSCSI Initiator  ]    |
|  ns.belajarfreebsd.or.id  +----------+----------+ node01.belajarfreebsd.or.id |
|                           |                     |                             |
+---------------------------+                     +-----------------------------+
```
[1]	Create disk space to be used as an iSCSI device.
```sh
root@belajarfreebsd:~# zpool list
NAME    SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
zroot  27.5G  1.08G  26.4G        -         -     0%     3%  1.00x    ONLINE  -

# for a case to create filesystem on existing ZFS pool
root@belajarfreebsd:~# zfs create -V 10g zroot/ROOT/target01
root@belajarfreebsd:~# zfs list zroot/ROOT/target01
NAME                  USED  AVAIL  REFER  MOUNTPOINT
zroot/ROOT/target01  10.2G  25.6G    56K  -

# for a case to create image on filesystem
root@belajarfreebsd:~# mkdir /home/iscsi_disks
root@belajarfreebsd:~# dd if=/dev/zero of=/home/iscsi_disks/target02.img count=0 bs=1 seek=10G
```
[2]	Install [istgt] and configure iSCSI Target.
```sh
root@belajarfreebsd:~# pkg install -y istgt
root@belajarfreebsd:~# mv /usr/local/etc/istgt/istgt.conf /usr/local/etc/istgt/istgt.conf.org
root@belajarfreebsd:~# vi /usr/local/etc/istgt/istgt.conf
# create new
[Global]
  # set your node base
  # recommended naming : [ iqn.(year)-(month).(reverse of domain name)
  NodeBase "iqn.2023-12.belajarfreebsd.or.id"
  PidFile /var/run/istgt.pid
  AuthFile /usr/local/etc/istgt/auth.conf
  MediaDirectory /var/istgt
  LogFacility "local7"
  Timeout 30
  NopInInterval 20
  DiscoveryAuthMethod Auto
  MaxSessions 16
  MaxConnections 4
  MaxR2T 32
  MaxOutstandingR2T 16
  DefaultTime2Wait 2
  DefaultTime2Retain 60
  FirstBurstLength 262144
  MaxBurstLength 1048576
  MaxRecvDataSegmentLength 262144
  InitialR2T Yes
  ImmediateData Yes
  DataPDUInOrder Yes
  DataSequenceInOrder Yes
  ErrorRecoveryLevel 0
[UnitControl]
  AuthMethod CHAP
  AuthGroup AuthGroup01
  Portal UC1 127.0.0.1:3261
  Netmask 127.0.0.1
[PortalGroup01]
  # IP address and port the target listens
  Portal DA1 10.0.0.30:3260
[InitiatorGroup01]
  InitiatorName "ALL"
  # network range or IP address you allow to connect to the target
  Netmask 10.0.0.51/32
  Netmask 10.0.0.61/32
[LogicalUnit01]
  # specify any name
  # this name is concatenated after [NodeBase] value
  # and the concatenated name becomes target IQN
  TargetName "ns.target01"
  Mapping PortalGroup01 InitiatorGroup01
  AuthMethod CHAP
  AuthGroup AuthGroup01
  UseDigest Auto
  UnitType Disk
  # specify the disk you created
  LUN0 Storage /dev/zvol/zroot/ROOT/target01 Auto

root@belajarfreebsd:~# mv /usr/local/etc/istgt/auth.conf /usr/local/etc/istgt/auth.conf.org
root@belajarfreebsd:~# vi /usr/local/etc/istgt/auth.conf
# create new
# set CHAP username and secret
[AuthGroup01]
Auth "username" "userpassword"

root@belajarfreebsd:~# mv /usr/local/etc/istgt/istgtcontrol.conf /usr/local/etc/istgt/istgtcontrol.conf.org
root@belajarfreebsd:~# vi /usr/local/etc/istgt/istgtcontrol.conf
# create new
[Global]
  Timeout 60
  AuthMethod CHAP
  Auth "username" "userpassword"
  Host 127.0.0.1
  Port 3261
  # the name is [(NodeBase):(TargetName)] you set in [istgt.conf]
  TargetName "iqn.2023-12.belajarfreebsd.or.id:ns.target01"
  Lun 0
  Flags "ro"
  Size "auto"

root@belajarfreebsd:~# chmod 600 /usr/local/etc/istgt/auth.conf /usr/local/etc/istgt/istgtcontrol.conf
root@belajarfreebsd:~# echo 'istgt_enable="YES"' >> /etc/rc.conf
root@belajarfreebsd:~# service istgt start
Starting istgt.
istgt version 0.5 (20150713)
normal mode
using kqueue
using host atomic
LU1 HDD UNIT
LU1: LUN0 file=/dev/zvol/zroot/ROOT/target01, size=10737418240
LU1: LUN0 20971520 blocks, 512 bytes/block
LU1: LUN0 10.0GB storage for iqn.2023-12.belajarfreebsd.or.id:ns.target01
LU1: LUN0 serial 10000001
LU1: LUN0 read cache enabled, write cache enabled
LU1: LUN0 command queuing enabled, depth 32

root@belajarfreebsd:~# istgtcontrol list
lun0 storage "/dev/zvol/zroot/ROOT/target01" 10737418240
DONE LIST command