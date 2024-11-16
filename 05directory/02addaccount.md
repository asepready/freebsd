OpenLDAP : Add User Accounts
 	
Add LDAP User accounts to the OpenLDAP Server.

[1]	Add a User Account.
```sh
# generate encrypted password
root@belajarfreebsd:~# slappasswd
New password:
Re-enter new password:
{SSHA}xxxxxxxxxxxxxxxxx
root@belajarfreebsd:~# vi ldapuser.ldif
# create new
# replace the section [dc=***,dc=***] to your domain name
dn: uid=freebsd,ou=people,dc=srv,dc=world
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
cn: freebsd
sn: fourteen
userPassword: {SSHA}xxxxxxxxxxxxxxxxx
loginShell: /bin/sh
uidNumber: 2000
gidNumber: 2000
homeDirectory: /home/freebsd

dn: cn=freebsd,ou=groups,dc=srv,dc=world
objectClass: posixGroup
cn: freebsd
gidNumber: 2000
memberUid: freebsd

root@belajarfreebsd:~# ldapadd -x -D cn=Manager,dc=srv,dc=world -W -f ldapuser.ldif
Enter LDAP Password:
adding new entry "uid=freebsd,ou=people,dc=srv,dc=world"

adding new entry "cn=freebsd,ou=groups,dc=srv,dc=world"
```
[2]	Add users and groups in local passwd/group to LDAP directory.
```sh
root@belajarfreebsd:~# pkg install -y bash
root@belajarfreebsd:~# vi ldapuser.sh
# extract local users and groups who have [1000-9999] digit UID
# replace [SUFFIX=***] to your own domain name
# this is an example, free to modify
#!/usr/local/bin/bash

SUFFIX='dc=srv,dc=world'
LDIF='ldapuser.ldif'

echo -n > $LDIF
GROUP_IDS=()
grep "*:[1-9][0-9][0-9][0-9]:" /etc/passwd | (while read TARGET_USER
do
    USER_ID="$(echo "$TARGET_USER" | cut -d':' -f1)"

    USER_NAME="$(echo "$TARGET_USER" | cut -d':' -f5 | cut -d' ' -f1,2)"
    [ ! "$USER_NAME" ] && USER_NAME="$USER_ID"

    LDAP_SN="$(echo "$USER_NAME" | cut -d' ' -f2)"
    [ ! "$LDAP_SN" ] && LDAP_SN="$USER_NAME"

    GROUP_ID="$(echo "$TARGET_USER" | cut -d':' -f4)"
    [ ! "$(echo "${GROUP_IDS[@]}" | grep "$GROUP_ID")" ] && GROUP_IDS=("${GROUP_IDS[@]}" "$GROUP_ID")

    echo "dn: uid=$USER_ID,ou=people,$SUFFIX" >> $LDIF
    echo "objectClass: inetOrgPerson" >> $LDIF
    echo "objectClass: posixAccount" >> $LDIF
    echo "objectClass: shadowAccount" >> $LDIF
    echo "sn: $LDAP_SN" >> $LDIF
    echo "givenName: $(echo "$USER_NAME" | awk '{print $1}')" >> $LDIF
    echo "cn: $USER_NAME" >> $LDIF
    echo "displayName: $USER_NAME" >> $LDIF
    echo "uidNumber: $(echo "$TARGET_USER" | cut -d':' -f3)" >> $LDIF
    echo "gidNumber: $(echo "$TARGET_USER" | cut -d':' -f4)" >> $LDIF
    echo "userPassword: {crypt}$(grep "${USER_ID}:" /etc/master.passwd | cut -d':' -f2)" >> $LDIF
    echo "gecos: $USER_NAME" >> $LDIF
    echo "loginShell: $(echo "$TARGET_USER" | cut -d':' -f7)" >> $LDIF
    echo "homeDirectory: $(echo "$TARGET_USER" | cut -d':' -f6)" >> $LDIF
    echo >> $LDIF
done

for TARGET_GROUP_ID in "${GROUP_IDS[@]}"
do
    LDAP_CN="$(grep ":${TARGET_GROUP_ID}:" /etc/group | cut -d':' -f1)"

    echo "dn: cn=$LDAP_CN,ou=groups,$SUFFIX" >> $LDIF
    echo "objectClass: posixGroup" >> $LDIF
    echo "cn: $LDAP_CN" >> $LDIF
    echo "gidNumber: $TARGET_GROUP_ID" >> $LDIF

    for MEMBER_UID in $(grep ":${TARGET_GROUP_ID}:" /etc/passwd | cut -d':' -f1,3)
    do
        UID_NUM=$(echo "$MEMBER_UID" | cut -d':' -f2)
        [ $UID_NUM -ge 1000 -a $UID_NUM -le 9999 ] && echo "memberUid: $(echo "$MEMBER_UID" | cut -d':' -f1)" >> $LDIF
    done
    echo >> $LDIF
done
)

root@belajarfreebsd:~# bash ldapuser.sh
root@belajarfreebsd:~# ldapadd -x -D cn=Manager,dc=srv,dc=world -W -f ldapuser.ldif
Enter LDAP Password:
adding new entry "uid=openbsd,ou=people,dc=srv,dc=world"

adding new entry "uid=netbsd,ou=people,dc=srv,dc=world"

adding new entry "uid=linux,ou=people,dc=srv,dc=world"

adding new entry "cn=openbsd,ou=groups,dc=srv,dc=world"

adding new entry "cn=netbsd,ou=groups,dc=srv,dc=world"

adding new entry "cn=linux,ou=groups,dc=srv,dc=world"
```
[3]	If you'd like to delete LDAP User or Group, run like follows.
```sh
root@belajarfreebsd:~# ldapdelete -x -W -D 'cn=Manager,dc=srv,dc=world' "uid=linux,ou=people,dc=srv,dc=world"
Enter LDAP Password:
root@belajarfreebsd:~# ldapdelete -x -W -D 'cn=Manager,dc=srv,dc=world' "cn=linux,ou=groups,dc=srv,dc=world"
Enter LDAP Password:
```