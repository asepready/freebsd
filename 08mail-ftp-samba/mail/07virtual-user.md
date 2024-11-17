Mail Server : Add Mail User Accounts (Virtual User)2024/04/17
 	
Add Mail User Accounts to use Mail Service. This example is for the case you use virtual mail-user accounts, not use OS accounts.

[1]	Configure basic Postfix settings and basic Dovecot settings first.

[2]	Configure additional settings to Postfix and Dovecot.
```sh
# create admin user for virtual mailboxes
root@mail:~# pw useradd vmail -u 20000 -d /home/vmail -s /usr/sbin/nologin -m
root@mail:~# vi /usr/local/etc/postfix/main.cf
# line 184 : comment out
#mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain
# line 442 : change
home_mailbox = /home/vmail/%d/%n/Maildir
# add to last line
# if specify multiple domains, specify comma or space separated
virtual_mailbox_domains = belajarfreebsd.or.id, virtual.host
virtual_mailbox_base = /home/vmail
virtual_mailbox_maps = hash:/usr/local/etc/postfix/virtual-mailbox
virtual_uid_maps = static:20000
virtual_gid_maps = static:20000

root@mail:~# vi /usr/local/etc/dovecot/conf.d/10-auth.conf
# line 100 : add
auth_mechanisms = cram-md5 plain login
# line 122 : comment out
#!include auth-system.conf.ext
# line 125 : uncomment
!include auth-passwdfile.conf.ext
# line 127 : uncomment
!include auth-static.conf.ext
root@mail:~# cp -p /usr/local/etc/dovecot/example-config/conf.d/auth-passwdfile.conf.ext /usr/local/etc/dovecot/conf.d/
root@mail:~# cp -p /usr/local/etc/dovecot/example-config/conf.d/auth-static.conf.ext /usr/local/etc/dovecot/conf.d/
root@mail:~# vi /usr/local/etc/dovecot/conf.d/auth-passwdfile.conf.ext
# line 8 : change
passdb {
  driver = passwd-file
  args = scheme=CRAM-MD5 username_format=%u /usr/local/etc/dovecot/users

# line 11 : comment out all [userdb] section
#userdb {
#  driver = passwd-file
#  args = username_format=%u /usr/local/etc/dovecot/users
#.....
#.....
#}

root@mail:~# vi /usr/local/etc/dovecot/conf.d/auth-static.conf.ext
# line 21-24 : uncomment and change
userdb {
  driver = static
  args = uid=vmail gid=vmail home=/home/vmail/%d/%n
}

root@mail:~# vi /usr/local/etc/dovecot/conf.d/10-mail.conf
# line 30 : change
mail_location = maildir:/home/vmail/%d/%n/Maildir
root@mail:~# service postfix reload
root@mail:~# service dovecot reload
```
[3]	Add virtual mail user accounts.
```sh
root@mail:~# vi /usr/local/etc/postfix/virtual-mailbox
# create new
# [user account] [mailbox]
freebsd@belajarfreebsd.or.id   belajarfreebsd.or.id/freebsd/Maildir/
openbsd@belajarfreebsd.or.id   belajarfreebsd.or.id/openbsd/Maildir/
netbsd@virtual.host   virtual.host/netbsd/Maildir/

root@mail:~# postmap /usr/local/etc/postfix/virtual-mailbox
# generate encrypted password
root@mail:~# doveadm pw -s CRAM-MD5
Enter new password:
Retype new password:
{CRAM-MD5}xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
root@mail:~# vi /usr/local/etc/dovecot/users
# create new
# [user account] [password]
freebsd@belajarfreebsd.or.id:{CRAM-MD5}xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
openbsd@belajarfreebsd.or.id:{CRAM-MD5}xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
netbsd@virtual.host:{CRAM-MD5}xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```
[4]	That's OK. Verify to test to send emails with E-Mail client.
For settings on this example, specify email address for [Username] on Email Client settings.
