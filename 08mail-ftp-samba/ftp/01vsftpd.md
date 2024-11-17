FTP : Install Vsftpd
 	
Install Vsftpd to configure FTP server to transfer files.

[1]	Install and Configure Vsftpd.
```sh
root@www:~ # pkg install -y vsftpd-ssl
root@www:~ # vi /usr/local/etc/vsftpd.conf
# line 12 : change NO
anonymous_enable=NO
# line 15 : uncomment
local_enable=YES
# line 18 : uncomment
write_enable=YES
# line 98, 99 : uncomment (enable chroot)
# and add the line to enable writable under the chroot directory
chroot_local_user=YES
chroot_list_enable=YES
allow_writeable_chroot=YES
# line 102 : uncomment (enable chroot list)
chroot_list_file=/etc/vsftpd.chroot_list
# line 134, 135 : uncomment (run as standalone mode)
listen=YES
background=YES
# add to last line : specify chroot directory if you need
# if not specified, users home directory equals FTP home directory
local_root=public_html
root@www:~ # vi /etc/vsftpd.chroot_list
# add users you allow to move over their home directory (not applied chroot setting)
freebsd
root@www:~ # sysrc vsftpd_enable="YES"
root@www:~ # service vsftpd start
Starting vsftpd.
```
