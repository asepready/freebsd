Initial Settings : Set Command Alias
 	
Set Command Alias for some commands that are often used.
[1]	Apply to all users as defaults.
```sh
root@hosts:~# ee /etc/profile.d/command_alias.sh
# create new file
# add alias you like to set
alias ll='ls -laFo'
alias l='ls -l'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
# load values
root@hosts:~# ee/etc/profile.d/command_alias.sh
```
[2]	Apply to a user.
For example, user [sysadmin] sets alias for itself.
```sh
sysadmin@hosts:~$ vi ~/.shrc
# add to the end : add alias you like to set
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
sysadmin@hosts:~$ . ~/.shrc