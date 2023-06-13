# Layanan HTTP
## Install Paket Apache dan PHP5
```sh
pkg install apache24 php82 php82-{mysqli,extensions}
```
## Enable Start Boot
```sh
sysrc apache24_enable="YES"

#run service
service apache24 start
```
## 1. Konfigurasi Apache2
```sh file
#/usr/local/etc/apache24/httpd.conf
LoadModule vhost_alias_module libexec/apache24/mod_vhost_alias.so
LoadModule rewrite_module libexec/apache24/mod_rewrite.so

ServerAdmin info@belajarbsd.id
ServerName www.belajarbsd.id:80

DocumentRoot "/usr/local/www/apache24/data"
<Directory "/usr/local/www/apache24/data">
    Options Indexes FollowSymLinks MultiViews
    AllowOverride All
    Require all granted
    Order allow,deny
    allow from all
</Directory>

ErrorLog "/usr/local/home/sysadmin/log/%d-%m-%Y-errot.log"
<IfModule log_config_module>

    #CustomLog "/var/log/httpd-access.log" common
    CustomLog "/usr/local/home/sysadmin/log/%d-%m-%Y-access.log" combined
</IfModule>

# Virtual hosts
Include etc/apache24/extra/httpd-vhosts.conf

#====================================================================
#/usr/local/etc/apache24/extra/httpd-vhosts.conf
<VirtualHost *:80>
    ServerName pkg.asepready.id
    ServerAlias pkg.asepready.id
    DocumentRoot /usr/local/home/sysadmin/web/
</VirtualHost>
```
apache test
```sh
apachectl configtest
apachectl restart
```

## 2. Konfigurasi PHP
```sh
#/usr/local/www/info.php
<?php phpinfo(); ?>

#/usr/local/etc/php-fpm.d/www.conf
listen = /var/run/php-fpm.sock
listen.owner = www
listen.group = www
listen.mode = 0660

#/usr/local/etc/apache24/httpd.conf
LoadModule proxy_module libexec/apache24/mod_proxy.so
LoadModule proxy_fcgi_module libexec/apache24/mod_proxy_fcgi.so

<FilesMatch \.php$>
    SetHandler "proxy:unix:/var/run/php-fpm.sock|fcgi://localhost"
</FilesMatch>

```
```sh
cp /usr/local/etc/php.ini-production /usr/local/etc/php.ini
rehash
sysrc php_fpm_enable="YES"
service php-fpm start
apachectl restart
```



