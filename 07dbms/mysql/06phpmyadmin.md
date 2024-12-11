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
Query OK, 1 row affected (0.00 sec)

# replace the [password] to the any password you like
root@localhost [(none)]> create user pma@'localhost' identified by 'pmapass'; 
Query OK, 0 rows affected (0.00 sec)

root@localhost [(none)]> grant all privileges on phpmyadmin.* to pma@'localhost'; 
Query OK, 0 rows affected (0.00 sec)

root@localhost [(none)]> \q
Bye

root@www:~ # cd /usr/local/www/phpMyAdmin/sql
root@www:/usr/local/www/phpMyAdmin/sql # mysql < create_tables.sql
root@www:/usr/local/www/phpMyAdmin/sql # cd
root@www:~ # vi /usr/local/etc/apache24/Includes/phpmyadmin.conf
# create new
Alias /phpmyadmin "/usr/local/www/phpMyAdmin/"
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
/**
 * phpMyAdmin sample configuration, you can use it as base for
 * manual configuration. For easier setup you can use setup/
 *
 * All directives are explained in documentation in the doc/ folder
 * or at <https://docs.phpmyadmin.net/>.
 */

declare(strict_types=1);

/**
 * This is needed for cookie based authentication to encrypt the cookie.
 * Needs to be a 32-bytes long string of random bytes. See FAQ 2.10.
 */
$cfg['blowfish_secret'] = \sodium_hex2bin('5ba7c764dd668516338af26f2a299a246cac1b9a40341343951a44059279bcaa'); /* YOU MUST FILL IN THIS FOR COOKIE AUTH! */

/**
 * Servers configuration
 */
$i = 0;

/**
 * First server
 */
$i++;
/* Authentication type */
$cfg['Servers'][$i]['auth_type'] = 'cookie';
/* Server parameters */
$cfg['Servers'][$i]['host'] = 'localhost';
$cfg['Servers'][$i]['compress'] = false;
$cfg['Servers'][$i]['AllowNoPassword'] = true;

/**
 * phpMyAdmin configuration storage settings.
 */

/* User used to manipulate with storage */
$cfg['Servers'][$i]['controlhost'] = '';
$cfg['Servers'][$i]['controlport'] = '';
$cfg['Servers'][$i]['controluser'] = 'pma';
$cfg['Servers'][$i]['controlpass'] = 'pmapass';

/* Storage database and tables */
$cfg['Servers'][$i]['pmadb'] = 'phpmyadmin';
$cfg['Servers'][$i]['bookmarktable'] = 'pma__bookmark';
$cfg['Servers'][$i]['relation'] = 'pma__relation';
$cfg['Servers'][$i]['table_info'] = 'pma__table_info';
$cfg['Servers'][$i]['table_coords'] = 'pma__table_coords';
$cfg['Servers'][$i]['pdf_pages'] = 'pma__pdf_pages';
$cfg['Servers'][$i]['column_info'] = 'pma__column_info';
$cfg['Servers'][$i]['history'] = 'pma__history';
$cfg['Servers'][$i]['table_uiprefs'] = 'pma__table_uiprefs';
$cfg['Servers'][$i]['tracking'] = 'pma__tracking';
$cfg['Servers'][$i]['userconfig'] = 'pma__userconfig';
$cfg['Servers'][$i]['recent'] = 'pma__recent';
$cfg['Servers'][$i]['favorite'] = 'pma__favorite';
$cfg['Servers'][$i]['users'] = 'pma__users';
$cfg['Servers'][$i]['usergroups'] = 'pma__usergroups';
$cfg['Servers'][$i]['navigationhiding'] = 'pma__navigationhiding';
$cfg['Servers'][$i]['savedsearches'] = 'pma__savedsearches';
$cfg['Servers'][$i]['central_columns'] = 'pma__central_columns';
$cfg['Servers'][$i]['designer_settings'] = 'pma__designer_settings';
$cfg['Servers'][$i]['export_templates'] = 'pma__export_templates';

/**
 * End of servers configuration
 */

/**
 * Directories for saving/loading files from server
 */
$cfg['UploadDir'] = '';
$cfg['SaveDir'] = '';

/**
 * Whether to display icons or text or both icons and text in table row
 * action segment. Value can be either of 'icons', 'text' or 'both'.
 * default = 'both'
 */
//$cfg['RowActionType'] = 'icons';

/**
 * Defines whether a user should be displayed a "show all (records)"
 * button in browse mode or not.
 * default = false
 */
//$cfg['ShowAll'] = true;

/**
 * Number of rows displayed when browsing a result set. If the result
 * set contains more rows, "Previous" and "Next".
 * Possible values: 25, 50, 100, 250, 500
 * default = 25
 */
//$cfg['MaxRows'] = 50;

/**
 * Disallow editing of binary fields
 * valid values are:
 *   false    allow editing
 *   'blob'   allow editing except for BLOB fields
 *   'noblob' disallow editing except for BLOB fields
 *   'all'    disallow editing
 * default = 'blob'
 */
//$cfg['ProtectBinary'] = false;

/**
 * Default language to use, if not browser-defined or user-defined
 * (you find all languages in the locale folder)
 * uncomment the desired line:
 * default = 'en'
 */
//$cfg['DefaultLang'] = 'en';
//$cfg['DefaultLang'] = 'de';

/**
 * How many columns should be used for table display of a database?
 * (a value larger than 1 results in some information being hidden)
 * default = 1
 */
//$cfg['PropertiesNumColumns'] = 2;

/**
 * Set to true if you want DB-based query history.If false, this utilizes
 * JS-routines to display query history (lost by window close)
 *
 * This requires configuration storage enabled, see above.
 * default = false
 */
//$cfg['QueryHistoryDB'] = true;

/**
 * When using DB-based query history, how many entries should be kept?
 * default = 25
 */
//$cfg['QueryHistoryMax'] = 100;

/**
 * Whether or not to query the user before sending the error report to
 * the phpMyAdmin team when a JavaScript error occurs
 *
 * Available options
 * ('ask' | 'always' | 'never')
 * default = 'ask'
 */
//$cfg['SendErrorReports'] = 'always';

/**
 * 'URLQueryEncryption' defines whether phpMyAdmin will encrypt sensitive data from the URL query string.
 * 'URLQueryEncryptionSecretKey' is a 32 bytes long secret key used to encrypt/decrypt the URL query string.
 */
//$cfg['URLQueryEncryption'] = true;
//$cfg['URLQueryEncryptionSecretKey'] = '';

/**
 * You can find more configuration options in the documentation
 * in the doc/ folder or at <https://docs.phpmyadmin.net/>.
 */

root@www:~ # chown -R www:www /usr/local/www/phpMyAdmin
root@www:~ # service php-fpm reload
root@www:~ # service apache24 reload
```
[4]	Access to [http://(web server hostname or IP address)/phpmyadmin/] with web browser from any client computer that you have granted access to. Then phpMyAdmin login form is displayed, authenticate and log in with any user registered in MariaDB.