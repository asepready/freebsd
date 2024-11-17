Mail Server : Set Virtual Domain
 	
Configure for Virtual Domain to send an email with another domain name different from original domain.
This example is for the case you use OS user accounts.
If you use virtual mailbox accounts, refer to here.
For example, present domain name ⇒ belajarfreebsd.or.id
new domain name ⇒ virtual.host
a User [sysadmin] has an email address [sysadmin@mail.belajarfreebsd.or.id],
a User [openbsd] has an email address [sysadmin@mail.virtual.host],
the user [openbsd] uses the same name for before [@] with [sysadmin].
[1]	Configure Postfix.
```sh
root@mail:~ # vi /usr/local/etc/postfix/main.cf
# add to last line
virtual_alias_domains = virtual.host
virtual_alias_maps = hash:/usr/local/etc/postfix/virtual
root@mail:~ # vi /usr/local/etc/postfix/virtual
# add to first line
sysadmin@mail.virtual.host openbsd
root@mail:~ # postmap /usr/local/etc/postfix/virtual
root@mail:~ # service postfix reload
```
[2]	Set new account to Email client and verify possible to send emails.

