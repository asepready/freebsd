Mail Server : Install Postfix
 	
Install Postfix to configure SMTP Server.
[1]	Install Postfix.
```sh
root@mail:~ # pkg install -y postfix
```
[2]	This example shows to configure SMTP-Auth to use Dovecot's SASL feature.
```sh
root@mail:~ # vi /usr/local/etc/postfix/main.cf
# line 98 : uncomment and specify hostname
myhostname = mail.asepready.id

# line 106 : uncomment and specify domain name
mydomain = asepready.id

# line 122 : uncomment
myorigin = $mydomain

# line 136 : uncomment
inet_interfaces = all

# line 184 : uncomment
mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain

# line 227 : uncomment
local_recipient_maps = unix:passwd.byname $alias_maps

# line 272, 273 : uncomment and comment out
mynetworks_style = subnet
#mynetworks_style = host

# line 286 : uncomment and specify your network
mynetworks = 127.0.0.0/8, 10.0.0.0/24

# line 410 : uncomment
alias_maps = hash:/etc/aliases

# line 420 : uncomment
alias_database = hash:/etc/aliases

# line 442 : uncomment (use Maildir)
home_mailbox = Maildir/

# line 578 : add
smtpd_banner = $myhostname ESMTP

# add follows to last line
# disable SMTP VRFY command
disable_vrfy_command = yes

# require HELO command to sender hosts
smtpd_helo_required = yes

# limit an email size
# example below means 10M bytes limit
message_size_limit = 10240000

# SMTP-Auth settings
smtpd_sasl_type = dovecot
smtpd_sasl_path = private/auth
smtpd_sasl_auth_enable = yes
smtpd_sasl_security_options = noanonymous
smtpd_sasl_local_domain = $myhostname
smtpd_recipient_restrictions = 
  permit_mynetworks,
  permit_sasl_authenticated,
  reject_unauth_destination

# disable sendmail
root@mail:~ # sysrc sendmail_enable="NO"
root@mail:~ # vi /etc/periodic.conf
# create new
daily_clean_hoststat_enable="NO"
daily_status_mail_rejects_enable="NO"
daily_status_include_submit_mailq="NO"
daily_submit_queuerun="NO"

root@mail:~ # install -d /usr/local/etc/mail
root@mail:~ # install -m 0644 /usr/local/share/postfix/mailer.conf.postfix /usr/local/etc/mail/mailer.conf
root@mail:~ # postalias /etc/aliases
root@mail:~ # newaliases
root@mail:~ # service postfix enable
root@mail:~ # service postfix start
```
[3]	Configure additional settings for Postfix if you need.
It's possible to reject many spam emails with the settings below.
However, you should consider to apply the settings,
because sometimes normal emails are also rejected with them.
Especially, there are SMTP servers that forward lookup and reverse lookup of their hostnames on DNS do not match even if they are not spammers.
```sh
root@mail:~ # vi /usr/local/etc/postfix/main.cf
# add to last line
# reject unknown clients that forward lookup and reverse lookup of their hostnames on DNS do not match
smtpd_client_restrictions = permit_mynetworks, reject_unknown_client_hostname, permit

# rejects senders that domain name set in FROM are not registered in DNS or 
# not registered with FQDN
smtpd_sender_restrictions = permit_mynetworks, reject_unknown_sender_domain, reject_non_fqdn_sender

# reject hosts that domain name set in FROM are not registered in DNS or 
# not registered with FQDN when your SMTP server receives HELO command
smtpd_helo_restrictions = permit_mynetworks, reject_unknown_hostname, reject_non_fqdn_hostname, reject_invalid_hostname, permit

root@mail:~ # service postfix reload
```