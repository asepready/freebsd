MariaDB 10.11 : SSL/TLS Setting
 	
Configure SSL/TLS Setting on MariaDB.

[1]	
```sh
root@dlp:~ # vi /etc/ssl/openssl.cnf
# add to the end
# section name is any name you like
# DNS:(this server's hostname)
# if you set multiple hostname or domainname, set them with comma separated
# ⇒ DNS:ns.asepready.id, DNS:www.asepready.id
[ asepready.id ]
subjectAltName = DNS:ns.asepready.id

root@dlp:~ # mkdir /usr/local/etc/ssl
root@dlp:~ # cd /usr/local/etc/ssl
root@dlp:/usr/local/etc/ssl # openssl genrsa -aes128 2048 > server.key
Enter PEM pass phrase:                  # set passphrase
Verifying - Enter PEM pass phrase:      # confirm

# remove passphrase from private key
root@dlp:/usr/local/etc/ssl # openssl rsa -in server.key -out server.key
Enter pass phrase for server.key:   # input passphrase
writing RSA key

root@dlp:/usr/local/etc/ssl # openssl req -utf8 -new -key server.key -out server.csr
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [XX]:JP                           # country code
State or Province Name (full name) []:Hiroshima                # state
Locality Name (eg, city) [Default City]:Hiroshima              # city
Organization Name (eg, company) [Default Company Ltd]:GTS      # company
Organizational Unit Name (eg, section) []:Server World         # department
Common Name (eg, your name or your server's hostname) []:ns.asepready.id  # server's FQDN
Email Address []:root@asepready.id                                # admin email address

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:

# create certificate with 10 years expiration date
# -extensions (section name) ⇒ the section name you set in [openssl.cnf]
root@dlp:/usr/local/etc/ssl # openssl x509 -in server.csr -out server.crt -req -signkey server.key -extfile /etc/ssl/openssl.cnf -extensions asepready.id -days 3650
Certificate request self-signature ok
subject=C = JP, ST = Hiroshima, L = Hiroshima, O = GTS, OU = Server World, CN = ns.asepready.id, emailAddress = root@asepready.id
root@dlp:/usr/local/etc/ssl # chmod 600 server.key
root@dlp:/usr/local/etc/ssl # ls -l server.*
-rw-r--r--  1 root wheel 1424 Dec 20 15:21 server.crt
-rw-r--r--  1 root wheel 1062 Dec 20 15:21 server.csr
-rw-------  1 root wheel 1704 Dec 20 15:20 server.key
```
[2]	Configure MariaDB.
```sh
# copy certificates
root@www:~ # mkdir /var/db/mysql/pki
root@www:~ # cp /usr/local/etc/ssl/server.* /var/db/mysql/pki/
root@www:~ # chown -R mysql:mysql /var/db/mysql/pki
root@www:~ # vi /usr/local/etc/mysql/conf.d/server.cnf
[mysqld]
ssl-cert = /var/db/mysql/pki/server.crt
ssl-key = /var/db/mysql/pki/server.key
root@www:~ # service mysql-server restart
# verify settings
root@www:~ # mysql
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 3
Server version: 10.11.6-MariaDB FreeBSD Ports

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

# OK if status is like follows
root@localhost [(none)]> show variables like '%ssl%'; 
+---------------------+------------------------------+
| Variable_name       | Value                        |
+---------------------+------------------------------+
| have_openssl        | YES                          |
| have_ssl            | YES                          |
| ssl_ca              |                              |
| ssl_capath          |                              |
| ssl_cert            | /var/db/mysql/pki/server.crt |
| ssl_cipher          |                              |
| ssl_crl             |                              |
| ssl_crlpath         |                              |
| ssl_key             | /var/db/mysql/pki/server.key |
| version_ssl_library | OpenSSL 3.0.12 24 Oct 2023   |
+---------------------+------------------------------+
10 rows in set (0.001 sec)
```
[3]	To connect with SSL/TLS from Clients, connect with specifying [ssl] option.
```sh
root@www:~ # mysql --ssl
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 4
Server version: 10.11.6-MariaDB FreeBSD Ports

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

# show status
root@localhost [(none)]> show status like 'ssl_cipher'; 
+---------------+------------------------+
| Variable_name | Value                  |
+---------------+------------------------+
| Ssl_cipher    | TLS_AES_256_GCM_SHA384 |
+---------------+------------------------+
1 row in set (0.000 sec)

root@localhost [(none)]> exit 
Bye

# on no SSL/TLS connection
root@www:~ # mysql --skip-ssl
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 5
Server version: 10.11.6-MariaDB FreeBSD Ports

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

# value is empty
root@localhost [(none)]> show status like 'ssl_cipher'; 
+---------------+-------+
| Variable_name | Value |
+---------------+-------+
| Ssl_cipher    |       |
+---------------+-------+
1 row in set (0.000 sec)
```
[4]	To force require users to connect with SSL/TLS, set like follows.
```sh
root@www:~ # mysql
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 8
Server version: 10.11.6-MariaDB FreeBSD Ports

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

# create a user who is required SSL/TLS
root@localhost [(none)]> create user netbsd identified by 'password' require ssl; 
Query OK, 0 rows affected (0.00 sec)

# SSL/TLS required users are set [ssl_type] = [ANY]
root@localhost [(none)]> select user,host,ssl_type from mysql.user; 
+-------------+-----------+----------+
| User        | Host      | ssl_type |
+-------------+-----------+----------+
| mariadb.sys | localhost |          |
| root        | localhost |          |
| mysql       | localhost |          |
| PUBLIC      |           |          |
| freebsd     | %         |          |
| netbsd      | %         | ANY      |
+-------------+-----------+----------+
6 rows in set (0.001 sec)

# set SSL/TLS required to an existing user
root@localhost [(none)]> grant usage on *.* to 'freebsd'@'%' require ssl; 
Query OK, 0 rows affected (0.00 sec)

root@localhost [(none)]> select user,host,ssl_type from mysql.user; 
+-------------+-----------+----------+
| User        | Host      | ssl_type |
+-------------+-----------+----------+
| mariadb.sys | localhost |          |
| root        | localhost |          |
| mysql       | localhost |          |
| PUBLIC      |           |          |
| freebsd     | %         | ANY      |
| netbsd      | %         | ANY      |
+-------------+-----------+----------+
6 rows in set (0.001 sec)
```