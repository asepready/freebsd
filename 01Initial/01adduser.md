Initial Settings : Add User Accounts
 	
If you want to add new user accounts, configure like follows.
[1]	For example, Add [sysadmin] user.
```sh
root@hosts:~# pw useradd sysadmin -m
# set password
root@hosts:~# passwd sysadmin
Changing local password for sysadmin
New Password:
Retype New Password:
```
[2]	If you want common users to be able to switch to root account by using [su] command, add them to the [wheel] group.
```sh
# add [sysadmin] user to [wheel] group
root@hosts:~# pw groupmod wheel -m sysadmin
```
[3]	If you want to remove user accounts, configure like follows.
```sh
# remove a user [sysadmin] (only removed user account)
root@hosts:~# pw userdel sysadmin
# remove a user [sysadmin] (removed user account and his home directory)
root@hosts:~# pw userdel sysadmin -r
```