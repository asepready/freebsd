Nginx : Use PHP Scripts
 	
Configure Nginx to use PHP scripts.

[1]	Install PHP, refer to here.

[2]	Configure Nginx.
```sh
root@www:~# vi /usr/local/etc/nginx/nginx.conf
# add follows in the [server] section
    server {
        .....
        .....
        location ~ \.php$ {
            root  /usr/local/www/nginx;
            fastcgi_pass   127.0.0.1:9000;
            include /usr/local/etc/nginx/fastcgi_params;
            fastcgi_param SCRIPT_FILENAME  $document_root$fastcgi_script_name;
       }

root@www:~# sysrc php_fpm_enable="YES"
root@www:~# service php-fpm start
root@www:~# service nginx reload
# create PHPInfo test page
root@www:~# echo '<?php phpinfo(); ?>' > /usr/local/www/nginx/info.php
```
[3]	Verify to access to PHPInfo test page from any client computer.
