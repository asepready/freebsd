OpenSSH : Use Parallel SSH
 	
Install Parallel SSH to connect to multiple hosts.

[1]	Install PSSH.
```sh
root@belajarfreebsd:~# pkg install -y pssh
```
[2]	This is the basic usage for PSSH.
This is the case for key-pair authentication without passphrase.
If passphrase is set in key-pair, start SSH-Agent first to automate inputting passphrase.
```sh
# connect to hosts and execute [hostname] command
sysadmin@belajarfreebsd:~ $ pssh -H "10.0.0.51 10.0.0.52" -i "hostname"
[1] 13:45:41 [SUCCESS] 10.0.0.52
node02.srv.world
[2] 13:45:41 [SUCCESS] 10.0.0.51
node01.srv.world
# it's possible to read host list from a file
sysadmin@belajarfreebsd:~ $ vi pssh_hosts.txt
# write hosts per line like follows
sysadmin@10.0.0.51
sysadmin@10.0.0.52
sysadmin@belajarfreebsd:~ $ pssh -h pssh_hosts.txt -i "uptime"
[1] 13:47:18 [SUCCESS] sysadmin@10.0.0.51
 1:47PM  up  4:44, 1 user, load averages: 0.25, 0.23, 0.21
[2] 13:47:18 [SUCCESS] sysadmin@10.0.0.52
 1:47PM  up 10 mins, 1 user, load averages: 0.23, 0.21, 0.15
```
[3]	It's possible to connect with password authentication too, but it needs passwords on all hosts are the same one.
```sh
sysadmin@belajarfreebsd:~ $ pssh -h pssh_hosts.txt -A -O PreferredAuthentications=password,keyboard-interactive -i "uname -r"
Warning: do not enter your password if anyone else has superuser
privileges or access to your account.
Password:   # input password
[1] 13:59:37 [SUCCESS] sysadmin@10.0.0.51
14.0-RELEASE
[2] 13:59:37 [SUCCESS] sysadmin@10.0.0.52
14.0-RELEASE
```
[4]	By the way, PSSH package includes [parallel-scp], [parallel-rsync], [parallel-slurp], [parallel-nuke] commands and you can use them with the same usage of pssh.