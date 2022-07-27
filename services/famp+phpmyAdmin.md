<p align="center">
<img src="/assets/images/logo.png" alt="Logo" style="width:200px;"/>
<h1>FAMP + phpMyAdmin</h1>
<h1>FreeBSD.Apache24.Mysql57.PHP74 + phpMyAdmin-PHP74</h1>
</p>

## Catatan hasil belajar FreeBSD support versi =>11.* sebagai Server

#### Install Paket yang di butuhkan
### 1. Apache24
```sh
pkg ins apache24
sysrc apache24_enable="YES"
```
### 2. MySql57
```sh
pkg ins mysql57-server mysql57-client
sysrc mysql_enable="YES"
```
### 3. PHP74
```sh
pkg ins php74 php74-mysqli php74-extensions mod_php74
sysrc php_fpm_enable="YES"
```
### 4. phpMyAdmin-PHP74
```sh
pkg ins phpMyAdmin-php74
```
1. Salin file /usr/local/www/phpMyAdmin/config.sample.inc.php menjadi config.inc.php
```sh
cp /usr/local/www/phpMyAdmin/config.sample.inc.php /usr/local/www/phpMyAdmin/config.inc.php
```
2. Edit file /usr/local/www/phpMyAdmin/config.inc.php
```sh
edit /usr/local/www/phpMyAdmin/config.inc.php
```
```sh
$cfg['blowfish_secret'] = ''
# tambahan kunci sacara acak yang susah ditebak
$cfg['blowfish_secret'] = 'Ey0r*h!5g#oNf5WvkosW)*H$jasn%$!1'
```

#### Sumber belajar
0. [FreeBSD Handbook](https://docs.freebsd.org/en/books/handbook/network-servers/#network-apache)(https://docs.freebsd.org/en/books/handbook/network-servers/#network-apache)
1. [FAMP | Belajar FreeBSD repo Indonesia](http://repo.belajarfreebsd.or.id/Ebook/FAMP)(http://repo.belajarfreebsd.or.id/Ebook/FAMP%20(FreeBSD-Apache-MariaDB-PHP).pdf)
