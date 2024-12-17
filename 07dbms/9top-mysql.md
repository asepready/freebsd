Top 9 Tips to Secure MySQL and MariaDB Databases.
1 Secure MySQL/MariaDB Installation
```sh
mysql_secure_installation

You will be asked to set a root password, remove the test database and anonymous user and disable root login remotely, as shown below:
Enter current password for root (enter for none): 
Provide your root user password Switch to unix_socket authentication [Y/n] n 
Change the root password? [Y/n] Y 
New password: 
Re-enter new password: 
Remove anonymous users? [Y/n] Y 
Disallow root login remotely? [Y/n] Y 
Remove test database and access to it? [Y/n] Y 
Reload privilege tables now? [Y/n] Y
```

2 Change MySQL Default Port and Listening Address
```sh
bind-address = 127.0.0.1
Port = 9090 #3306
```

3 Disable LOCAL INFILE
```sh
local-infile=0
```

4 Enable MySQL Logging
```sh
log_error = /var/log/mysql/error.log
```

5 Secure MySQL/MariaDB Connection with SSL/TLS
It is also recommended to secure your MySQL/MariaDB connection with SSL/TLS.

6 Remove the MySQL History File
rm -rf ~/.mysql_history

7 Change MySQL Passwords Regularly
```sh
mysql -u root -p
USE mysql;
ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY 'yourpassword';
FLUSH PRIVILEGES; EXIT;
```

8 Update MySQL/MariaDB Package Regularly

9 Rename MySQL Root User
```sh
mysql -u root -p
rename user 'root'@'localhost' to 'admin'@'localhost';
select user,host from mysql.user;
FLUSH PRIVILEGES; EXIT;
mysql -u admin -p
```