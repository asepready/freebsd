MariaDB 10.11 : Install phpMyAdmin2024/02/09
 	
Install phpMyAdmin to operate MariaDB on web browser from Client Computers.

[1]	Install Apache httpd, refer to here.

[2]	Install PHP, refer to here.

[3]	Install phpMyAdmin.
```sh
root@www:~ # pkg install -y phpMyAdmin5-php82 php82-mysqli php82-fileinfo php82-session php82-curl
root@www:~ # mysql
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 10
Server version: 10.11.6-MariaDB FreeBSD Ports

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

# create database for phpmyadmin
root@localhost [(none)]> create database phpmyadmin; 
Query OK, 1 row affected (0.000 sec)
root@localhost [(none)]> grant all privileges on phpmyadmin.* to pma@'localhost' identified by 'password'; 
Query OK, 0 rows affected (0.007 sec)

root@localhost [(none)]> exit 
Bye

root@www:~ # cd /usr/local/www/phpMyAdmin/sql
root@www:/usr/local/www/phpMyAdmin/sql # mysql < create_tables.sql
root@www:/usr/local/www/phpMyAdmin/sql # cd
root@www:~ # vi /usr/local/etc/apache24/Includes/phpmyadmin.conf
# create new
Alias /phpmyadmin/ "/usr/local/www/phpMyAdmin/"
<Directory "/usr/local/www/phpMyAdmin/">
    DirectoryIndex index.php
    Options None
    AllowOverride Limit
    #Require local
    #Require host .belajarfreebsd.or.id
    # range of access allowed
    Require ip 127.0.0.1 10.0.0.0/24
</Directory>

root@www:~ # vi /usr/local/www/phpMyAdmin/config.inc.php
<?php
/* Skeleton configuration file -- this file is empty on a fresh
 * installaton of phpmyadmin.
 *
 * Copy any settings you want to override from
 * libraries/config.default.php or visit /phpmyadmin/setup/ to generate a
 * basic configuration file
 *
 */

# add follows
$i = 0;
$i++;
$cfg['Servers'][$i]['verbose'] = '';
$cfg['Servers'][$i]['host'] = '127.0.0.1';
$cfg['Servers'][$i]['port'] = '';
$cfg['Servers'][$i]['socket'] = '';
$cfg['Servers'][$i]['auth_type'] = 'cookie';
$cfg['Servers'][$i]['user'] = 'root';
$cfg['Servers'][$i]['password'] = '';

$cfg['blowfish_secret'] = \sodium_hex2bin('5ba7c764dd668516338af26f2a299a246cac1b9a40341343951a44059279bcaa');
$cfg['DefaultLang'] = 'en';
$cfg['ServerDefault'] = 1;
$cfg['UploadDir'] = '';
$cfg['SaveDir'] = '';

$cfg['Servers'][$i]['controlhost'] = '';
$cfg['Servers'][$i]['controlport'] = '';
$cfg['Servers'][$i]['controluser'] = 'pma';
# replace the password you set for pma user above
$cfg['Servers'][$i]['controlpass'] = 'password';

$cfg['Servers'][$i]['pmadb'] = 'phpmyadmin';
$cfg['Servers'][$i]['bookmarktable'] = 'pma__bookmark';
$cfg['Servers'][$i]['central_columns'] = 'pma__central_columns';
$cfg['Servers'][$i]['column_info'] = 'pma__column_info';
$cfg['Servers'][$i]['designer_settings'] = 'pma__designer_settings';
$cfg['Servers'][$i]['export_templates'] = 'pma__export_templates';
$cfg['Servers'][$i]['favorite'] = 'pma__favorite';
$cfg['Servers'][$i]['history'] = 'pma__history';
$cfg['Servers'][$i]['navigationhiding'] = 'pma__navigationhiding';
$cfg['Servers'][$i]['pdf_pages'] = 'pma__pdf_pages';
$cfg['Servers'][$i]['recent'] = 'pma__recent';
$cfg['Servers'][$i]['relation'] = 'pma__relation';
$cfg['Servers'][$i]['savedsearches'] = 'pma__savedsearches';
$cfg['Servers'][$i]['table_coords'] = 'pma__table_coords';
$cfg['Servers'][$i]['table_info'] = 'pma__table_info';
$cfg['Servers'][$i]['table_uiprefs'] = 'pma__table_uiprefs';
$cfg['Servers'][$i]['tracking'] = 'pma__tracking';
$cfg['Servers'][$i]['userconfig'] = 'pma__userconfig';
$cfg['Servers'][$i]['usergroups'] = 'pma__usergroups';
$cfg['Servers'][$i]['users'] = 'pma__users';

?>

root@www:~ # chown -R www:www /usr/local/www/phpMyAdmin
root@www:~ # service php-fpm reload
root@www:~ # service apache24 reload
```
[4]	Access to [http://(web server hostname or IP address)/phpmyadmin/] with web browser from any client computer that you have granted access to. Then phpMyAdmin login form is displayed, authenticate and log in with any user registered in MariaDB.