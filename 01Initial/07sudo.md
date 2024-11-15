Initial Settings : Configure Sudo2023/12/15
 	
Configure Sudo to separate users' duty if some people share privileges.
[1]	Install Sudo.
```sh
root@belajarfreebsd:~# pkg install -y sudo
```
[2]	Transfer all root privilege to a user.
```sh
root@belajarfreebsd:~# visudo
# add to last line : user [sysadmin] can use all root privilege
# how to write ⇒ destination host=(owner) command
sysadmin    ALL=(ALL:ALL) ALL

# verify with user [sysadmin]
sysadmin@belajarfreebsd:~$ ls -l /root
total 0
ls: /root: Permission denied
# denied

sysadmin@belajarfreebsd:~$ sudo ls -l /root
Password:   # sysadmin's password
total 64
-rw-r--r--  2 root wheel 1011 Nov 10 17:11 .cshrc
-rw-r--r--  1 root wheel   66 Nov 10 17:49 .k5login
-rw-r--r--  1 root wheel  316 Nov 10 17:11 .login
-rw-r--r--  2 root wheel  495 Nov 10 17:11 .profile
-rw-------  1 root wheel  932 Dec 15 10:46 .sh_history
-rw-r--r--  1 root wheel 1174 Nov 10 17:11 .shrc
-rw-------  1 root wheel 3233 Dec 15 10:45 .viminfo
-rw-------  1 root wheel  564 Dec 15 10:41 mbox
# possible executed
```
[3]	In addition to the setting [1], set that some commands are not allowed.
```sh
root@belajarfreebsd:~# visudo
# add alias for the kind of shutdown commands
# Cmnd alias specification
Cmnd_Alias SHUTDOWN = /sbin/halt, /sbin/shutdown, \
/sbin/poweroff, /sbin/reboot, /sbin/init

# add ( commands in alias [SHUTDOWN] are not allowed )
sysadmin    ALL=(ALL:ALL) ALL, !SHUTDOWN

# verify with user [sysadmin]
sysadmin@belajarfreebsd:~$ sudo /sbin/reboot
Password:
Sorry, user sysadmin is not allowed to execute '/sbin/reboot' as root on hosts.
# denied as setting
```
[4]	Transfer some commands with root privilege to users in a group.
```sh
root@belajarfreebsd:~# visudo
# add alias for the kind of user management commands
# Cmnd alias specification
Cmnd_Alias USERMGR = /usr/sbin/adduser, /usr/sbin/pw, /usr/sbin/rmuser, \
/usr/bin/passwd

# add to last line
%usermgr   ALL=(ALL:ALL) USERMGR

root@belajarfreebsd:~# pw groupadd usermgr
root@belajarfreebsd:~# pw groupmod usermgr -m sysadmin
# verify with user [sysadmin]
sysadmin@belajarfreebsd:~$ sudo /usr/sbin/pw useradd testuser
sysadmin@belajarfreebsd:~$
sysadmin@belajarfreebsd:~$ sudo /usr/bin/passwd testuser
Changing local password for testuser
New Password:
Retype New Password:
# possible executed
```
[5]	Transfer some specific commands with root privilege to a user.
```sh
root@belajarfreebsd:~# visudo
# add to last line : set specific commands to each user
openbsd   ALL=(ALL:ALL) /usr/local/sbin/visudo
dragonfly ALL=(ALL:ALL) /usr/sbin/adduser, /usr/sbin/pw, /usr/sbin/rmuser, \
                        /usr/bin/passwd
linux     ALL=(ALL:ALL) /usr/bin/vi

# verify with user [openbsd]
openbsd@hosts:~ $ sudo /usr/local/sbin/visudo
# possible open and edit
## sudoers file.
##

## This file MUST be edited with the 'visudo' command as root.
## Failure to use 'visudo' may result in syntax or file permission errors
## that prevent sudo from running.
.....
.....

# verify with user [dragonfly]
dragonfly@hosts:~ $ sudo /usr/sbin/pw userdel testuser -r
dragonfly@hosts:~ $     # possible executed
# verify with user [linux]
linux@hosts:~ $ sudo /usr/bin/vi /root/.profile
# possible open and edit
#
HOME=/root
export HOME
.....
.....
```
[6]	Sudo logs are recorded in [/var/log/auth.log] by default, but if you want to record only sudo logs in a 
```sh
separate file, configure as follows.
root@belajarfreebsd:~# visudo
# add to last line
Defaults syslog=local1
root@localhost:~# vi /etc/syslog.conf
# line 10, 11 : add
local1.*                                        /var/log/sudo.log
auth.info;authpriv.info;local1.none             /var/log/auth.log

root@belajarfreebsd:~# touch /var/log/sudo.log
root@belajarfreebsd:~# chmod 600 /var/log/sudo.log
root@belajarfreebsd:~# service syslogd reload
```