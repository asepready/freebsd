Zabbix 7.0 : Install
 	
Install Zabbix 7.0 LTS which is an enterprise open source monitoring system.

[1]	Install Apache httpd, refer to here.

[2]	Configure SSL/TLS setting, refer to here. (not required but recommended)

[3]	Install PHP-FPM, refer to here.

[4]	Install MySQL server, refer to here.

[5]	Install Zabbix server. To monitor Zabbix itself, Install Zabbix Agent, too.
```sh
root@belajarfreebsd:~# pkg install -y zabbix7-server zabbix7-frontend-php82 zabbix7-agent php82-mysqli php82-mbstring php82-gd php82-bcmath php82-curl
```
[6]	Create a database for Zabbix.
```sh
root@belajarfreebsd:~# mysql
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 8
Server version: 8.0.35 Source distribution

Copyright (c) 2000, 2023, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

root@localhost [(none)]> create database zabbix character set utf8mb4 collate utf8mb4_bin; 
Query OK, 1 row affected (0.00 sec)

# replace the [password] to the any password you like
root@localhost [(none)]> create user zabbix@'localhost' identified by 'password'; 
Query OK, 0 rows affected (0.00 sec)

root@localhost [(none)]> grant all privileges on zabbix.* to zabbix@'localhost'; 
Query OK, 0 rows affected (0.00 sec)

root@localhost [(none)]> set global log_bin_trust_function_creators = 1; 
Query OK, 0 rows affected, 1 warning (0.00 sec)

root@localhost [(none)]> exit
Bye

root@belajarfreebsd:~# cd /usr/local/share/zabbix7/server/database/mysql
root@dlp:/usr/local/share/zabbix7/server/database/mysql # mysql -u zabbix -p zabbix < schema.sql
Enter password:   # the password you set above for [zabbix] user
root@dlp:/usr/local/share/zabbix7/server/database/mysql # mysql -u zabbix -p zabbix < images.sql
Enter password:
root@dlp:/usr/local/share/zabbix7/server/database/mysql # mysql -u zabbix -p zabbix < data.sql
Enter password:
root@dlp:/usr/local/share/zabbix7/server/database/mysql # mysql -e "set global log_bin_trust_function_creators = 0;"
```
[7]	Configure and start Zabbix Server.
```sh
root@belajarfreebsd:~# vi /usr/local/etc/zabbix7/zabbix_server.conf
# line 101 : confirm DB name
DBName=zabbix
# line 117 : confirm DB username
DBUser=zabbix
# line 126 : add DB user's password
DBPassword=password
root@belajarfreebsd:~# service zabbix_server enable
zabbix_server enabled in /etc/rc.conf
root@belajarfreebsd:~# service zabbix_server start
```
[8]	Configure and start Zabbix Agent to monitor Zabbix Server itself.
```sh
root@belajarfreebsd:~# vi /usr/local/etc/zabbix7/zabbix_agentd.conf
# line 113 : specify Zabbix server
Server=127.0.0.1
# line 167 : specify Zabbix server
ServerActive=127.0.0.1
# line 178 : change to your hostname
Hostname=dlp.srv.world
root@belajarfreebsd:~# service zabbix_agentd enable
zabbix_agentd enabled in /etc/rc.conf
root@belajarfreebsd:~# service zabbix_agentd start
```
[9]	Confiure Apache httpd for Zabbix site and Change PHP values for Zabbix requirements.
```sh
root@belajarfreebsd:~# vi /usr/local/etc/php-fpm.d/www.conf
;; add to last line
php_value[max_execution_time] = 300
php_value[memory_limit] = 128M
php_value[post_max_size] = 16M
php_value[upload_max_filesize] = 2M
php_value[max_input_time] = 300
php_value[max_input_vars] = 10000
php_value[always_populate_raw_post_data] = -1
php_value[date.timezone] = Asia/Tokyo

root@belajarfreebsd:~# vi /usr/local/etc/apache24/Includes/zabbix.conf
# create new file
<IfModule mod_alias.c>
    Alias /zabbix /usr/local/www/zabbix7
</IfModule>

<Directory "/usr/local/www/zabbix7">
    DirectoryIndex index.php zabbix.php
    Options FollowSymLinks
    AllowOverride None
    Require all granted
</Directory>

<Directory "/usr/local/www/zabbix7/conf">
    Require all denied
</Directory>

<Directory "/usr/local/www/zabbix7/app">
    Require all denied
</Directory>

<Directory "/usr/local/www/zabbix7/include">
    Require all denied
</Directory>

<Directory "/usr/local/www/zabbix7/local">
    Require all denied
</Directory>

<Directory "/usr/local/www/zabbix7/vendor">
    Require all denied
</Directory>

root@belajarfreebsd:~# touch /usr/local/www/zabbix7/conf/zabbix.conf.php
root@belajarfreebsd:~# chown www /usr/local/www/zabbix7/conf/zabbix.conf.php
root@belajarfreebsd:~# service php-fpm reload
root@belajarfreebsd:~# service apache24 reload
```