Apache httpd : Use PHP-FPM Scripts
 	
Configure Apache httpd to use PHP scripts.

[1]	Install PHP, refer to here.
```sh
pkg install -y php82
```

[2]	Configure Apache httpd.
```sh

root@www:~ # vi /usr/local/etc/apache24/httpd.conf
# line 66 : uncomment
LoadModule mpm_event_module libexec/apache24/mod_mpm_event.so
# line 67 : comment
#LoadModule mpm_prefork_module libexec/apache24/mod_mpm_prefork.so
# line 129 : uncomment
LoadModule proxy_module libexec/apache24/mod_proxy.so
# line 133 : uncomment
LoadModule proxy_fcgi_module libexec/apache24/mod_proxy_fcgi.so
root@www:~ # vi /usr/local/etc/php-fpm.d/www.conf
# line 45 : change
listen = 127.0.0.1:9000
#listen = /var/run/php-fpm.sock

# line 57, 58 : uncomment
listen.owner = www
listen.group = www
# add setting within the Virtualhost section where you want to configure PHP
root@www:~ # vi /usr/local/etc/apache24/modules.d/003_php-fpm.conf
<IfModule proxy_fcgi_module>
    <IfModule dir_module>
        DirectoryIndex index.php
    </IfModule>
    <FilesMatch "\.(php|phtml|inc)$">
        SetHandler "proxy:fcgi://127.0.0.1:9000"
    </FilesMatch>
</IfModule>

root@www:~ # vi /usr/local/etc/apache24/extra/httpd-ssl.conf
.....
.....
    <FilesMatch \.php$>
        SetHandler proxy:fcgi://127.0.0.1:9000
    </FilesMatch>
</VirtualHost>

root@www:~ # cp /usr/local/etc/php.ini-production /usr/local/etc/php.ini

root@www:~ # sysrc php_fpm_enable="YES"
root@www:~ # service php-fpm start
Performing sanity check on php-fpm configuration:
[30-Jan-2024 11:10:13] NOTICE: configuration file /usr/local/etc/php-fpm.conf test is successful

Starting php_fpm.

root@www:~ # service apache24 reload
# create a test page
root@www:~ # echo '<?php phpinfo(); ?>' > /usr/local/www/apache24/data/info.php
```
[3]	Verify to access to PHPInfo test page from any client computer.