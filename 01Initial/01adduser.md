Initial Settings : Add User Accounts
 	
If you want to add new user accounts, configure like follows.
[1]	For example, Add [sysadmin] user.
```sh
root@belajarfreebsd:~# pw add user -n sysadmin -m -s /bin/sh -c "System Administrator"
# set password
root@belajarfreebsd:~# passwd sysadmin
Changing local password for sysadmin
New Password:
Retype New Password:
```
[2]	If you want common users to be able to switch to root account by using [su] command, add them to the [wheel] group.
```sh
# add [sysadmin] user to [wheel] group
root@belajarfreebsd:~# pw groupmod wheel -m sysadmin
```
[3]	If you want to remove user accounts, configure like follows.
```sh
# remove a user [sysadmin] (only removed user account)
root@belajarfreebsd:~# pw userdel sysadmin
# remove a user [sysadmin] (removed user account and his home directory)
root@belajarfreebsd:~# pw userdel sysadmin -r
```