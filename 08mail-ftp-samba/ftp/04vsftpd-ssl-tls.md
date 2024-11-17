FTP : Vsftpd Over SSL/TLS

Configure Vsftpd to use SSL/TLS.

[1]	Create self-signed certificates.
However. if you use valid certificates like from Let's Encrypt or others, you don't need to create this one.
```sh
root@www:~# mkdir /usr/local/etc/ssl
root@www:~# cd /usr/local/etc/ssl
root@www:/usr/local/etc/ssl # openssl req -x509 -nodes -newkey rsa:2048 -keyout vsftpd.pem -out vsftpd.pem -days 3650
Generating a RSA private key
.........+++++
.......+++++
writing new private key to 'vsftpd.pem'
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
Email Address []:root@belajarfreebsd.or.id                                 # admin's email

root@www:/usr/local/etc/ssl # chmod 600 vsftpd.pem
```
[2]	Configure Vsftpd.
```sh
root@www:~# vi /usr/local/etc/vsftpd.conf
# add to last line
rsa_cert_file=/usr/local/etc/ssl/vsftpd.pem
rsa_private_key_file=/usr/local/etc/ssl/vsftpd.pem
ssl_enable=YES
ssl_ciphers=HIGH
force_local_data_ssl=YES
force_local_logins_ssl=YES

# if firewall service is running on the system, 
# fix passv ports and allow them on firewall service
pasv_enable=YES
pasv_min_port=60000
pasv_max_port=60100

root@www:~# service vsftpd restart
FTP Client : FreeBSD
 	
Configure FTP Client to use FTPS connection.
```
[3]	Install FTP Client on FreeBSD and configure like follows.
```sh
sysadmin@client:~ $ vi ~/.lftprc
# create new
set ftp:ssl-auth TLS
set ftp:ssl-force true
set ftp:ssl-protect-list yes
set ftp:ssl-protect-data yes
set ftp:ssl-protect-fxp yes
set ssl:verify-certificate no
sysadmin@client:~ $ lftp -u sysadmin www.belajarfreebsd.or.id
Password:
lftp sysadmin@www.belajarfreebsd.or.id:~>
FTP Client : Windows
```
[4]	For example of FileZilla on Windows, Open [File] - [Site Manager].

[5]	Input connection information like follows, and for encryption field, select [Require explicit FTP over TLS].

[6]	If you set self-signed certificate, following warning is shown, it's no problem. Go next.

[7]	If settings are OK, it's possible to connect to FTP server with FTPS like follows.
