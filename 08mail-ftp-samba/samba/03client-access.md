Samba : Access to Share from Clients (FreeBSD)
 	
Access to Share from Client Hosts.

[1]	On FreeBSD clients with CUI, access like follows.
```sh
root@node01:~# pkg install -y samba416
# on [smbclient] command access
# smbclient (share name) -U (user name)
root@node01:~# smbclient '\\smb.srv.world\Share01' -U freebsd
Password for [WORKGROUP\freebsd]:
Try "help" to get a list of possible commands.
smb: \> ls 
  .                                   D        0  Wed Feb 14 10:37:20 2024
  ..                                  D        0  Wed Feb 14 10:29:14 2024
  New Text Document.txt               A        9  Wed Feb 14 10:45:08 2024
  New folder                          D        0  Wed Feb 14 10:37:16 2024

                26591248 blocks of size 1024. 26591064 blocks available

# download a file
smb: \> mget "New Text Document.txt" 
Get file New Text Document.txt? y
getting file \New Text Document.txt of size 9 as New Text Document.txt (8.8 KiloBytes/sec) (average 8.8 KiloBytes/sec)
smb: \> !ls
.cshrc                  .login                  .sh_history             .viminfo
.k5login                .profile                .shrc                   New Text Document.txt
smb: \> exit
```
Samba : Access to Share from Clients (Windows)
 	
It's the way to access to the shared folder. This example is on Windows 11.

[2]	Open File Explorer and right-click the [Network] on the left pane, then select [Map Network Drive].

[3]	Specify the shared folder Path on [Folder] section and Click the [Finish] button.

[4]	Authentication is required if you set common shared folder with authentication, Input Samba username and password you added.

[5]	After successfully authentication, it's possible to access to shared folder.
