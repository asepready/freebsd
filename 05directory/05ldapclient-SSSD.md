OpenLDAP : LDAP Client (SSSD)
 	
This is the LDAP Client configuration example by using SSSD.

[1]	
To use SSSD, it needs to configure SSL/TLS setting on LDAP server side, refer to here.

[2]	Install and configure SSSD.
```sh
root@node02:~ # pkg install -y sssd pam_mkhomedir
root@node02:~ # vi /usr/local/etc/sssd/sssd.conf
# create new
# replace to your domain suffix for [dc=***,dc=***] section
[sssd]
services = nss, pam
domains = default

[domain/default]
id_provider = ldap
autofs_provider = ldap
auth_provider = ldap
chpass_provider = ldap
ldap_uri = ldap://dlp.srv.world/
ldap_search_base = dc=srv,dc=world
ldap_id_use_start_tls = True
ldap_tls_cacertdir = /etc/ssl/certs
cache_credentials = True
ldap_tls_reqcert = allow

[nss]
homedir_substring = /home

root@node02:~ # chmod 600 /usr/local/etc/sssd/sssd.conf
root@node02:~ # vi /etc/pam.d/system
# add like follows
# auth
#auth           sufficient      pam_krb5.so             no_warn try_first_pass
#auth           sufficient      pam_ssh.so              no_warn try_first_pass
auth            sufficient      pam_sss.so              no_warn try_first_pass
auth            required        pam_unix.so             no_warn try_first_pass nullok

# account
#account        required        pam_krb5.so
account         required        pam_login_access.so
account         required        pam_sss.so             no_warn ignore_authinfo_unavail ignore_unknown_user
account         required        pam_unix.so

# session
#session        optional        pam_ssh.so              want_agent
session         required        pam_lastlog.so          no_fail
session         required        pam_mkhomedir.so        umask=0077

# password
#password       sufficient      pam_krb5.so             no_warn try_first_pass
password        required        pam_unix.so             no_warn try_first_pass

root@node02:~ # vi /etc/pam.d/sshd
# add like follows
# auth
#auth           sufficient      pam_krb5.so             no_warn try_first_pass
#auth           sufficient      pam_ssh.so              no_warn try_first_pass
auth            sufficient      pam_sss.so              no_warn try_first_pass
auth            required        pam_unix.so             no_warn try_first_pass

# account
account         required        pam_nologin.so
#account        required        pam_krb5.so
account         required        pam_login_access.so
account         required        pam_sss.so             no_warn ignore_authinfo_unavail ignore_unknown_user
account         required        pam_unix.so

# session
#session        optional        pam_ssh.so              want_agent
session         required        pam_permit.so
session         required        pam_mkhomedir.so        umask=0077

# password
#password       sufficient      pam_krb5.so             no_warn try_first_pass
password        required        pam_unix.so             no_warn try_first_pass

root@node02:~ # vi /etc/nsswitch.conf
# change like follows
#
# nsswitch.conf(5) - name service switch configuration file
#
group: files sss
group_compat: nis
hosts: files dns
netgroup: compat
networks: files
passwd: files sss
passwd_compat: nis
shells: files
services: compat
services_compat: nis
protocols: files
rpc: files

root@node02:~ # service sssd enable
sssd enabled in /etc/rc.conf
root@node02:~ # service sssd start
Starting sssd.
root@node02:~ # exit
FreeBSD/amd64 (node01.srv.world) (ttyu0)

login: freebsd      # LDAP user
Password:           # LDAP password

FreeBSD 14.0-RELEASE (GENERIC) #0 releng/14.0-n265380-f9716eee8ab4: Fri Nov 10 05:57:23 UTC 2023

Welcome to FreeBSD!

.....
.....

freebsd@node02:~ $    # logined
```
[3]	To change LDAP password by user itself, use ldappasswd command.
```sh
freebsd@node02:~ $ ldappasswd -H ldap://dlp.srv.world:389 -x -D "uid=freebsd,ou=people,dc=srv,dc=world" -W -a old_password -s new_password
Enter LDAP Password:   # input current LDAP password
freebsd@node02:~ $