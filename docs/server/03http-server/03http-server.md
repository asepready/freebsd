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

ServerAdmin info@belajarbsd.id
ServerName www.belajarbsd.id:80

DocumentRoot "/home/sysadmin/www"
<Directory "/home/sysadmin/www">
    Options Indexes FollowSymLinks MultiViews
    AllowOverride All
    #Require all granted
</Directory>

# Virtual hosts
Include etc/apache24/extra/httpd-vhosts.conf

#====================================================================
#/usr/local/etc/apache24/extra/httpd-vhosts.conf
<VirtualHost *:80>
    ServerName pkg.asepready.id
    ServerAlias pkg.asepready.id
    DocumentRoot "/home/sysadmin/www"
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

#/usr/local/etc/php-fpm.d/www
listen = /var/run/php-fpm.sock
listen.owner = www
listen.group = www
listen.mode = 0660

#/usr/local/etc/apache24/httpd.conf
LoadModule proxy_module libexec/apache24/mod_proxy.so
LoadModule proxy_fcgi_module libexec/apache24/mod_proxy_fcgi.so

<IfModule dir_module>
    DirectoryIndex index.php index.html
</IfModule>

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



