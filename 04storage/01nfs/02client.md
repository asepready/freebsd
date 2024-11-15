NFS : Configure NFS Client
 	
Configure NFS Client to mount NFS Share on NFS Client. This example is based on the environment like follows.

```
+---------------------------+          |          +-----------------------------+
|    [    NFS Server    ]   |10.0.0.30 | 10.0.0.51|    [    NFS Client    ]     |
|  ns.belajarfreebsd.or.id  +----------+----------+ node01.belajarfreebsd.or.id |
|                           |                     |                             |
+---------------------------+                     +-----------------------------+
```

[1]	Configure NFS Client.
```sh
root@node01:~ # vi /etc/rc.conf
# add to last line
nfsuserd_enable="YES"
# specify your domain name that is the same one on NFS server
nfsuserd_flags="-domain belajarfreebsd.or.id"

# mount NFS share with NFSv4
# for NFSv4 mounting,
# specify the relative path for the NFS shared directory from the NFSv4 root directory you specified on the server side
root@node01:~ # mount -t nfs -o nfsv4 ns.belajarfreebsd.or.id:/nfsshare /mnt
root@node01:~ # df -hT /mnt
Filesystem               Type    Size    Used   Avail Capacity  Mounted on
ns.belajarfreebsd.or.id:/nfsshare  nfs      26G    184K     26G     0%    /mnt

root@node01:~ # umount /mnt
# mount NFS share with NFSv3
# for NFSv3 mounting,
# it's not the relative path, specify the full path
root@node01:~ # mount -t nfs -o nfsv3 ns.belajarfreebsd.or.id:/home/nfsshare /mnt
root@node01:~ # df -hT /mnt
Filesystem                    Type    Size    Used   Avail Capacity  Mounted on
ns.belajarfreebsd.or.id:/home/nfsshare  nfs      26G    168K     26G     0%    /mnt
```
[2]	To mount automatically when System starts, add setting in [/etc/fstab].
```sh
root@node01:~ # vi /etc/fstab
# add to last line : set NFSv4 share
# Device                Mountpoint      FStype  Options         Dump    Pass#
/dev/gpt/efiboot0               /boot/efi       msdosfs rw              2       2
/dev/vtbd0p3            none    swap    sw              0       0
ns.belajarfreebsd.or.id:/nfsshare /mnt    nfs     nfsv4,rw        0       0
```
[3]	To mount dynamically when anyone access to NFS Share, Configure Automount.
```sh
root@node01:~ # vi /etc/fstab
# add [noauto] option
# Device                Mountpoint      FStype  Options         Dump    Pass#
/dev/gpt/efiboot0               /boot/efi       msdosfs rw              2       2
/dev/vtbd0p3            none    swap    sw              0       0
ns.belajarfreebsd.or.id:/nfsshare /mnt    nfs     nfsv4,rw,noauto        0       0

root@node01:~ # vi /etc/auto_master
# comment out
#/net           -hosts          -nobrowse,nosuid,intr

# uncomment
/-              -noauto

root@node01:~ # echo 'autofs_enable="YES"' >> /etc/rc.conf
root@node01:~ # service automountd start
root@node01:~ # df -hT /mnt
Filesystem   Type      Size    Used   Avail Capacity  Mounted on
map -noauto  autofs      0B      0B      0B   100%    /mnt

root@node01:~ # ls -l /mnt
total 10
drwxr-xr-x   3 root    wheel   -      4 Dec 22 16:23 ./
drwxr-xr-x  20 root    wheel   uarch 25 Dec 22 16:59 ../
drwxr-xr-x   2 sysadmin sysadmin -      3 Dec 22 15:57 dir01/
-rw-r--r--   1 root    wheel   -      9 Dec 22 16:23 testfile.txt

root@node01:~ # df -hT /mnt
Filesystem               Type    Size    Used   Avail Capacity  Mounted on
ns.belajarfreebsd.or.id:/nfsshare  nfs      26G    168K     26G     0%    /mnt
```