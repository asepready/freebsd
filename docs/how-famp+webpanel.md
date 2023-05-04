<p align="center">
<img src="./../assets/images/logo.png" alt="Logo" style="width:200px;"/>
<h1>FAMP + phpMyAdmin</h1>
<h1>FreeBSD.Apache24.Mysql57.PHP82 + phpMyAdmin-PHP82</h1>
</p>

## Catatan hasil belajar FreeBSD support versi =>11.* sebagai Server
===> Buat Apache & phpMyAdmin.secara default user & group 'www'.
```sh
service apache24 start
service mysql-server start
service php-fpm start
```

### Install Paket yang di butuhkan
```sh
pkg ins apache24 mysql57-{server,client} php82 php82-{mysqli,extensions} mod_php82 phpMyAdmin-php82 
```

### Lakukan Konfigurasi
1. Lakukan Konfigurasi di /etc/rc.conf dan jalan service
    ```sh term
    sysrc apache24_enable="YES"
    sysrc mysql_enable="YES"
    sysrc php_fpm_enable="YES"

    #run service
    service apache24 start
    service mysql-server start
    service php-fpm start
    ```
2. Konfigurasi Apache
    /etc/apache24/modules.d/000_mod-php.conf
    ```conf
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

    Ketika sudah menambahn atau konfigurasi lakukan konfirmasi dengan:
    ```sh term
    apachectl configtest
    apachectl restart
    ```
3. Konfigurasi MySql
    ```sh
    #jika diperlukan
    mysql_secure_installation
    ```
4. Salin file /usr/local/www/phpMyAdmin/config.sample.inc.php menjadi config.inc.php
    ```sh
    cp /usr/local/www/phpMyAdmin/config.sample.inc.php /usr/local/www/phpMyAdmin/config.inc.php
    ln -s /usr/local/www/phpMyAdmin /
    ```
5. Edit file /usr/local/www/phpMyAdmin/config.inc.php
    ```sh
    #/usr/local/www/phpMyAdmin/config.inc.php
    $cfg['blowfish_secret'] = ''
    # tambahan kunci sacara acak yang susah ditebak
    $cfg['blowfish_secret'] = 'Ey0r*h!5g#oNf5WvkosW)*H$jasn%$!1'
    ```

#### Sumber belajar
0. [FreeBSD Handbook](https://docs.freebsd.org/en/books/handbook/network-servers/#network-apache)(https://docs.freebsd.org/en/books/handbook/network-servers/#network-apache)
1. [FAMP | Belajar FreeBSD repo Indonesia](http://repo.belajarfreebsd.or.id/Ebook/FAMP)(http://repo.belajarfreebsd.or.id/Ebook/FAMP%20(FreeBSD-Apache-MariaDB-PHP).pdf)
