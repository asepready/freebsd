OpenLDAP : Configure LDAP Server
 	
Configure LDAP Server in order to share users' accounts in your local networks.

[1]	Install OpenLDAP.
```sh
root@belajarfreebsd:~# pkg install -y openldap26-server
root@belajarfreebsd:~# cp -p /usr/local/etc/openldap/slapd.conf /usr/local/etc/openldap/slapd.conf.org
root@belajarfreebsd:~# cat <<'EOF' > /usr/local/etc/openldap/slapd.conf
pidfile /var/run/openldap/slapd.pid
argsfile /var/run/openldap/slapd.args
EOF
root@belajarfreebsd:~# mkdir /usr/local/etc/openldap/slapd.d
root@belajarfreebsd:~# slaptest -f /usr/local/etc/openldap/slapd.conf -F /usr/local/etc/openldap/slapd.d
config file testing succeeded
root@belajarfreebsd:~# vi /usr/local/etc/openldap/slapd.d/cn=config/olcDatabase\={0}config.ldif
# line 2 : remove the line
# CRC32 e5d2e79e

# line 5 : change
olcAccess: {0}to * by dn.exact=gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth manage by * break

root@belajarfreebsd:~# vi /usr/local/etc/openldap/slapd.d/cn=config/olcDatabase\={1}monitor.ldif
# create new
dn: olcDatabase={1}monitor
objectClass: olcDatabaseConfig
olcDatabase: {1}monitor
olcAccess: {0}to * by dn.exact=gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth manage by * break
olcAddContentAcl: FALSE
olcLastMod: TRUE
olcMaxDerefDepth: 15
olcReadOnly: FALSE
olcMonitoring: FALSE
structuralObjectClass: olcDatabaseConfig
creatorsName: cn=config
modifiersName: cn=config

root@belajarfreebsd:~# chown -R ldap:ldap /usr/local/etc/openldap/slapd.d
root@belajarfreebsd:~# chmod -R 700 /usr/local/etc/openldap/slapd.d
root@belajarfreebsd:~# vi /etc/rc.conf
# add to last line
slapd_enable="YES"
slapd_flags='-h "ldapi://%2fvar%2frun%2fopenldap%2fldapi/ ldap:///"'
slapd_sockets="/var/run/openldap/ldapi"

root@belajarfreebsd:~# vi /usr/local/etc/rc.d/slapd
# line 213 : comment out and add the line
#/usr/local/sbin/slapcat | ${compress_program} > ${backup_file}
/usr/local/sbin/slapcat -n 2 | ${compress_program} > ${backup_file}

root@belajarfreebsd:~# service slapd start
Performing sanity check on slap configuration: OK
Starting slapd.
```
[2]	Set OpenLDAP admin password.
```sh
# generate encrypted password
root@belajarfreebsd:~# slappasswd
New password:
Re-enter new password:
{SSHA}xxxxxxxxxxxxxxxxxxxxxxxx
root@belajarfreebsd:~# vi chrootpw.ldif
# specify the password generated above for [olcRootPW] section
dn: olcDatabase={0}config,cn=config
changetype: modify
add: olcRootPW
olcRootPW: {SSHA}xxxxxxxxxxxxxxxxxxxxxxxx

root@belajarfreebsd:~# ldapadd -Y EXTERNAL -H ldapi:/// -f chrootpw.ldif
SASL/EXTERNAL authentication started
SASL username: gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth
SASL SSF: 0
modifying entry "olcDatabase={0}config,cn=config"
```
[3]	Import basic Schemas.
```sh
root@belajarfreebsd:~# ldapadd -Y EXTERNAL -H ldapi:/// -f /usr/local/etc/openldap/schema/core.ldif
SASL/EXTERNAL authentication started
SASL username: gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth
SASL SSF: 0
adding new entry "cn=core,cn=schema,cn=config"

root@belajarfreebsd:~# ldapadd -Y EXTERNAL -H ldapi:/// -f /usr/local/etc/openldap/schema/cosine.ldif
SASL/EXTERNAL authentication started
SASL username: gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth
SASL SSF: 0
adding new entry "cn=cosine,cn=schema,cn=config"

root@belajarfreebsd:~# ldapadd -Y EXTERNAL -H ldapi:/// -f /usr/local/etc/openldap/schema/nis.ldif
SASL/EXTERNAL authentication started
SASL username: gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth
SASL SSF: 0
adding new entry "cn=nis,cn=schema,cn=config"

root@belajarfreebsd:~# ldapadd -Y EXTERNAL -H ldapi:/// -f /usr/local/etc/openldap/schema/inetorgperson.ldif
SASL/EXTERNAL authentication started
SASL username: gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth
SASL SSF: 0
adding new entry "cn=inetorgperson,cn=schema,cn=config"
```
[4]	Set your domain name on LDAP DB.
```sh
# generate directory manager password
root@belajarfreebsd:~# slappasswd
New password:
Re-enter new password:
{SSHA}xxxxxxxxxxxxxxxxxxxxxxxx
root@belajarfreebsd:~# vi backend.ldif
# create new
# replace to your domain suffix for [dc=***,dc=***] section
# specify the password generated above for [olcRootPW] section
dn: cn=module,cn=config
objectClass: olcModuleList
cn: module
olcModulepath: /usr/local/libexec/openldap
olcModuleload: back_mdb

dn: olcDatabase={2}mdb,cn=config
objectClass: olcDatabaseConfig
objectClass: olcMdbConfig
olcDatabase: {2}mdb
olcSuffix: dc=srv,dc=world
olcDbDirectory: /var/db/openldap-data
olcRootDN: cn=Manager,dc=srv,dc=world
olcRootPW: {SSHA}KWZUYIvvcGaIahQX7yLdo0Cw8B6sl5DJ
olcDbIndex: objectClass eq
olcLastMod: TRUE
olcMonitoring: TRUE
olcDbCheckpoint: 512 30
olcAccess: {0}to attrs=userPassword,shadowLastChange by
  dn="cn=Manager,dc=srv,dc=world" write by anonymous auth by self write by * none
olcAccess: {1}to dn.base="" by * read
olcAccess: {2}to * by dn="cn=Manager,dc=srv,dc=world" write by * read

root@belajarfreebsd:~# ldapadd -Y EXTERNAL -H ldapi:/// -f backend.ldif
SASL/EXTERNAL authentication started
SASL username: gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth
SASL SSF: 0
adding new entry "cn=module,cn=config"

adding new entry "olcDatabase={2}mdb,cn=config"

root@belajarfreebsd:~# vi basedomain.ldif
# create new
# replace to your domain suffix for [dc=***,dc=***] section
dn: dc=srv,dc=world
objectClass: top
objectClass: dcObject
objectclass: organization
o: Server World
dc: srv

dn: cn=Manager,dc=srv,dc=world
objectClass: organizationalRole
cn: Manager
description: Directory Manager

dn: ou=people,dc=srv,dc=world
objectClass: organizationalUnit
ou: people

dn: ou=groups,dc=srv,dc=world
objectClass: organizationalUnit
ou: groups

root@belajarfreebsd:~# ldapadd -x -D cn=Manager,dc=srv,dc=world -W -f basedomain.ldif
Enter LDAP Password:     # directory manager password you set above
adding new entry "dc=srv,dc=world"

adding new entry "cn=Manager,dc=srv,dc=world"

adding new entry "ou=people,dc=srv,dc=world"

adding new entry "ou=groups,dc=srv,dc=world"
```