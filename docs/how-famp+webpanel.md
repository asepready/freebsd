<p align="center">
<img src="./../assets/images/logo.png" alt="Logo" style="width:200px;"/>
<h1>FAMP + phpMyAdmin</h1>
<h1>FreeBSD.Apache24.Mysql57.PHP82 + phpMyAdmin-PHP82</h1>
</p>

## Persiapan Hosts
| Komponen | Deskripsi |
| - | - |
| Hostname | famplokal |
| Interface | em1 |
| Host IP address | 172.16.16.8/24 |
| Internet gateway | 172.16.16.1 |
| Domain Local | famplokal.net |
| DNS server/s | 172.16.16.16, 8.8.8.8 |

## Lakukan Konfigurasi file /etc/rc.conf dan hosts 
```sh file 
#/etc/rc.conf
hostname="famplokal"
ifconfig_em1="inet 172.16.16.2 netmask 255.255.255.0"
defaultrouter="172.16.16.1"

#/etc/hosts
::1                     localhost localhost.my.domain
127.0.0.1               localhost localhost.my.domain
172.16.16.2             famplokal famplokal.net
```

## Catatan hasil belajar FreeBSD support versi =>11.* sebagai Server
===> Buat Apache & phpMyAdmin.secara default user & group 'www'.
```sh
service apache24 start
service mysql-server start
service php-fpm start
```

### Install Paket yang di butuhkan
```sh
pkg ins apache24 mysql80-{client,server} php82 php82-{mysqli,extensions} mod_php82 phpMyAdmin-php82 
```

### Lakukan Konfigurasi
1. Lakukan Konfigurasi di /etc/rc.conf dan jalan service
```sh term
    sysrc apache24_enable="YES"
    sysrc mysql_enable="YES"
    sysrc php_fpm_enable="YES"
```
2. Konfigurasi Apache
    edit file pada /usr/local/etc/apache24/httpd.conf
```sh
    #ServerAdmin you@example.com
    ServerAdmin fbsd@famplokal.net
    ServerName famplokal.net:80 #buat sesuai dengan hosts
    # tambah kan index.php
    DirectoryIndex index.html index.php
```
    Ketika sudah menambahn atau konfigurasi lakukan konfirmasi dengan:
```sh term
    service apache24 start
    apachectl configtest
    apachectl restart
```
3. Konfigurasi MySql
```sh
    cp /usr/local/share/mysql/my-default.cnf /var/db/mysql/my.cnf
    #jika diperlukan
    service mysql-server start
    mysql_secure_installation
```
5. Konfigurasi PHP
    buat file di /usr/local/etc/apache24/modules.d/000_mod-php.conf
```conf
#/usr/local/etc/apache24/modules.d/000_mod-php.conf
<IfModule dir_module>
    DirectoryIndex index.php index.html
        <FilesMatch "\.php$">
        SetHandler application/x-httpd-php
    </FilesMatch>
    <FilesMatch "\.phps$">
        SetHandler application/x-httpd-php-source
    </FilesMatch>
</IfModule>
```
pengujian PHP dengan buat file baru /usr/local/www/apache24/data/info.php
```sh
<?php phpinfo(); ?>
```
    Salin file di /usr/local/etc/php.ini-production menjadi /usr/local/etc/php.ini
```sh term
    cp /usr/local/etc/php.ini-production /usr/local/etc/php.ini
    rehash
    service php-fpm start && service php-fpm restart
    apachectl restart
```
6. Konfigurasi phpMyAdmin
- Dengan Membuat Virtual Host

Hilangkan tanda # pada baris Include etc/apache24/extra/httpd-vhosts.conf dalam file /apache24/httpd.conf
Edit file /usr/local/etc/apache24/extra/httpd-vhosts.conf
```sh httpd.conf
<VirtualHost *:80>
    ServerAdmin fbsd@famplokal.net
    DocumentRoot "/usr/local/www/phpMyAdmin/"
    ServerName admin.famplokal.net
    ServerAlias www.admin.famplokal.net
    ErrorLog "/var/log/phpmyadmin.log"
    CustomLog "/var/log/phpmyadmin-access.log" common

    Alias /phpmyadmin/ "/usr/local/www/phpMyAdmin/"
    <Directory "/usr/local/www/phpMyAdmin/">
        Options None
        AllowOverride Limit
        Require all granted
    </Directory>
</VirtualHost>
```
- Menambahkan skrip Ke dalam httpd.conf
```sh httpd.conf
Include etc/apache24/Includes/*.conf

Alias /phpmyadmin "/usr/local/www/phpMyAdmin/"

<Directory "/usr/local/www/phpMyAdmin/">
    Options None
    AllowOverride Limit
    Require local
    Require host localhost
</Directory>
```

Salin dan editfile /usr/local/www/phpMyAdmin/config.sample.inc.php menjadi config.inc.php
```sh
cp /usr/local/www/phpMyAdmin/config.sample.inc.php /usr/local/www/phpMyAdmin/config.inc.php
    #/usr/local/www/phpMyAdmin/config.inc.php
    $cfg['blowfish_secret'] = ''
    # tambahan kunci sacara acak yang susah ditebak
    $cfg['blowfish_secret'] = 'Ey0r*h!5g#oNf5WvkosW)*H$jasn%$!1'
```
#### Sumber belajar
0. [FreeBSD Handbook](https://docs.freebsd.org/en/books/handbook/network-servers/#network-apache)(https://docs.freebsd.org/en/books/handbook/network-servers/#network-apache)
1. [FAMP | Belajar FreeBSD repo Indonesia](http://repo.belajarfreebsd.or.id/Ebook/FAMP)(http://repo.belajarfreebsd.or.id/Ebook/FAMP%20(FreeBSD-Apache-MariaDB-PHP).pdf)
2. [ FAMP + phpMyAdmin ](https://www.zenarmor.com/docs/freebsd-tutorials/how-to-install-apache-mysql-php-and-phpmyadmin-on-freebsd)(https://www.zenarmor.com/docs/freebsd-tutorials/how-to-install-apache-mysql-php-and-phpmyadmin-on-freebsd)