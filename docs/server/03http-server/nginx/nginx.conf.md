# Layanan HTTP
## Install Paket Nginx dan PHP5
```sh
pkg install nginx php82 php82-{mysqli,extensions,composer,gd}
```

## Enable Start Boot
```sh
sysrc nginx_enable=YES

#run service
service nginx start
```
## 1. Konfigurasi Nginx

Buat user baru dan folder tempet file projek berada, misal sysadmin:<br>
Dan salin nginx.conf menjadi nginx.conf.bk dan buat struktur folder/file sebagai berikut:
```sh
# folder
-/home/sysadmin/
    |-->www/
    |-->log/

-/usr/local/etc/nginx/
    |-->nginx.conf
    |-->nginx.conf.bk
    |-->vdomains/
        |-->index.conf
        |-->error.conf

mkdir -p /home/sysadmin/www
mkdir -p /home/sysadmin/log

chown -R sysadmin:www /home/sysadmin/www/
chmod -R 755 /home/sysadmin/www/

chown -R sysadmin:www /home/sysadmin/www/
chmod -R 755 /home/sysadmin/www/

```

## 2. Konfigurasi nginx.conf
```sh file
user       www www;  ## Default: nobody
worker_processes  5;  ## Default: 1
#error_log  /home/sysadmin/logs/error.log;
#pid        /home/sysadmin/logs/nginx.pid;
worker_rlimit_nofile 8192;

events {
    worker_connections  4096;  ## Default: 1024
}

http {
    include     mime.types;
    index       index.html index.htm index.php;

    default_type    application/octet-stream;
    log_format      main '$remote_addr - $remote_user [$time_local]  $status '
        '"$request" $body_bytes_sent "$http_referer" '
        '"$http_user_agent" "$http_x_forwarded_for"';
        
    access_log      /home/sysadmin/logs/access.log  main;
    sendfile        on;
    tcp_nopush      on;
    server_names_hash_bucket_size 128; # this seems to be required for some vhosts

    #keepalive_timeout  0;
    keepalive_timeout  65;

    #gzip  on;
    include vhosts/*.conf;
}
```



## 2. Konfigurasi PHP
```sh
#/usr/local/www/info.php
<?php phpinfo(); ?>

#/usr/local/etc/php-fpm.d/www.conf
listen = /var/run/php-fpm.sock  #sudah dimodifikasi listen = 127.0.0.1:9000
listen.owner = www              #sudah dimodifikasi listen.owner = www
listen.group = www              #sudah dimodifikasi listen.group = www
listen.mode = 0660              #sudah dimodifikasi listen.mode = 0660
```
```sh
cp /usr/local/etc/php.ini-production /usr/local/etc/php.ini
# edit php.ini
cig.fix_pathinfo=0              #sudah dimodifikasi cgi.fix_pathinfo=1


# terminal
rehash
sysrc php_fpm_enable="YES"
service php-fpm start
```