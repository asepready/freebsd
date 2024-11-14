OpenSSH : Use SSHPass2023/12/19
 	
Use SSHPass to automate inputting password on password authentication. This is convenient but it has security risks (leak of password), take special care if you use it.

[1]	Install SSHPass.
```sh
root@belajarfreebsd:~ # pkg install -y sshpass
```
[2]	How to use SSHPass.
```sh
# [-p password] : from argument
# if initial connection, add [StrictHostKeyChecking=no]
sysadmin@belajarfreebsd:~$ sshpass -p password ssh -o StrictHostKeyChecking=no 10.0.0.51 hostname
node01.belajarfreebsd.or.id
# [-f file] : from file
sysadmin@belajarfreebsd:~$ echo 'password' > sshpass.txt
sysadmin@belajarfreebsd:~$ chmod 600 sshpass.txt
sysadmin@belajarfreebsd:~$ sshpass -f sshpass.txt ssh 10.0.0.51 hostname
node01.belajarfreebsd.or.id
# [-e] : from environment variable
sysadmin@belajarfreebsd:~$ export SSHPASS=password
sysadmin@belajarfreebsd:~$ sshpass -e ssh 10.0.0.51 hostname
node01.belajarfreebsd.or.id
```