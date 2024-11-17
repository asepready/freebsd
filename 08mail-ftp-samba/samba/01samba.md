Samba : Fully Accessed Shared Folder

Install Samba to Configure File Server. For example, Create a fully accessed shared Folder which anybody can read and write, and also authentication is not required.

[1]	Install and Configure Samba.
```sh
root@smb:~# pkg install -y samba416
root@smb:~# mkdir /home/share
root@smb:~# chmod 777 /home/share
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
[Share]
    # specify shared directory
    path = /home/share
    # allow writing
    writable = yes
    # allow guest user (nobody)
    guest ok = yes
    # looks all as guest user
    guest only = yes
    # set permission [777] when file created
    force create mode = 777
    # set permission [777] when folder created
    force directory mode = 777

root@smb:~# sysrc samba_server_enable="YES"
root@smb:~# service samba_server start
Performing sanity check on Samba configuration: OK
Starting nmbd.
Starting smbd.
```