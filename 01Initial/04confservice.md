Initial Settings : Configure Services
 	
To see services status or enable/disable services, Configure like follows.
[1]	Display services.
```sh
# display list of services that are enabled
root@belajarfreebsd:~# service -e
/etc/rc.d/hostid
/etc/rc.d/zpool
/etc/rc.d/zpoolupgrade
/etc/rc.d/zpoolreguid
/etc/rc.d/zvol
/etc/rc.d/hostid_save
/etc/rc.d/kldxref
/etc/rc.d/zfsbe
/etc/rc.d/zfs
.....
.....

# list all services
root@belajarfreebsd:~# service -l
DAEMON
FILESYSTEMS
LOGIN
NETWORKING
SERVERS
accounting
adjkerntz
apm
auditd
auditdistd
automount
.....
.....
```
[2]	To enable or disable services, configure as follows.
```sh
# for example, stop sshd service
root@belajarfreebsd:~# service sshd stop
Stopping sshd.
Waiting for PIDS: 727.
root@belajarfreebsd:~# vi /etc/rc.conf
# disable sshd and turn off auto-starting
sshd_enable="NO"
# for example, enable ntpd service and turn on auto-starting
root@belajarfreebsd:~# vi /etc/rc.conf
# add to last line
ntpd_enable="YES"
# start ntpd service
root@belajarfreebsd:~# service ntpd start
Security policy loaded: MAC/ntpd (mac_ntpd)
Starting ntpd.
```