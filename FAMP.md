# FAMPP(FreeBSD, Apache, MariaDB, PHP, phpMyAdmin)
# Install Apache
```sh
pkg install -y apache24

# Add service to be fired up at boot time
sysrc apache24_enable="YES"

# Set a ServerName directive in Apache HTTP. Place a name to your server.
sed -i -e 's/#ServerName www.example.com:80/ServerName belajarfreebsd.or.id:80/g' /usr/local/etc/apache24/httpd.conf

service apache24 start
```

# Install PHP 8.2 and its 'funny' dependencies
```sh
pkg install -y php82 php82-mysqli php82-extensions
# Enable PHP to use the FPM process manager
sysrc php_fpm_enable="YES"

# Configure Apache HTTP to use MPM Event instead of the Prefork default
# 1.- Disable the Prefork MPM
sed -i -e '/prefork/s/LoadModule/#LoadModule/' /usr/local/etc/apache24/httpd.conf

# 2.- Enable the Event MPM
sed -i -e '/event/s/#LoadModule/LoadModule/' /usr/local/etc/apache24/httpd.conf

# 3.- Enable the proxy module for PHP-FPM to use it
sed -i -e '/mod_proxy.so/s/#LoadModule/LoadModule/' /usr/local/etc/apache24/httpd.conf

# 4.- Enable the FastCGI module for PHP-FPM to use it
sed -i -e '/mod_proxy_fcgi.so/s/#LoadModule/LoadModule/' /usr/local/etc/apache24/httpd.conf

# Create configuration file for Apache HTTP to 'speak' PHP
vim /usr/local/etc/apache24/modules.d/003_php-fpm.conf

vim /usr/local/etc/php-fpm.d/www.conf
# line 45 : change
listen = 127.0.0.1:9000

# Add the configuration into the file
# /usr/local/etc/apache24/modules.d/003_php-fpm.conf
<IfModule proxy_fcgi_module>
    <IfModule dir_module>
        DirectoryIndex index.php
    </IfModule>
    <FilesMatch "\.(php|phtml|inc)$">
        SetHandler "proxy:fcgi://127.0.0.1:9000"
    </FilesMatch>
</IfModule>

# Set the PHP's default configuration
cp /usr/local/etc/php.ini-production /usr/local/etc/php.ini

service php_fpm start

#create file test php
ee /usr/local/www/apache24/data/info.php
```
```php
<?
phpinfo();
?>
```

# Install MariaDB 10.6
```sh
pkg install -y mariadb106-server mariadb106-client phpMyAdmin5-php82 php82-mysqli php82-fileinfo php82-session php82-curl

# Add service to be fired up at boot time
sysrc mysql_enable="YES"
sysrc mysql_args="--bind-address=127.0.0.1"
service mysql-server start
# Make the 'safe' install for MariaDB
mysql_secure_installation

```

# 1.- Removing the OS type and modifying version banner (no mod_security here). 
# 1.1- ServerTokens will only display the minimal information possible.
```sh
sed -i '' -e '227i\
# ServerTokens Prod' /usr/local/etc/apache24/httpd.conf
```
# 1.2- ServerSignature will disable the server exposing its type.
```sh
sed -i '' -e '228i\
# ServerSignature Off' /usr/local/etc/apache24/httpd.conf
```
# Alternatively we can inject the line at the bottom of the file using the echo command.
# This is a safer option if you make heavy changes at the top of the file.
```sh
# echo 'ServerTokens Prod' >> /usr/local/etc/apache24/httpd.conf
# echo 'ServerSignature Off' >> /usr/local/etc/apache24/httpd.conf
```
# 2.- Avoid PHP's information (version, etc) being disclosed
```sh
sed -i -e '/expose_php/s/expose_php = On/expose_php = Off/' /usr/local/etc/php.ini
```
# 3.- Fine tunning access to the DocumentRoot directory structure
```sh
sed -i '' -e 's/Options Indexes FollowSymLinks/Options -Indexes +FollowSymLinks -Includes/' /usr/local/etc/apache24/httpd.conf
```
# 4.- Enabling TLS connections with a self signed certificate. 
# 4.1- Key and certificate generation
# IMPORTANT: Please do adapt to your needs the fields below like: Organization, Common Name and Email, etc.
```sh
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /usr/local/etc/apache24/server.key -out /usr/local/etc/apache24/server.crt -subj "/C=ID/ST=Bangka Belitung/L=Pangkalpinang/O=belajarfreebsd.or.id/CN=belajarfreebsd.or.id/emailAddress=admin@belajarfreebsd.or.id"
```
# Because we have generated a certificate + key we will enable SSL/TLS in the server.
# 4.3- Enabling TLS connections in the server.
```sh
sed -i -e '/mod_ssl.so/s/#LoadModule/LoadModule/' /usr/local/etc/apache24/httpd.conf
```
# 4.4- Enable the server's default TLS configuration to be applied.
```sh
sed -i -e '/httpd-ssl.conf/s/#Include/Include/' /usr/local/etc/apache24/httpd.conf
```
# 4.5- Enable TLS session cache.
```sh
sed -i -e '/mod_socache_shmcb.so/s/#LoadModule/LoadModule/' /usr/local/etc/apache24/httpd.conf
```
# 4.6- Redirect HTTP connections to HTTPS (port 80 and 443 respectively)
# 4.6.1- Enabling the rewrite module
```sh
sed -i -e '/mod_rewrite.so/s/#LoadModule/LoadModule/' /usr/local/etc/apache24/httpd.conf
```
# 4.6.2- Adding the redirection rules.
# Use the following sed entries if you are using the event-php-fpm.sh script.
```sh
sed -i '' -e '181i\
RewriteEngine On' /usr/local/etc/apache24/httpd.conf

sed -i '' -e '182i\
RewriteCond %{HTTPS}  !=on' /usr/local/etc/apache24/httpd.conf

sed -i '' -e '183i\
RewriteRule ^/?(.*) https://%{SERVER_NAME}/$1 [R,L]' /usr/local/etc/apache24/httpd.conf
```
# 5.- Secure the headers to a minimum
```sh
#/usr/local/etc/apache24/httpd.conf
echo "
<IfModule mod_headers.c>
    Header set Content-Security-Policy \"upgrade-insecure-requests;\"
    Header set Strict-Transport-Security \"max-age=31536000; includeSubDomains\"
    Header always edit Set-Cookie (.*) \"\$1; HttpOnly; Secure\"
    Header set X-Content-Type-Options \"nosniff\"
    Header set X-XSS-Protection \"1; mode=block\"
    Header set Referrer-Policy \"strict-origin\"
    Header set X-Frame-Options: \"deny\"
    SetEnv modHeadersAvailable true
</IfModule>"   
```
# 6.- Disable the TRACE method.

echo 'TraceEnable off' >> /usr/local/etc/apache24/httpd.conf

# 7.- Allow specific HTTP methods.
sed -i '' -e '269i\
    <LimitExcept GET POST HEAD>' /usr/local/etc/apache24/httpd.conf

sed -i '' -e '270i\
       deny from all' /usr/local/etc/apache24/httpd.conf

sed -i '' -e '271i\
    </LimitExcept>' /usr/local/etc/apache24/httpd.conf


# 8.- Restart Apache HTTP so changes take effect.
service apache24 restart


# Install Drupal 9 on FreeBSD 
echo 'Creating database and user for the Drupal 9 installation'

# Create the database and user. Mind this is MariaDB.
pkg install -y pwgen

touch /root/new_db_name.txt
touch /root/new_db_user_name.txt
touch /root/newdb_pwd.txt

# Create the database and user. 
NEW_DB_NAME=$(pwgen 8 --secure --numerals --capitalize) && export NEW_DB_NAME && echo $NEW_DB_NAME >> /root/new_db_name.txt

NEW_DB_USER_NAME=$(pwgen 10 --secure --numerals --capitalize) && export NEW_DB_USER_NAME && echo $NEW_DB_USER_NAME >> /root/new_db_user_name.txt

NEW_DB_PASSWORD=$(pwgen 32 --secure --numerals --capitalize) && export NEW_DB_PASSWORD && echo $NEW_DB_PASSWORD >> /root/newdb_pwd.txt

NEW_DATABASE=$(expect -c "
set timeout 10
spawn mysql -u root -p
expect \"Enter password:\"
send \"\r\"
expect \"root@localhost \[(none)\]>\"
send \"CREATE DATABASE $NEW_DB_NAME;\r\"
expect \"root@localhost \[(none)\]>\"
send \"CREATE USER '$NEW_DB_USER_NAME'@'localhost' IDENTIFIED BY '$NEW_DB_PASSWORD';\r\"
expect \"root@localhost \[(none)\]>\"
send \"GRANT ALL PRIVILEGES ON $NEW_DB_NAME.* TO '$NEW_DB_USER_NAME'@'localhost';\r\"
expect \"root@localhost \[(none)\]>\"
send \"FLUSH PRIVILEGES;\r\"
expect \"root@localhost \[(none)\]>\"
send \"exit\r\"
expect eof
")

echo "$NEW_DATABASE"

# Install the missing PHP packages
pkg install -y php82-gd php82-mbstring php82-pdo_mysql

# Enable the use of .htaccess.
sed -i '' -e '279s/AllowOverride None/AllowOverride All/g' /usr/local/etc/apache24/httpd.conf

# Restart Apache HTTP so changes take effect
service apache24 restart

echo 'The FAMP stack is ready to install Drupal 9 on this box'

# Fetch Drupal 9 from the official site
fetch -o /tmp https://ftp.drupal.org/files/projects/drupal-9.5.0.tar.gz

# Create Database Drupal 9
root@localhost [(none)]> create database cms_db; 
Query OK, 1 row affected (0.000 sec)
root@localhost [(none)]> grant all privileges on cms_db.* to cms_usr@'localhost' identified by 'password'; 

# Unpack Drupal 9
tar -zxf /tmp/drupal-9.5.0.tar.gz -C /tmp

# Create the main config file from the sample
cp /tmp/drupal-9.5.0/sites/default/default.settings.php /tmp/drupal-9.5.0/sites/default/settings.php

# Add the database name into the settings.php file
NEW_DB=$(cat /root/new_db_name.txt) && export NEW_DB
sed -i -e 's/databasename/'"$NEW_DB"'/g' /tmp/drupal-9.5.0/sites/default/settings.php

# Add the username into the settings.php file
USER_NAME=$(cat /root/new_db_user_name.txt) && export USER_NAME
sed -i -e 's/sqlusername/'"$USER_NAME"'/g' /tmp/drupal-9.5.0/sites/default/settings.php

# Add the db password into the settings.php file
PASSWORD=$(cat /root/newdb_pwd.txt) && export PASSWORD
sed -i -e 's/sqlpassword/'"$PASSWORD"'/g' /tmp/drupal-9.5.0/sites/default/settings.php

## Add the host parameter where MariaDB is running to the Drupal's settings.php configuration file. If not added it won't accept connections when installing.
sed -i '' -e '83s/localhost/127.0.0.1/g' /tmp/drupal-9.5.0/sites/default/settings.php

## Add the UNIX socket path 
sed -i '' -e '88i\
 *   '\'unix_socket\'\ \=\>\ \'/var\/run\/mysql\/mysql.sock\', /tmp/drupal-9.5.0/sites/default/settings.php
 
# Move the content of the Drupal 9 directory into the DocumentRoot path
cp -r /tmp/drupal-9.5.0/ /usr/local/www/apache24/data


# Change the ownership of the DocumentRoot path content from root to the Apache HTTP user (named www)
chown -R www:www /usr/local/www/apache24/data

echo 'Restarting services to load the new configuration for Drupal 9'

# Preventive services restart
service apache24 restart
service php-fpm restart
service mysql-server restart

# No one but root can read these files. Read only permissions.
chmod 400 /root/new_db_name.txt
chmod 400 /root/new_db_user_name.txt
chmod 400 /root/newdb_pwd.txt

# Display the new database, username and password generated on MySQL to accomodate Drupal 9
echo "Your DB_ROOT_PASSWORD is blank if you are root or a highly privileged user"
echo "Your NEW_DB_NAME is written on this file /root/new_db_name.txt"
echo "Your NEW_DB_USER_NAME is written on this file /root/new_db_user_name.txt"
echo "Your NEW_DB_PASSWORD is written on this file /root/newdb_pwd.txt"

# Actions on the CLI are now finished.
echo 'Actions on the CLI are now finished. Please visit the ip/domain of the site with a web browser and proceed with the final steps of install

'
echo 'Remember to place 127.0.0.1 in the Host field in the Advanced Parameters section, otherwise the install will probably not work.'

## Reference articles:

## https://www.digitalocean.com/community/tutorials/how-to-install-an-apache-mysql-and-php-famp-stack-on-freebsd-12-0
## https://www.digitalocean.com/community/tutorials/how-to-configure-apache-http-with-mpm-event-and-php-fpm-on-freebsd-12-0
## https://www.adminbyaccident.com/freebsd/how-to-install-famp-stack/
## https://www.adminbyaccident.com/security/how-to-harden-apache-http/
## https://www.digitalocean.com/community/tutorials/recommended-steps-to-harden-apache-http-on-freebsd-12-0
## https://www.adminbyaccident.com/freebsd/how-to-freebsd/how-to-set-apaches-mpm-event-and-php-fpm-on-freebsd/
## https://www.adminbyaccident.com/freebsd/how-to-freebsd/how-to-install-drupal-9-on-freebsd-13-0/

## EOF