iSCSI : Configure iSCSI Initiator
 	
Configure iSCSI Initiator.

This example is based on the environment like follows.
```
+---------------------------+          |          +-----------------------------+
|    [   iSCSI Target   ]   |10.0.0.30 | 10.0.0.51|     [ iSCSI Initiator  ]    |
|  ns.belajarfreebsd.or.id  +----------+----------+ node01.belajarfreebsd.or.id |
|                           |                     |                             |
+---------------------------+                     +-----------------------------+
```
[1]	Configure iSCSI Initiator to connect to iSCSI Target.
```sh
root@node01:~# vi /etc/iscsi.conf
# create new
target01 {
    # target IP address
    targetaddress = 10.0.0.30;
    # target IQN
    targetname = "iqn.2023-12.world.srv:dlp.target01";
    authmethod = CHAP;
    # CHAP login-name you set on target
    chapiname = "username";
    # CHAP password you set on target
    chapsecret = "userpassword";
}

root@node01:~# echo 'iscsid_enable="YES"' >> /etc/rc.conf
root@node01:~# echo 'iscsictl_enable="YES"' >> /etc/rc.conf
root@node01:~# service iscsid start
Starting iscsid.
# login to target
# iscsictl -A -p (target IP) -t (target IQN) -u (CHAP login-name) -s (CHAP password)
root@node01:~# iscsictl -A -p 10.0.0.30 -t iqn.2023-12.world.srv:dlp.target01 -u username -s userpassword
da0 at iscsi1 bus 0 scbus6 target 0 lun 0
da0: <FREEBSD CTLDISK 0001> Fixed Direct Access SPC-5 SCSI device
da0: Serial Number MYSERIAL0000
da0: 150.000MB/s transfers
da0: Command Queueing enabled
da0: 10240MB (20971520 512 byte sectors)

# confirm established sessions
root@node01:~# iscsictl -L
Target name                          Target portal    State
iqn.2023-12.world.srv:dlp.target01   10.0.0.30        Connected: da0

root@node01:~# ls -l /dev/da0
crw-r-----  1 root operator - 0x75 Dec 27 11:06 /dev/da0

root@node01:~# geom disk list da0
Geom name: da0
Providers:
1. Name: da0
   Mediasize: 10737418240 (10G)
   Sectorsize: 512
   Stripesize: 16384
   Stripeoffset: 0
   Mode: r0w0e0
   descr: FREEBSD CTLDISK
   lunname: FREEBSD MYDEVID0000
   lunid: FREEBSD MYDEVID0000
   ident: MYSERIAL0000
   rotationrate: 0
   fwsectors: 63
   fwheads: 255

# to disconnect an established session, do like follows
root@node01:~# iscsictl -R -p 10.0.0.30 -t iqn.2023-12.world.srv:dlp.target01
da0 at iscsi1 bus 0 scbus6 target 0 lun 0
da0: <FREEBSD CTLDISK 0001> s/n MYSERIAL0000 detached
```
[2]	After setting iSCSI device, configure on Initiator to use it like follows.
```sh
# create UFS partition with GPT
root@node01:~# gpart create -s GPT da0
da0 created
root@node01:~# gpart add -t freebsd-ufs da0
da0p1 added
root@node01:~# gpart show da0
=>      40  20971440  da0  GPT  (10G)
        40        24       - free -  (12K)
        64  20971392    1  freebsd-ufs  (10G)
  20971456        24       - free -  (12K)

root@node01:~# newfs /dev/da0p1
/dev/da0p1: 10239.9MB (20971392 sectors) block size 32768, fragment size 4096
        using 17 cylinder groups of 625.22MB, 20007 blks, 80128 inodes.
super-block backups (for fsck_ffs -b #) at:
 192, 1280640, 2561088, 3841536, 5121984, 6402432, 7682880, 8963328, 10243776, 11524224, 12804672, 14085120, 15365568,
 16646016, 17926464, 19206912, 20487360

root@node01:~# mkdir /home/target01
root@node01:~# mount /dev/da0p1 /home/target01
root@node01:~# df -hT /home/target01
Filesystem  Type    Size    Used   Avail Capacity  Mounted on
/dev/da0p1  ufs     9.7G    8.0K    8.9G     0%    /home/target01

# if setting in fstab, add [late] option
root@node01:~# vi /etc/fstab
# Device                Mountpoint      FStype  Options         Dump    Pass#
/dev/gpt/efiboot0       /boot/efi       msdosfs rw              2       2
/dev/vtbd0p3            none    swap    sw              0       0
/dev/da0p1              /home/target01  ufs     rw,late 0       0
```