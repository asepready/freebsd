OpenLDAP : LDAP over SSL/TLS
 	
Configure LDAP over SSL/TLS to use secure encrypted connection.

[1]	
On this example, create and use self-signed certificates like here.

[2]	Configure LDAP Server.
```sh
root@dlp:~ # mkdir /usr/local/etc/openldap/certs.d
root@dlp:~ # cp /usr/local/etc/ssl/server.key \
/usr/local/etc/ssl/server.crt \
/usr/local/etc/openldap/certs.d/
root@dlp:~ # chown -R ldap:ldap /usr/local/etc/openldap/certs.d
root@dlp:~ # vi mod_ssl.ldif
# create new
dn: cn=config
changetype: modify
replace: olcTLSCertificateFile
olcTLSCertificateFile: /usr/local/etc/openldap/certs.d/server.crt
-
replace: olcTLSCertificateKeyFile
olcTLSCertificateKeyFile: /usr/local/etc/openldap/certs.d/server.key

root@dlp:~ # ldapmodify -Y EXTERNAL -H ldapi:/// -f mod_ssl.ldif
SASL/EXTERNAL authentication started
SASL username: gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth
SASL SSF: 0
modifying entry "cn=config"

root@dlp:~ # service slapd restart
```
[3]	Configure LDAP Client.
If you'd like to make sure the connection between LDAP server and client is encrypted, use tcpdump or other network capture softwares on LDAP server.
```sh
root@node01:~ # vi /usr/local/etc/nslcd.conf
# line 64 : add
ssl start_tls
tls_reqcert allow
root@node01:~ # service nslcd restart
root@node01:~ # exit
node01 login: freebsd    # LDAP user
Password:
Last login: Thu Apr 18 12:49:40 from 10.0.0.232
FreeBSD 14.0-RELEASE (GENERIC) #0 releng/14.0-n265380-f9716eee8ab4: Fri Nov 10 05:57:23 UTC 2023

Welcome to FreeBSD!

.....
.....

freebsd@node01:~ $
```