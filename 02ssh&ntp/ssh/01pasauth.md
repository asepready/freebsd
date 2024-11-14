OpenSSH : Password Authentication
 	
Configure SSH Server to manage a server from the remote computer. SSH uses 22/TCP.
[1]	The OpenSSH server allows login using password authentication by default, so if the service is enabled, you can log in remotely.
```sh
# check the status of sshd
root@belajarfreebsd:~# grep sshd /etc/rc.conf
sshd_enable="YES"
root@belajarfreebsd:~# service sshd status
sshd is running as pid 757.
# if sshd_enable="NO" is set, change it to YES and start the service
root@belajarfreebsd:~# service sshd start
SSH Client : FreeBSD
```
How to connect to SSH server from FreeBSD client computer.

[2]	Connect to the SSH server with a common user.
```sh
# ssh [username@hostname or IP address]
root@client:~# ssh sysadmin@belajarfreebsd.or.id
The authenticity of host 'dlp.srv.world (10.0.0.30)' can't be established.
ED25519 key fingerprint is SHA256:oN4KhZb5gSoBCvWBNw3IoayLZMY+jDHNVyun4sF6tOo.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'dlp.srv.world' (ED25519) to the list of known hosts.
(sysadmin@belajarfreebsd.or.id) Password for sysadmin@belajarfreebsd.or.id:
FreeBSD 14.0-RELEASE (GENERIC) #0 releng/14.0-n265380-f9716eee8ab4: Fri Nov 10 05:57:23 UTC 2023

Welcome to FreeBSD!
.....
.....
freebsd@dlp:~ $     # logined
```
[3]	It's possible to execute commands on remote Host by specifying commands as an argument of the ssh command.
```sh
# for example, open [/etc/passwd] on remote host
root@client:~# ssh sysadmin@belajarfreebsd.or.id "cat /etc/passwd"
(sysadmin@belajarfreebsd.or.id) Password for sysadmin@belajarfreebsd.or.id:
root:*:0:0:Charlie &:/root:/bin/sh
toor:*:0:0:Bourne-again Superuser:/root:
daemon:*:1:1:Owner of many system processes:/root:/usr/sbin/nologin
operator:*:2:5:System &:/:/usr/sbin/nologin
bin:*:3:7:Binaries Commands and Source:/:/usr/sbin/nologin
tty:*:4:65533:Tty Sandbox:/:/usr/sbin/nologin
kmem:*:5:65533:KMem Sandbox:/:/usr/sbin/nologin
.....
.....
```