Mail Server : SSL/TLS Setting

Configure SSL/TLS to encrypt connections.

[1]	Get SSL certificate, Refer to here.

[2]	Configure Postfix and Dovecot.
```sh
root@mail:~# vi /usr/local/etc/postfix/main.cf
# add to last line (replace certificate to yours)
# if you require TLS connection. replace [may] to [encrypt]
smtpd_tls_security_level = may
smtpd_tls_cert_file = /usr/local/etc/letsencrypt/live/mail.belajarfreebsd.or.id/fullchain.pem
smtpd_tls_key_file = /usr/local/etc/letsencrypt/live/mail.belajarfreebsd.or.id/privkey.pem
smtpd_tls_session_cache_database = btree:${data_directory}/smtpd_scache
root@mail:~# vi /usr/local/etc/postfix/master.cf
# line 19, 20, 22 : uncomment
submission inet n       -       n       -       -       smtpd
  -o syslog_name=postfix/submission
#  -o smtpd_tls_security_level=encrypt
  -o smtpd_sasl_auth_enable=yes

# if you use SMTPS (465), add follows to last line
smtps     inet  n       -       n       -       -       smtpd
  -o syslog_name=postfix/smtps
  -o smtpd_tls_wrappermode=yes
  -o smtpd_sasl_auth_enable=yes

root@mail:~# vi /usr/local/etc/dovecot/conf.d/10-ssl.conf
# line 12,13 : uncomment and specify your certificates
ssl_cert = </usr/local/etc/letsencrypt/live/mail.belajarfreebsd.or.id/fullchain.pem
ssl_key = </usr/local/etc/letsencrypt/live/mail.belajarfreebsd.or.id/privkey.pem
root@mail:~# service postfix reload
root@mail:~# service dovecot reload
```
[3]	For Client's settings, ( Mozilla Thunderbird ) Open account's property and move to [Server Settings] on the left pane, then Select [STARTTLS] or [SSL/TLS] on [Connection security] field on the right pane.

[4]	Move to [Outgoing Server] on the left pane, then Select [STARTTLS] or [SSL/TLS] on [Connection security] field. Furthermore, change port to the used port. ([STARTTLS] uses [587], [SSL/TLS] uses 465)

[5]	Verify possible to send or receive Emails normally.
