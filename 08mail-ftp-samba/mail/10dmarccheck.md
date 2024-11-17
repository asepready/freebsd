Mail Server : Set DMARC Checking
 	
Configure Postfix to check DMARC (Domain-based Message Authentication, Reporting, and Conformance) on receiving mail.

To configure DMARC as a sender, see Configuring DMARC records on your DNS server.

[1]	Install and configure OpenDMARC.
```sh
root@mail:~# pkg install -y opendmarc
root@mail:~# cp -p /usr/local/etc/mail/opendmarc.conf.sample /usr/local/etc/mail/opendmarc.conf
root@mail:~# vi /usr/local/etc/mail/opendmarc.conf
# line 28 : uncomment and change
# name that appears in the Authentication-Results header
# use the server hostname in the [HOSTNAME] specification
AuthservID HOSTNAME

# line 169 : to enable failure report generation, uncomment and change to [true]
# if [true], generate failure reports if the sender requests them
# * on this example, proceed with the default setting [false]
# FailureReports false

# line 235 : uncomment and change
# skip checking for SMTP AUTH authenticated clients
IgnoreAuthenticatedClients true

# line 259 : uncomment
# list of hosts to skip checking
IgnoreHosts /usr/local/etc/opendmarc/ignore.hosts

# line 317 : uncomment and change
# if [true], reject message if DMARC evaluation fails
RejectFailures true

# line 345 : uncomment and change
# reject messages if their headers do not comply with RFC5322
RequiredHeaders true

# line 360 : uncomment
Socket inet:8893@localhost

# line 418 : specify the trusted [authserv-id]
# if [HOSTNAME] is specified, it will be replaced with the server hostname
# if multiple entries are specified, separate them with commas
TrustedAuthservIDs HOSTNAME

root@mail:~# mkdir /usr/local/etc/opendmarc
root@mail:~# vi /usr/local/etc/opendmarc/ignore.hosts
# create new file
# list hosts to skip
127.0.0.1
::1

root@mail:~# chown -R mailnull:mailnull /usr/local/etc/opendmarc
root@mail:~# service opendmarc enable
opendmarc enabled in /etc/rc.conf
root@mail:~# service opendmarc start
Starting opendmarc.
```
[2]	Configure Postfix.
```sh
root@mail:~# vi /usr/local/etc/postfix/main.cf
# add opendmark to [smtpd_milters]
smtpd_milters = inet:127.0.0.1:8891, inet:127.0.0.1:8893
non_smtpd_milters = $smtpd_milters
milter_default_action = accept

root@mail:~# service postfix reload
```
[3]	Send an email to your email address from Gmail or similar. If the header shows [Authentication-Results: mail.srv.world; dmarc=pass ***], then everything is OK.