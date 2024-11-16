OpenLDAP : Replication
 	
Configure OpenLDAP Replication to continue Directory service if OpenLDAP master server would be down. OpenLDAP master server is called [Provider] and OpenLDAP replication server is called [Consumer] on OpenLDAP.

[1]	Configure Basic LDAP Server settings on both Provider and Consumer, refer to here.

[2]	Configure LDAP Provider.
```sh
root@belajarfreebsd:~# vi syncprov.ldif
# create new
dn: olcOverlay=syncprov,olcDatabase={2}mdb,cn=config
objectClass: olcOverlayConfig
objectClass: olcSyncProvConfig
olcOverlay: syncprov
olcSpSessionLog: 100

root@belajarfreebsd:~# ldapadd -Y EXTERNAL -H ldapi:/// -f syncprov.ldif
SASL/EXTERNAL authentication started
SASL username: gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth
SASL SSF: 0
adding new entry "olcOverlay=syncprov,olcDatabase={2}mdb,cn=config"
```
[3]	Configure LDAP Consumer.
```sh
root@node01:~ # vi syncrepl.ldif
# create new
dn: olcDatabase={2}mdb,cn=config
changetype: modify
add: olcSyncRepl
olcSyncRepl: rid=001
  # LDAP server's URI
  provider=ldap://dlp.srv.world:389/
  bindmethod=simple
  # your domain name and admin suffix
  binddn="cn=Manager,dc=srv,dc=world"
  # directory manager password
  credentials=password
  searchbase="dc=srv,dc=world"
  # includes subtree
  scope=sub
  schemachecking=on
  type=refreshAndPersist
  # [retry interval] [retry times] [interval of re-retry] [re-retry times]
  retry="30 5 300 3"
  # replication interval
  interval=00:00:05:00

root@node01:~ # ldapadd -Y EXTERNAL -H ldapi:/// -f syncrepl.ldif
SASL/EXTERNAL authentication started
SASL username: gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth
SASL SSF: 0
modifying entry "olcDatabase={2}mdb,cn=config"

# verify settings to search data
root@node01:~ # ldapsearch -x -b 'ou=people,dc=srv,dc=world'
# extended LDIF
#
# LDAPv3
# base <ou=people,dc=srv,dc=world> with scope subtree
# filter: (objectclass=*)
# requesting: ALL
#

# people, srv.world
dn: ou=people,dc=srv,dc=world
objectClass: organizationalUnit
ou: people

# netbsd, people, srv.world
dn: uid=netbsd,ou=people,dc=srv,dc=world
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
.....
.....
```
[4]	Configure LDAP Client to bind LDAP Consumer, too.
```sh
# for the case of nslcd
root@client:~ # vi /usr/local/etc/nslcd.conf
# line 19 : add new consumer server URI
uri ldap://dlp.srv.world/
uri ldap://node01.srv.world/
root@client:~ # service nslcd restart
# for the case of sssd
root@client:~ # vi /usr/local/etc/sssd/sssd.conf
# add consumer
ldap_uri = ldap://dlp.srv.world/,ldap://node01.srv.world/
root@client:~ # service sssd restart
```