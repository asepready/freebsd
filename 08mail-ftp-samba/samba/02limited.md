Samba : Limited Shared Folder

Install Samba to Configure File Server. For example, Create a shared Folder that users in [smbgroup01] group can only access to shared folder [/home/share01] and also they are required user authentication.

[1]	Install and Configure Samba.
```sh
root@smb:~# pkg install -y samba416
root@smb:~# pw groupadd smbgroup01
root@smb:~# mkdir /home/share01
root@smb:~# chgrp smbgroup01 /home/share01
root@smb:~# chmod 770 /home/share01
root@smb:~# vi /usr/local/etc/smb4.conf
# create new
[global]
    unix charset = UTF-8
    workgroup = WORKGROUP
    server string = FreeBSD
    # network range you allow to access
    interfaces = 127.0.0.0/8 10.0.0.0/24
    bind interfaces only = yes
    map to guest = bad user

# any Share name you like
[Share01]
    # require authentication
    security = user
    # specify shared directory
    path = /home/share01
    # allow writing
    writable = yes
    # not allow guest user (nobody)
    guest ok = no
    # allow only [smbgroup01] group
    valid users = @smbgroup01
    # set group for new files/directories to [smbgroup01]
    force group = smbgroup01
    # set permission [770] when file created
    force create mode = 770
    # set permission [770] when folder created
    force directory mode = 770
    # inherit permissions from parent folder
    inherit permissions = yes 

root@smb:~# sysrc samba_server_enable="YES"
root@smb:~# service samba_server start
Performing sanity check on Samba configuration: OK
Starting nmbd.
Starting smbd.
# add Samba user
root@smb:~# pw useradd freebsd
root@smb:~# passwd freebsd
root@smb:~# smbpasswd -a freebsd
New SMB password:     # set passwords
Retype new SMB password:
Added user freebsd.
root@smb:~# pw groupmod smbgroup01 -m freebsd
```