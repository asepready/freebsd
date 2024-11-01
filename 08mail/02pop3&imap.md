Mail Server : Install Dovecot

Install Dovecot to configure POP/IMAP Server.

[1]	Install Dovecot.
```sh
root@mail:~ # pkg install -y dovecot
```
[2]	This example shows to configure to provide SASL function to Postfix.
```sh
root@mail:~ # mkdir /usr/local/etc/dovecot/conf.d
root@mail:~ # cp -p /usr/local/etc/dovecot/example-config/dovecot.conf /usr/local/etc/dovecot/
root@mail:~ # vi /usr/local/etc/dovecot//dovecot.conf
# line 25 : add
protocols = imap pop3
# line 30 : uncomment (if not use IPv6, remove [::])
listen = *, ::
root@mail:~ # cp -p /usr/local/etc/dovecot/example-config/conf.d/10-auth.conf /usr/local/etc/dovecot/conf.d/
root@mail:~ # vi /usr/local/etc/dovecot/conf.d/10-auth.conf
# line 10 : uncomment and change (allow plain text auth)
disable_plaintext_auth = no
# line 100 : add
auth_mechanisms = plain login
root@mail:~ # cp -p /usr/local/etc/dovecot/example-config/conf.d/10-mail.conf /usr/local/etc/dovecot/conf.d/
root@mail:~ # vi /usr/local/etc/dovecot/conf.d/10-mail.conf
# line 30 : uncomment and add
mail_location = maildir:~/Maildir
root@mail:~ # cp -p /usr/local/etc/dovecot/example-config/conf.d/10-master.conf /usr/local/etc/dovecot/conf.d/
root@mail:~ # vi /usr/local/etc/dovecot/conf.d/10-master.conf
# line 110-112 : uncomment and add like follows
  # Postfix smtp-auth
  unix_listener /var/spool/postfix/private/auth {
    mode = 0666
    user = postfix
    group = postfix
  }

root@mail:~ # cp -p /usr/local/etc/dovecot/example-config/conf.d/10-ssl.conf /usr/local/etc/dovecot/conf.d/
root@mail:~ # vi /usr/local/etc/dovecot/conf.d/10-ssl.conf
# line 6 : uncomment
ssl = yes
# line 12, 13 : comment out
# * use this parameter when enabling SSL/TLS setting
#ssl_cert = </etc/ssl/certs/dovecot.pem
#ssl_key = </etc/ssl/private/dovecot.pem
root@mail:~ # cp -p /usr/local/etc/dovecot/example-config/conf.d/auth-system.conf.ext /usr/local/etc/dovecot/conf.d/
root@mail:~ # service dovecot enable
root@mail:~ # service dovecot start
```