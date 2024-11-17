Samba : Samba Winbind

Join in Windows Active Directory Domain with Samba Winbind.

This tutorial needs Windows Active Directory Domain Service in your Local Network.

This example is based on the environment like follows.
```
Domain Server	: Windows Server 2022
Hostname	: fd3s.belajarfreebsd.or.id
Domain Name	: belajarfreebsd.or.id
NetBIOS Name	: FD3S01
Realm	: BELAJARFREEBSD.OR.ID
```
[1]	Install Samba.
```sh
root@smb:~# pkg install -y samba416 krb5 pam_mkhomedir
```
[2]	Configure Samba to bind Active Directory domain.
```sh
root@smb:~# vi /etc/krb5.conf
# create new
[libdefaults]
  # specify Realm
  default_realm = BELAJARFREEBSD.OR.ID

# add to specify Realm and Hostname of AD
[realms]
  BELAJARFREEBSD.OR.ID = {
    kdc = fd3s.belajarfreebsd.or.id
    admin_server = fd3s.belajarfreebsd.or.id
  }

root@smb:~# vi /usr/local/etc/smb4.conf
# create new
# replace [realm] and [workgroup] for your environment
[global]
    kerberos method = secrets and keytab
    realm = BELAJARFREEBSD.OR.ID
    workgroup = FD3S01
    security = ads
    template shell = /bin/sh
    winbind enum groups = Yes
    winbind enum users = Yes
    winbind separator = +
    idmap config * : rangesize = 1000000
    idmap config * : range = 1000000-19999999
    idmap config * : backend = autorid

root@smb:~# vi /etc/nsswitch.conf
# change like follows
group: files winbind
group_compat: nis
hosts: files dns
netgroup: compat
networks: files
passwd: files winbind
passwd_compat: nis
shells: files
services: compat
services_compat: nis
protocols: files
rpc: files

root@smb:~# vi /etc/resolv.conf
# change DNS setting to refer to AD
search belajarfreebsd.or.id
nameserver 10.0.0.100
root@smb:~# vi /etc/pam.d/system
# add lines like follows
# auth
#auth           sufficient      pam_krb5.so             no_warn try_first_pass
#auth           sufficient      pam_ssh.so              no_warn try_first_pass
auth            sufficient      pam_winbind.so          try_first_pass
auth            required        pam_unix.so             no_warn try_first_pass nullok

# account
#account        required        pam_krb5.so
account         required        pam_login_access.so
account         sufficient      pam_winbind.so
account         required        pam_unix.so

# session
#session        optional        pam_ssh.so              want_agent
session         optional        pam_mkhomedir.so
session         required        pam_lastlog.so          no_fail

# password
#password       sufficient      pam_krb5.so             no_warn try_first_pass
password        required        pam_unix.so             no_warn try_first_pass

# set winbind auth for sshd, too
root@smb:~# vi /etc/pam.d/sshd
# auth
#auth           sufficient      pam_krb5.so             no_warn try_first_pass
#auth           sufficient      pam_ssh.so              no_warn try_first_pass
auth            sufficient      pam_winbind.so          try_first_pass
auth            required        pam_unix.so             no_warn try_first_pass

# account
account         required        pam_nologin.so
#account        required        pam_krb5.so
account         required        pam_login_access.so
account         sufficient      pam_winbind.so
account         required        pam_unix.so

# session
#session        optional        pam_ssh.so              want_agent
session         optional        pam_mkhomedir.so
session         required        pam_permit.so

# password
#password       sufficient      pam_krb5.so             no_warn try_first_pass
password        required        pam_unix.so             no_warn try_first_pass
```
[3]	Join in Active Directory Domain.
```sh
# join in domain [-U (AD user)]
root@smb:~# net ads join -U Administrator
Password for [FD3S01\Administrator]:
Using short domain name -- FD3S01
Joined 'SMB' to dns domain 'srv.world'
No DNS domain configured for smb. Unable to perform DNS Update.
DNS update failed: NT_STATUS_INVALID_PARAMETER
root@smb:~# sysrc samba_server_enable="YES"
root@smb:~# sysrc samba_enable="NO"
root@smb:~# sysrc nmbd_enable="NO"
root@smb:~# sysrc smbd_enable="NO"
root@smb:~# sysrc winbindd_enable="YES"
root@smb:~# service samba_server start
Performing sanity check on Samba configuration: OK
Starting winbindd.
# show domain info
root@smb:~# net ads info
LDAP server: 10.0.0.100
LDAP server name: fd3s.belajarfreebsd.or.id
Realm: SRV.WORLD
Bind Path: dc=SRV,dc=WORLD
LDAP port: 389
Server time: Wed, 14 Feb 2024 14:35:28 JST
KDC server: 10.0.0.100
Server time offset: 2
Last machine account password change: Wed, 14 Feb 2024 14:16:16 JST

# show AD user list
root@smb:~# wbinfo -u
FD3S01+administrator
FD3S01+guest
FD3S01+krbtgt
FD3S01+serverworld
FD3S01+aduser01

# create home root directory that name is the same with workgroup
# and verify possible to login with AD user
root@smb:~# mkdir /home/FD3S01
root@smb:~# exit

FreeBSD/amd64 (smb.srv.world) (ttyu0)

login: FD3S01+serverworld
Password:
FreeBSD 14.0-RELEASE (GENERIC) #0 releng/14.0-n265380-f9716eee8ab4: Fri Nov 10 05:57:23 UTC 2023

Welcome to FreeBSD!
.....
.....

FD3S01+serverworld@smb:/ $ id
uid=2001103(FD3S01+serverworld) gid=2000513(FD3S01+domain users) groups=2000513(FD3S01+domain users),2000512(FD3S01+domain admins),2000572(FD3S01+denied rodc password replication group),2001103(FD3S01+serverworld),2001104(FD3S01+esx admins)
```