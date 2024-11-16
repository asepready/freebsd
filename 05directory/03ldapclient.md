OpenLDAP : Configure LDAP Client
 	
Configure LDAP Client in order to share users' accounts in your local networks.

[1]	Install OpenLDAP Client.
```sh
root@node01:~ # pkg install -y openldap26-client nss-pam-ldapd pam_mkhomedir
root@node01:~ # vi /usr/local/etc/nslcd.conf
# line 18 : change to LDAP server URI
uri ldap://dlp.srv.world/
# line 25 : change to your domain suffix
base dc=srv,dc=world
root@node01:~ # vi /usr/local/etc/openldap/ldap.conf
# add to last line
BASE   dc=srv,dc=world
URI    ldap://dlp.srv.world

root@node01:~ # vi /etc/pam.d/system
# add like follows
# auth
#auth           sufficient      pam_krb5.so             no_warn try_first_pass
#auth           sufficient      pam_ssh.so              no_warn try_first_pass
auth            sufficient      pam_ldap.so             no_warn try_first_pass
auth            required        pam_unix.so             no_warn try_first_pass nullok

# account
#account        required        pam_krb5.so
account         required        pam_login_access.so
account         required        pam_ldap.so             no_warn ignore_authinfo_unavail ignore_unknown_user
account         required        pam_unix.so

# session
#session        optional        pam_ssh.so              want_agent
session         required        pam_lastlog.so          no_fail
session         required        pam_mkhomedir.so        umask=0077

# password
#password       sufficient      pam_krb5.so             no_warn try_first_pass
password        required        pam_unix.so             no_warn try_first_pass

root@node01:~ # vi /etc/pam.d/sshd
# add like follows
# auth
#auth           sufficient      pam_krb5.so             no_warn try_first_pass
#auth           sufficient      pam_ssh.so              no_warn try_first_pass
auth            sufficient      pam_ldap.so             no_warn try_first_pass
auth            required        pam_unix.so             no_warn try_first_pass

# account
account         required        pam_nologin.so
#account        required        pam_krb5.so
account         required        pam_login_access.so
account         required        pam_ldap.so             no_warn ignore_authinfo_unavail ignore_unknown_user
account         required        pam_unix.so

# session
#session        optional        pam_ssh.so              want_agent
session         required        pam_permit.so
session         required        pam_mkhomedir.so        umask=0077

# password
#password       sufficient      pam_krb5.so             no_warn try_first_pass
password        required        pam_unix.so             no_warn try_first_pass

root@node01:~ # vi /etc/nsswitch.conf
# change like follows
#
# nsswitch.conf(5) - name service switch configuration file
#
group: files ldap
group_compat: nis
hosts: files dns
netgroup: compat
networks: files
passwd: files ldap
passwd_compat: nis
shells: files
services: compat
services_compat: nis
protocols: files
rpc: files

root@node01:~ # service nscd enable
nscd enabled in /etc/rc.conf
root@node01:~ # service nslcd enable
nslcd enabled in /etc/rc.conf
root@node01:~ # service nscd start
Starting nscd.
root@node01:~ # service nslcd start
Starting nslcd.
root@node01:~ # exit
FreeBSD/amd64 (node01.srv.world) (ttyu0)

login: freebsd      # LDAP user
Password:           # LDAP password

FreeBSD 14.0-RELEASE (GENERIC) #0 releng/14.0-n265380-f9716eee8ab4: Fri Nov 10 05:57:23 UTC 2023

Welcome to FreeBSD!

.....
.....

freebsd@node01:~ $   # logined
```
[2]	To change LDAP password by user itself, use ldappasswd command.
```
freebsd@node01:~ $ ldappasswd -H ldap://dlp.srv.world:389 -x -D "uid=freebsd,ou=people,dc=srv,dc=world" -W -a old_password -s new_password
Enter LDAP Password:   # input current LDAP password
freebsd@node01:~ $