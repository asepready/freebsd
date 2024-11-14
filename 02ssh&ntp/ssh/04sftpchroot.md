OpenSSH : SFTP only + Chroot2023/12/19
 	
Configure SFTP only + Chroot. Some users who are applied this setting can access only with SFTP and also applied chroot directory.
[1]	For example, Set [/home] as the Chroot directory.
```sh
# create a group for SFTP only
root@belajarfreebsd:~# pw groupadd sftp_users
# apply to a user [sysadmin] for SFTP only as an example
root@belajarfreebsd:~# pw groupmod sftp_users -m sysadmin
root@belajarfreebsd:~# vi /etc/ssh/sshd_config
# line 114 : comment out and add a line like below
#Subsystem sftp /usr/libexec/sftp-server
Subsystem sftp internal-sftp
# add to the end
Match Group sftp_users
    X11Forwarding no
    AllowTcpForwarding no
    ChrootDirectory /home
    ForceCommand internal-sftp

root@belajarfreebsd:~# service sshd restart
```
[2]	Try to access with a user and verify the settings.
```sh
sysadmin@node01:~ $ ssh sysadmin@belajarfreebsd.or.id
Enter passphrase for key '/home/sysadmin/.ssh/id_rsa':
This service allows sftp connections only.
Connection to belajarfreebsd.or.id closed.   # denied as settings

sysadmin@node01:~ $ sftp sysadmin@belajarfreebsd.or.id
Enter passphrase for key '/home/sysadmin/.ssh/id_rsa':
Connected to belajarfreebsd.or.id.
sftp>
```