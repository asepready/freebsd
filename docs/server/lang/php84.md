## Konfigurasi PHP

```sh install
pkg install php84 php84-{mysqli,extensions,composer,gd} # mod_php84 # mod apache
```

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

<FilesMatch "\.php$">
    SetHandler  "proxy:fcgi://localhost:9000"
</FilesMatch>

```
```sh
cp /usr/local/etc/php.ini-production /usr/local/etc/php.ini
rehash
sysrc php_fpm_enable="YES"
service php-fpm start
apachectl restart
```