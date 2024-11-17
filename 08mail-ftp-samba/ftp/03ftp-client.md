FTP : FTP Client (FreeBSD)

Configure Client computer to connect to FTP Server. The example below is for FreeBSD.

[1]	Install FTP Client.
```sh
root@client:~# pkg install -y lftp
```
[2]	Connect to FTP Server as any common users.
```sh
# lftp [option] [hostname]
sysadmin@client:~$ lftp -u sysadmin www.belajarfreebsd.or.id
Password:   # password of the user
lftp sysadmin@www.belajarfreebsd.or.id:~>

# show current directory on FTP server
lftp sysadmin@www.belajarfreebsd.or.id:~> pwd
ftp://sysadmin@www.belajarfreebsd.or.id

# show current directory on localhost
lftp sysadmin@www.belajarfreebsd.or.id:~> !pwd
/home/freebsd

# show files in current directory on FTP server
lftp sysadmin@www.belajarfreebsd.or.id:~> ls -la
drwxr-xr-x    3 1002     1002           11 Feb 15 01:50 .
drwxr-xr-x    4 0        0               4 Dec 19 00:44 ..
-rw-r--r--    1 1002     1002          950 Dec 19 00:44 .cshrc
-rw-r--r--    1 1002     1002          311 Dec 19 00:44 .login
-rw-r--r--    1 1002     1002           79 Dec 19 00:44 .login_conf
-rw-------    1 1002     1002          289 Dec 19 00:44 .mail_aliases
-rw-r--r--    1 1002     1002          255 Dec 19 00:44 .mailrc
-rw-r--r--    1 1002     1002          966 Dec 19 00:44 .profile
-rw-------    1 1002     1002           79 Feb 15 01:50 .sh_history
-rw-r--r--    1 1002     1002         1003 Dec 19 00:44 .shrc
drwxr-xr-x    2 1002     1002            2 Feb 15 01:50 public_html

# show files in current directory on localhost
lftp sysadmin@www.belajarfreebsd.or.id:~> !ls -l
total 10
-rw-r--r--  1 freebsd freebsd 4393 Feb 15 12:43 test.txt
drwxr-xr-x  2 freebsd freebsd    2 Feb 15 12:43 testdir
-rw-r--r--  1 freebsd freebsd  125 Feb 15 12:44 testfile.txt

# change directory
lftp sysadmin@www.belajarfreebsd.or.id:~> cd public_html
lftp sysadmin@www.belajarfreebsd.or.id:~/public_html> pwd
ftp://sysadmin@www.belajarfreebsd.or.id/%2Fhome/freebsd/public_html

# upload a file to FTP server
lftp sysadmin@www.belajarfreebsd.or.id:~> put test.txt
4393 bytes transferred
lftp sysadmin@www.belajarfreebsd.or.id:~> ls -la
drwxr-xr-x    2 1002     1002            3 Feb 15 03:45 .
drwxr-xr-x    3 1002     1002           11 Feb 15 01:50 ..
-rw-------    1 1002     1002         4393 Feb 15 03:45 test.txt

# upload some files to FTP server
lftp sysadmin@www.belajarfreebsd.or.id:~> mput test.txt testfile.txt
4518 bytes transferred
Total 2 files transferred
lftp sysadmin@www.belajarfreebsd.or.id:~> ls
-rw-------    1 1002     1002         4393 Feb 15 03:46 test.txt
-rw-------    1 1002     1002          125 Feb 15 03:46 testfile.txt

# set permission to overwrite files on localhost when using [get/mget]
lftp sysadmin@www.belajarfreebsd.or.id:~> set xfer:clobber on

# download a file from FTP server
lftp sysadmin@www.belajarfreebsd.or.id:~> get test.txt
4393 bytes transferred

# download some files from FTP server
lftp sysadmin@www.belajarfreebsd.or.id:~> mget test.txt testfile.txt
4518 bytes transferred
Total 2 files transferred

# create a directory in current directory on FTP Server
lftp sysadmin@www.belajarfreebsd.or.id:~> mkdir testdir
mkdir ok, `testdir' created
lftp sysadmin@www.belajarfreebsd.or.id:~> ls
-rw-------    1 1002     1002         4393 Feb 15 03:46 test.txt
drwx------    2 1002     1002            2 Feb 15 03:47 testdir
-rw-------    1 1002     1002          125 Feb 15 03:46 testfile.txt

# delete a directory in current directory on FTP Server
lftp sysadmin@www.belajarfreebsd.or.id:~> rmdir testdir
rmdir ok, `testdir' removed
lftp sysadmin@www.belajarfreebsd.or.id:~> ls
-rw-------    1 1002     1002         4393 Feb 15 03:46 test.txt
-rw-------    1 1002     1002          125 Feb 15 03:46 testfile.txt

# delete a file in current directory on FTP Server
lftp sysadmin@www.belajarfreebsd.or.id:~> rm testfile.txt
rm ok, `testfile.txt' removed
lftp sysadmin@www.belajarfreebsd.or.id:~> ls
-rw-------    1 1002     1002         4393 Feb 15 03:46 test.txt

# delete some files in current directory on FTP Server
lftp sysadmin@www.belajarfreebsd.or.id:~> mrm test.txt testfile.txt
rm ok, 2 files removed
lftp sysadmin@www.belajarfreebsd.or.id:~> ls -la
drwxr-xr-x    2 1002     1002            2 Feb 15 03:48 .
drwxr-xr-x    3 1002     1002           11 Feb 15 01:50 ..

# execute commands with ![command]
lftp sysadmin@www.belajarfreebsd.or.id:~> !cat /etc/passwd
root:*:0:0:Charlie &:/root:/bin/sh
toor:*:0:0:Bourne-again Superuser:/root:
daemon:*:1:1:Owner of many system processes:/root:/usr/sbin/nologin
operator:*:2:5:System &:/:/usr/sbin/nologin
bin:*:3:7:Binaries Commands and Source:/:/usr/sbin/nologin
.....
.....

# exit
lftp sysadmin@www.belajarfreebsd.or.id:~> quit
```

FTP : FTP Client (Windows)
 	
Configure Client computer to connect to FTP Server. The example below is for Windows.
[1]	For example, use FileZilla for FTP Client software. Download FileZilla from the follows. ⇒ https://filezilla-project.org/download.php?type=client

[2]	Install FileZilla to your Windows PC and start it, then following screen is shown.
Input your FTP's Hostname, user-name. password, connection-port, like follows. Next Click [Connect].

[3]	Warning is shown if FTP server is not configured with SSL/TLS. If you setup it, refer to [FTP over SSL/TLS] section.

[4]	After successful authentication, you can connect to the FTP server and it's possible to transfer files on it.
