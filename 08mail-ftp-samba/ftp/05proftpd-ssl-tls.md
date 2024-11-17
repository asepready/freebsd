FTP : ProFTPD Over SSL/TLS
 	
Configure ProFTPD to use SSL/TLS.

[1]	Create self-signed certificates.
However. if you use valid certificates like from Let's Encrypt or others, you don't need to create this one.
```sh
root@www:~# mkdir /usr/local/etc/ssl
root@www:~# cd /usr/local/etc/ssl
root@www:/usr/local/etc/ssl # openssl req -x509 -nodes -newkey rsa:2048 -keyout proftpd.pem -out proftpd.pem -days 3650
Generating a RSA private key
.........+++++
.......+++++
writing new private key to 'proftpd.pem'
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:ID                            # country code
State or Province Name (full name) [Some-State]:Bangka Belitung     # State
Locality Name (eg, city) []:Pangkalpinang                           # city
Organization Name (eg, company) [Internet Widgits Pty Ltd]:EDU  # company
Organizational Unit Name (eg, section) []:Belajar FreeBSD          # department
Common Name (e.g. server FQDN or YOUR name) []:www.belajarfreebsd.or.id    # server's FQDN
Email Address []:root@belajarfreebsd.or.id                                  # admin's email

root@www:/usr/local/etc/ssl # chmod 600 proftpd.pem
```
[2]	Configure ProFTPD.
```sh
root@www:~# vi /usr/local/etc/proftpd.conf
# add to last line
LoadModule mod_tls.c
<IfModule mod_tls.c>
  TLSEngine                     on
  TLSRequired                   on
  TLSRSACertificateFile         /usr/local/etc/ssl/proftpd.pem
  TLSRSACertificateKeyFile      /usr/local/etc/ssl/proftpd.pem
  TLSOptions                    NoSessionReuseRequired
  TLSLog                        /var/log/proftpd.log
</IfModule>

# if firewall service is running on the system, 
# fix passv ports and allow them on firewall service
PassivePorts                    60000 60100

root@www:~# service proftpd restart
FTP Client : FreeBSD
 	
Configure FTP Client to use FTPS connection.
```
[3]	Install FTP Client on FreeBSD and configure like follows.
```sh
freebsd@client:~$ vi ~/.lftprc
# create new
set ftp:ssl-auth TLS
set ftp:ssl-force true
set ftp:ssl-protect-list yes
set ftp:ssl-protect-data yes
set ftp:ssl-protect-fxp yes
set ssl:verify-certificate no
freebsd@client:~$ lftp -u freebsd www.belajarfreebsd.or.id
Password:
lftp freebsd@www.belajarfreebsd.or.id:~>
FTP Client : Windows
```
[4]	For example of FileZilla on Windows, Open [File] - [Site Manager].

[5]	Input connection information like follows, and for encryption field, select [Require explicit FTP over TLS].

[6]	If you set self-signed certificate, following warning is shown, it's no problem. Go next.

[7]	If settings are OK, it's possible to connect to FTP server with FTPS like follows.
