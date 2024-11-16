OpenLDAP : LDAP Account Manager2024/04/18
 	
Install LDAP Account Manager to manage LDAP user accounts on Web GUI.
[1]	Install and start Apache httpd, refer to here.

[2]	Configure PHP on Apache httpd, refer to here.

[3]	Install LDAP Account Manager.
```sh
root@belajarfreebsd:~# pkg install -y ldap-account-manager php82 php82-session php82-gettext php82-ldap php82-xml php82-xmlreader php82-xmlwriter php82-mbstring php82-pecl-imagick php82-gmp php82-filter php82-zip
root@belajarfreebsd:~# vi /usr/local/etc/php-fpm.d/www.conf
# line 494 : uncomment and change memory_limit more than 64M
php_admin_value[memory_limit] = 128M
root@belajarfreebsd:~# vi /usr/local/etc/apache24/Includes/ldap-account-manager.conf
# create new
Alias /lam /usr/local/www/lam
<Directory /usr/local/www/lam>
  Options +FollowSymLinks
  AllowOverride All
  # access permission if you need
  Require ip 127.0.0.1 10.0.0.0/24
  DirectoryIndex index.html
</Directory>

root@belajarfreebsd:~# chown -R www:www /usr/local/www/lam/sess
root@belajarfreebsd:~# chown -R www:www /usr/local/www/lam/tmp
root@belajarfreebsd:~# service php-fpm reload
root@belajarfreebsd:~# service apache24 reload
```
[4]	Access to [(your hostname or IP address)/lam/] with web browser from any Clients which are in the Network you set to allow. LDAP Account Manager Login form is shown, then click [LAM configuration] which is on upper-right to set your server's profile.

[5]	Click [Edit server profiles].

[6]	Login with a LAM Admin user [lam]. Default password is the same with username.

[7]	Configure your LDAP server URL and Suffix and also change default password for [lam] user.



[8]	Scroll up and move to [Account types] tab. Next, Scroll down and Configure Users and Group Suffix. After setting minimum required items, Click the [Save] button.

[9]	After saving settings, Login form is shown, login with LDAP admin user.

[10] If successfully logined, it's possible to manage LDAP user accounts on here.
