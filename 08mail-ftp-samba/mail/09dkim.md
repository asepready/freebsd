Mail Server : Set DKIM
 	
Configure DKIM (Domain Keys Identified Mail) in Postfix.

In order to register the generated public key in DNS, you will need the DNS server that registers your email domain.

[1]	Install and configure OpenDKIM.
```sh
root@mail:~# pkg install -y opendkim
# create a directory for the domain you configure DKIM for
root@mail:~# mkdir -p /usr/local/etc/mail/keys/belajarfreebsd.or.id
# generate a key pair
# -D (directory in which to store keys)
# -d (domain name)
# -s (selector name) ⇒ any name you like
root@mail:~# opendkim-genkey -D /usr/local/etc/mail/keys/belajarfreebsd.or.id -d belajarfreebsd.or.id -s $(date "+%Y%m")
root@mail:~# chown -R mailnull:mailnull /usr/local/etc/mail/keys/belajarfreebsd.or.id
root@mail:~# ls -l /usr/local/etc/mail/keys/belajarfreebsd.or.id
total 9
-rw-------  1 mailnull mailnull 920 Jul 18 14:22 202407.private
-rw-------  1 mailnull mailnull 311 Jul 18 14:22 202407.txt

root@mail:~# mv /usr/local/etc/mail/opendkim.conf /usr/local/etc/mail/opendkim.conf.org
root@mail:~# vi /usr/local/etc/mail/opendkim.conf
# create new file
# Mode : s = sign
# Mode : v = verify
Mode                    sv
Socket                  inet:8891@localhost
Syslog                  Yes
# name server where public key is registered
# to specify multiple entries, separate them with commas
Nameservers             10.0.0.30
KeyTable                /usr/local/etc/mail/keys/KeyTable
SigningTable            refile:/usr/local/etc/mail/keys/SigningTable
ExternalIgnoreList      refile:/usr/local/etc/mail/keys/TrustedHosts
InternalHosts           refile:/usr/local/etc/mail/keys/TrustedHosts

root@mail:~# vi /usr/local/etc/mail/keys/KeyTable
# create new file
#
# (selector name)._domainkey.(domain name) (domain name):(selector name):(Private Key Path)
#
# if you are handling multiple domains, enter them in the same way

202407._domainkey.belajarfreebsd.or.id belajarfreebsd.or.id:202407:/usr/local/etc/mail/keys/belajarfreebsd.or.id/202407.private

root@mail:~# vi /usr/local/etc/mail/keys/SigningTable
# create new file
#
# *@(domain name) (selector name)._domainkey.(domain name)
#
# if you are handling multiple domains, enter them in the same way

*@belajarfreebsd.or.id 202407._domainkey.belajarfreebsd.or.id

root@mail:~# vi /usr/local/etc/mail/keys/TrustedHosts
# create new file
# add trusted hosts
127.0.0.1
::1

root@mail:~# chown mailnull:mailnull /usr/local/etc/mail/keys/KeyTable \
/usr/local/etc/mail/keys/SigningTable \
/usr/local/etc/mail/keys/TrustedHosts
root@mail:~# chmod 600 /usr/local/etc/mail/keys/KeyTable \
/usr/local/etc/mail/keys/SigningTable \
/usr/local/etc/mail/keys/TrustedHosts
root@mail:~# service milter-opendkim enable
milteropendkim enabled in /etc/rc.conf
root@mail:~# service milter-opendkim start
Starting milteropendkim.
```
[2]	Configure Postfix.
```sh
root@mail:~# vi /usr/local/etc/postfix/main.cf
# add to last line
smtpd_milters = inet:127.0.0.1:8891
non_smtpd_milters = $smtpd_milters
milter_default_action = accept

root@mail:~# pw groupmod mailnull -m postfix
root@mail:~# service postfix reload
```
[3]	Verify the public key for the DNS server registration.
```sh
# public key contents
root@mail:~# cat /usr/local/etc/mail/keys/belajarfreebsd.or.id/202407.txt
202407._domainkey       IN      TXT     ( "v=DKIM1; k=rsa; "
          "p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDFeK91Tel9nVcbMfltqWJNIm907AcXBVm/kf+zFE5LDES5wjJTdOB2CEaIuyvLq3xUzVb6FXnEjJBOOy9uAvBABe6dI96DEilFZB8U7LubRmIz4LZ+bTEffp4+ma+txtdjLYA1kdRO6KYFtxDK96aK/P1rJEm6IVnHL+JaBMs5OQIDAQAB" )  ; ----- DKIM key 202407 for belajarfreebsd.or.id

# the entry in the zone file should be on one line, excluding unnecessary characters
root@mail:~# sed "s/^\t *//g" /usr/local/etc/mail/keys/belajarfreebsd.or.id/202407.txt | perl -pe 's/\n//g' | sed "s/( //g" | cut -d')' -f1
202407._domainkey       IN      TXT     "v=DKIM1; k=rsa; ""p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDFeK91Tel9nVcbMfltqWJNIm907AcXBVm/kf+zFE5LDES5wjJTdOB2CEaIuyvLq3xUzVb6FXnEjJBOOy9uAvBABe6dI96DEilFZB8U7LubRmIz4LZ+bTEffp4+ma+txtdjLYA1kdRO6KYFtxDK96aK/P1rJEm6IVnHL+JaBMs5OQIDAQAB"
```
[4]	Register the public key on the DNS server.
It will use the example of registering to a BIND zone file.
```sh
root@dns:~ # vi /usr/local/etc/namedb/primary/belajarfreebsd.or.id.wan
.....
.....
# add to last line
202407._domainkey       IN      TXT     "v=DKIM1; k=rsa; ""p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDFeK91Tel9nVcbMfltqWJNIm907AcXBVm/kf+zFE5LDES5wjJTdOB2CEaIuyvLq3xUzVb6FXnEjJBOOy9uAvBABe6dI96DEilFZB8U7LubRmIz4LZ+bTEffp4+ma+txtdjLYA1kdRO6KYFtxDK96aK/P1rJEm6IVnHL+JaBMs5OQIDAQAB"

root@dns:~ # rndc reload
```
[5]	Check on the mail server side.
```sh
root@mail:~# dig 202407._domainkey.belajarfreebsd.or.id. txt

.....
.....

# if the response matches what you registered, that's OK
;; ANSWER SECTION:
202407._domainkey.belajarfreebsd.or.id. 86400 IN   TXT     "v=DKIM1; k=rsa; " "p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDFeK91Tel9nVcbMfltqWJNIm907AcXBVm/kf+zFE5LDES5wjJTdOB2CEaIuyvLq3xUzVb6FXnEjJBOOy9uAvBABe6dI96DEilFZB8U7LubRmIz4LZ+bTEffp4+ma+txtdjLYA1kdRO6KYFtxDK96aK/P1rJEm6IVnHL+JaBMs5OQIDAQAB"

.....
.....

root@mail:~# opendkim-testkey -d belajarfreebsd.or.id -s 202407 -x /usr/local/etc/mail/opendkim.conf -vvv
opendkim-testkey: checking key '202407._domainkey.belajarfreebsd.or.id'
opendkim-testkey: key not secure
opendkim-testkey: key OK
# If [key OK], that's OK
# * [key not secure] is a message about DNSSEC
```
[6]	Finally, send an email to Gmail and if the header of the received email shows [DKIM: 'PASS' (Domain: belajarfreebsd.or.id)], then everything is OK.