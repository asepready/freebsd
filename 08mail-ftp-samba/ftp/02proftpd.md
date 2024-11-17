FTP : Install ProFTPD
 	
Install ProFTPD to configure FTP Server.

[1]	Install and Configure ProFTPD.
```sh
root@www:~ # pkg install -y proftpd
root@www:~ # vi /usr/local/etc/proftpd.conf
# line 10 : change to your hostname
ServerName "www.srv.world"
# line 19 : turn to [off] if you do not need
UseIPv6 off
# line 41 : uncomment (specify root directory for chroot)
DefaultRoot ~
root@www:~ # vi /etc/ftpusers
# add users you prohibit FTP connection
test
root@www:~ # sysrc proftpd_enable="YES"
root@www:~ # service proftpd start
Starting proftpd.
```