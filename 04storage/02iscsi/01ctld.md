iSCSI : Configure Target (ctld)
 	
Configure Storage Server with iSCSI.

Storage server with iSCSI on network is called iSCSI Target, Client Host that connects to iSCSI Target is called iSCSI Initiator. This example is based on the environment like follows.

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
[2]	Configure iSCSI Target.
```sh
root@belajarfreebsd:~# vi /etc/ctl.conf
# create new
# set authentication group
# auth-group (any name)
auth-group auth01 {
    # login-name and password for CHAP authentication
    chap username userpassword
    # IP address you allow to connect to the target
    initiator-portal 10.0.0.51/32
    initiator-portal 10.0.0.61/32
}
# set portal
# portal-group (any name)
portal-group portal01 {
    # IP address the target listens
    listen 0.0.0.0:3260
    listen [::]:3260
    # authentication group to assign
    discovery-auth-group auth01
}
# set target
# target (any name) ⇒ naming rule : [ iqn.(year)-(month).(reverse of domain name):(any name) ]
target iqn.2023-12.belajarfreebsd.or.id:ns.target01 {
    # authentication group to assign
    auth-group auth01
    # portal group to assign
    portal-group portal01
    # LUN to assign ⇒ lun (number)
    lun 0 {
        # device path to assign
        path /dev/zvol/zroot/ROOT/target01
    }
}
# increase [target] section if setting multiple targets
target iqn.2023-12.belajarfreebsd.or.id:ns.target02 {
    auth-group auth01
    portal-group portal01
    lun 0 {
        path /home/iscsi_disks/target02.img
    }
}

root@belajarfreebsd:~# chmod 600 /etc/ctl.conf
root@belajarfreebsd:~# echo 'ctld_enable="YES"' >> /etc/rc.conf
root@belajarfreebsd:~# service ctld start
Starting ctld.
```