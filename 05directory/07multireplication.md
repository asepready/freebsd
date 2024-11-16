OpenLDAP : Multi-Master Replication2024/04/18
 	
Configure OpenLDAP Multi-Master Replication. For the Settings of Provider/Consumer, it's impossible to add data on Consumer server, however, on Multi-Master Settings, it's possible to add on any Master server.

[1]	Configure Basic LDAP Server settings on all server, refer to here.

[2]	Configure like follows on all servers. For only the parameters [olcServerID] and [provider=***], set different value on each server.
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

root@belajarfreebsd:~# vi master01.ldif
# create new
dn: cn=config
changetype: modify
replace: olcServerID
# specify unique ID number on each server
olcServerID: 101

dn: olcDatabase={2}mdb,cn=config
changetype: modify
add: olcSyncRepl
olcSyncRepl: rid=001
  # specify another LDAP server's URI
  provider=ldap://node02.srv.world:389/
  bindmethod=simple
  # your domain name
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
-
add: olcMirrorMode
olcMirrorMode: TRUE

root@belajarfreebsd:~# ldapmodify -Y EXTERNAL -H ldapi:/// -f master01.ldif
SASL/EXTERNAL authentication started
SASL username: gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth
SASL SSF: 0
modifying entry "cn=config"

modifying entry "olcDatabase={2}mdb,cn=config"
```
[3]	Configure LDAP Client to bind all LDAP server.
```sh
# for the case of nslcd
root@client:~# vi /usr/local/etc/nslcd.conf
# line 19 : add new consumer server URI
uri ldap://dlp.srv.world/
uri ldap://node02.srv.world/
root@client:~# service nslcd restart
# for the case of sssd
root@client:~# vi /usr/local/etc/sssd/sssd.conf
# add consumer
ldap_uri = ldap://dlp.srv.world/,ldap://node02.srv.world/
root@client:~# service sssd restart
```