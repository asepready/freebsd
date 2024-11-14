OpenSSH : SSH Key-Pair Authentication
 	
Configure SSH server to login with Key-Pair Authentication. Create a private key for client and a public key for server to do it.

[1]	Create Key-Pair by each user, so login with a common user on SSH Server Host and work like follows.
```sh
# create key-pair
sysadmin@belajarfreebsd:~$ ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/home/sysadmin/.ssh/id_rsa):   # Enter or input changes if you want
Enter passphrase (empty for no passphrase):   # set passphrase (if set no passphrase, Enter with empty)
Enter same passphrase again:
Your identification has been saved in /home/sysadmin/.ssh/id_rsa
Your public key has been saved in /home/sysadmin/.ssh/id_rsa.pub
The key fingerprint is:
SHA256:uNTwILz1kwqxTKplnlSWcxqEIB0mZQlyERz2wRML1yE sysadmin@belajarfreebsd.or.id
The key's randomart image is:
.....
.....

sysadmin@belajarfreebsd:~$ ls -l ~/.ssh
total 18
-rw-------  1 sysadmin sysadmin 2655 Dec 19 10:36 id_rsa
-rw-r--r--  1 sysadmin sysadmin  575 Dec 19 10:36 id_rsa.pub
-rw-------  1 sysadmin sysadmin  846 Dec 19 10:12 known_hosts
-rw-r--r--  1 sysadmin sysadmin   98 Dec 19 10:12 known_hosts.old

sysadmin@belajarfreebsd:~$ mv ~/.ssh/id_rsa.pub ~/.ssh/authorized_keys
```
[2]	Transfer the private key created on the Server to a Client, then it's possible to login with Key-Pair authentication.
```sh
sysadmin@node01:~$ mkdir ~/.ssh
sysadmin@node01:~$ chmod 700 ~/.ssh
# transfer the private key to the local ssh directory
sysadmin@node01:~$ scp sysadmin@belajarfreebsd.or.id:/home/sysadmin/.ssh/id_rsa ~/.ssh/
(sysadmin@belajarfreebsd.or.id) Password for sysadmin@belajarfreebsd.or.id:
id_rsa         100% 2655     2.8MB/s   00:00

sysadmin@node01:~$ ssh sysadmin@belajarfreebsd.or.id
Enter passphrase for key '/home/sysadmin/.ssh/id_rsa':   # passphrase if you set
Last login: Tue Dec 19 10:01:15 2023 from 10.0.0.250
sysadmin 14.0-RELEASE (GENERIC) #0 releng/14.0-n265380-f9716eee8ab4: Fri Nov 10 05:57:23 UTC 2023

Welcome to sysadmin!
.....
.....

sysadmin@belajarfreebsd:~$     # logined
```
[3]	If you set [PasswordAuthentication no], it's more secure.
```sh
root@belajarfreebsd:~# vi /etc/ssh/sshd_config
# line 61 : uncomment
PasswordAuthentication no
# line 65 : uncomment and change
KbdInteractiveAuthentication no
root@belajarfreebsd:~# service sshd restart
