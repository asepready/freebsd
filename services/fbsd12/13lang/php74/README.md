## Buka dan Edit file /usr/local/etc/php-fpm.d/www.conf
```sh
edit /usr/local/etc/php-fpm.d/www.conf
```
1. cari baris:
```sh
listen = 127.0.0.1:9000
```
rubah menjadi:
```sh
listen = /var/run/php74-fpm.sock
```

3. Hilangkan koment pada baris:
```sh
listen.owner = www
listen.group = www
listen.mode = 0660
```

Enable PHP start up
```sh
sysrc php_fpm_enable="YES"
```
## PHP74 salin php.ini
```sh
cp -v /usr/local/etc/php.ini-production /usr/local/etc/php.ini
```
## Perintah menjalankan service PHP-FPM
```sh
service php-fpm stop
service php-fpm start
service php-fpm restart
service php-fpm status
```

## Enabling Service and Setting Up a Firewall with IPFW
```sh
grep rcvar /usr/local/etc/rc.d/*
```

## Buat dan buka untuk WebServer Nginx
```sh
ee /usr/local/etc/php/99-custom.ini
```
```sh
display_errors=Off
safe_mode=Off
safe_mode_exec_dir=
safe_mode_allowed_env_vars=PHP_
expose_php=Off
log_errors=On
error_log=/var/log/nginx/php.scripts.log
register_globals=Off
cgi.force_redirect=0
file_uploads=On
allow_url_fopen=Off
sql.safe_mode=Off
disable_functions=show_source, system, shell_exec, passthru, proc_open, proc_nice, exec
max_execution_time=60
memory_limit=60M
upload_max_filesize=2M
post_max_size=2M
cgi.fix_pathinfo=0
sendmail_path=/usr/sbin/sendmail -fwebmaster@cyberciti.biz -t
```
