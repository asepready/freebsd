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
user  www www;  ## Default: nobody

# you must set worker processes based on your CPU cores, nginx does not benefit from setting more than that
worker_processes auto; #some last versions calculate it automatically

# number of file descriptors used for nginx
# the limit for the maximum FDs on the server is usually set by the OS.
# if you don't set FD's then OS settings will be used which is by default 2000
worker_rlimit_nofile 100000;

error_log  /var/log/nginx/error.log crit;
#

#pid  logs/nginx.pid;


events {
    worker_connections 2048;  ## Default: 1024
    # accept as many connections as possible, may flood worker connections if set too low -- for testing environment
    multi_accept on;
}


http {
    include       mime.types;
    default_type  application/octet-stream;

    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';

    # cache informations about FDs, frequently accessed files
    # can boost performance, but you need to test those values
    open_file_cache max=200000 inactive=20s;
    open_file_cache_valid 30s;
    open_file_cache_min_uses 2;
    open_file_cache_errors on;

    # to boost I/O on HDD we can disable access logs
    access_log off;

    # copies data between one FD and other from within the kernel
    # faster than read() + write()
    sendfile on;

    # send headers in one piece, it is better than sending them one by one
    tcp_nopush on;

    #access_log  logs/access.log  main;
    # don't buffer data sent, good for small data bursts in real time
    tcp_nodelay on;

    server_names_hash_bucket_size 128;

    # adjusting the buffer size
    client_body_buffer_size 80k;
    client_max_body_size 9m;
    client_header_buffer_size 1k;

    # putting a Limit on timeout values
    client_body_timeout 10;
    client_header_timeout 10;
    keepalive_timeout 13;  #default keepalive_timeout  65; 
    send_timeout 10;

    # compression and decompression
    gzip  on;
    # gzip_static on;
    gzip_min_length 10240;
    gzip_comp_level 1;
    gzip_vary on;
    gzip_disable msie6;
    gzip_proxied expired no-cache no-store private auth;
    gzip_types
        # text/html is always compressed by HttpGzipModule
        text/css
        text/javascript
        text/xml
        text/plain
        text/x-component
        application/javascript
        application/x-javascript
        application/json
        application/xml
        application/rss+xml
        application/atom+xml
        font/truetype
        font/opentype
        application/vnd.ms-fontobject
        image/svg+xml;

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