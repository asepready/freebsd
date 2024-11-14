OpenSSH : SSH File Transfer (FreeBSD)
 	
It's possible to transfer files with SSH.

[1]	It's the example for using SCP (Secure Copy).
```sh
# usage ⇒ scp [Option] Source Target
# copy the [test.txt] on local to remote server [node01.srv.world]
root@belajarfreebsd:~# scp ./test.txt sysadmin@belajarfreebsd.or.id:~/
(sysadmin@belajarfreebsd.or.id) Password for sysadmin@belajarfreebsd.or.id:
test.txt                100% 1003     1.1MB/s   00:00

# copy the [/home/freebsd/test.txt] on remote server [node01.srv.world] to the local
root@belajarfreebsd:~# scp sysadmin@belajarfreebsd.or.id:/home/freebsd/test.txt ./test2.txt
(sysadmin@belajarfreebsd.or.id) Password for sysadmin@belajarfreebsd.or.id:
test.txt                100% 1003     1.1MB/s   00:00
```
[2]	It's example to use SFTP (SSH File Transfer Protocol).
SFTP server feature is enabled by default, but if not, enable it to add the line [Subsystem sftp /usr/libexec/
sftp-server] in [/etc/ssh/sshd_config].
```sh
# sftp [Option] [user@host]
root@belajarfreebsd:~# sftp sysadmin@belajarfreebsd.or.id
(sysadmin@belajarfreebsd.or.id) Password for sysadmin@belajarfreebsd.or.id:    # password of the user
Connected to node01.srv.world.
sftp>

# show current directory on remote server
sftp> pwd
Remote working directory: /home/freebsd

# show current directory on local server
sftp> !pwd
/home/freebsd

# show files in current directory on FTP server
sftp> ls -l
-rw-r--r--    ? freebsd  freebsd      1003 Dec 19 10:12 test.txt

# show files in current directory on local server
sftp> !ls -l
total 9
-rw-r--r--  1 freebsd freebsd 1003 Dec 19 10:11 test.txt
-rw-r--r--  1 freebsd freebsd 1003 Dec 19 10:14 test2.txt

# create a directory and move to it
sftp> mkdir testdir
sftp> cd testdir
sftp> pwd
Remote working directory: /home/freebsd/testdir

# upload a file to remote server
sftp> cd ../
sftp> put test.txt freebsd.txt
Uploading test.txt to /home/freebsd/freebsd.txt
test.txt           100% 1003     1.1MB/s   00:00
sftp> ls -l
-rw-r--r--    ? freebsd  freebsd      1003 Dec 19 10:21 freebsd.txt
-rw-r--r--    ? freebsd  freebsd      1003 Dec 19 10:12 test.txt
drwxr-xr-x    ? freebsd  freebsd         2 Dec 19 10:18 testdir

# upload some files to remote server
sftp> put *.txt
Uploading test.txt to /home/freebsd/test.txt
test.txt                              100% 1003     1.1MB/s   00:00
Uploading test2.txt to /home/freebsd/test2.txt
test2.txt                            100% 1003     1.2MB/s   00:00
sftp> ls -l
-rw-r--r--    ? freebsd  freebsd      1003 Dec 19 10:21 freebsd.txt
-rw-r--r--    ? freebsd  freebsd      1003 Dec 19 10:22 test.txt
-rw-r--r--    ? freebsd  freebsd      1003 Dec 19 10:22 test2.txt
drwxr-xr-x    ? freebsd  freebsd         2 Dec 19 10:18 testdir

# download a file from remote server
sftp> get test.txt
Fetching /home/freebsd/test.txt to test.txt
test.txt               100% 1003     1.1MB/s   00:00

# download some files from remote server
sftp> get *.txt
Fetching /home/freebsd/freebsd.txt to freebsd.txt
freebsd.txt                 100% 1003     1.1MB/s   00:00
Fetching /home/freebsd/test.txt to test.txt
test.txt                    100% 1003     1.1MB/s   00:00
Fetching /home/freebsd/test2.txt to test2.txt
test2.txt                   100% 1003     1.1MB/s   00:00

# delete a directory on remote server
sftp> rmdir testdir
rmdir ok, `testdir' removed
sftp> ls -l
-rw-r--r--    ? freebsd  freebsd      1003 Dec 19 10:21 freebsd.txt
-rw-r--r--    ? freebsd  freebsd      1003 Dec 19 10:22 test.txt
-rw-r--r--    ? freebsd  freebsd      1003 Dec 19 10:22 test2.txt

# delete a file on remote server
sftp> rm test2.txt
Removing /home/freebsd/test2.txt
sftp> ls -l
-rw-r--r--    ? freebsd  freebsd      1003 Dec 19 10:21 freebsd.txt
-rw-r--r--    ? freebsd  freebsd      1003 Dec 19 10:22 test.txt

# execute commands with ![command]
sftp> !cat /etc/passwd
root:*:0:0:Charlie &:/root:/bin/sh
toor:*:0:0:Bourne-again Superuser:/root:
daemon:*:1:1:Owner of many system processes:/root:/usr/sbin/nologin
operator:*:2:5:System &:/:/usr/sbin/nologin
bin:*:3:7:Binaries Commands and Source:/:/usr/sbin/nologin
.....
.....

# exit
sftp> quit
```
