OpenSSH : Use SSHFS

It's possible to mount filesystem on another Host via SSH with SSHFS.

[1]	Install fuse-sshfs.
```sh
root@belajarfreebsd:~# pkg install -y fusefs-sshfs
root@belajarfreebsd:~# vi /boot/loader.conf
# add to last line
fusefs_load="YES"
root@belajarfreebsd:~# vi /etc/sysctl.conf
# add to last line
vfs.usermount=1
root@belajarfreebsd:~# reboot
```
[2]	Try to use SSHFS with any user.

For example, [sysadmin] user mounts [/home/sysadmin/work] on [node01.belajarfreebsd.or.id] to local [~/sshmnt].
```sh
sysadmin@belajarfreebsd:~ $ mkdir ~/sshmnt
# mount with SSHFS
sysadmin@belajarfreebsd:~ $ sshfs node01.belajarfreebsd.or.id:/home/sysadmin/work ~/sshmnt
(freebsd@node01.belajarfreebsd.or.id) Password for freebsd@node01.belajarfreebsd.or.id:   # password of the user
sysadmin@belajarfreebsd:~ $ df -hT /home/freebsd/sshmnt
Filesystem                           Type            Size    Used   Avail Capacity  Mounted on
node01.belajarfreebsd.or.id:/home/sysadmin/work  fusefs.sshfs     26G    212K     26G     0%    /home/freebsd/sshmnt
# mounted

# for unmount, do like follows
sysadmin@belajarfreebsd:~ $ umount ~/sshmnt
```