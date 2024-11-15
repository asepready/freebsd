NFS : Configure NFS Server
 	
Configure NFS Server to share directories on your Network. This example is based on the environment like follows.
```
+---------------------------+          |          +-----------------------------+
|    [    NFS Server    ]   |10.0.0.30 | 10.0.0.51|    [    NFS Client    ]     |
|  ns.belajarfreebsd.or.id  +----------+----------+ node01.belajarfreebsd.or.id |
|                           |                     |                             |
+---------------------------+                     +-----------------------------+
```
[1]	Configure NFS Server.
```sh
root@belajarfreebsd:~# vi /etc/rc.conf
# add to last line
nfs_server_enable="YES"
nfsv4_server_enable="YES"
nfsuserd_enable="YES"
# specify your domain name
nfsuserd_flags="-domain belajarfreebsd.or.id"

root@belajarfreebsd:~# vi /etc/exports
# create new
# for example, set [/home/nfsshare] as NFS share
# [V4: /home] ⇒ specify NFSv4 root directory
# [-network *** -mask ***] ⇒ network range that you export NFS share
V4: /home -network 10.0.0.0 -mask 255.255.255.0
/home/nfsshare -maproot=root
root@belajarfreebsd:~# mkdir /home/nfsshare
root@belajarfreebsd:~# service nfsd start
Starting rpcbind.
Starting mountd.
Starting nfsd.
```