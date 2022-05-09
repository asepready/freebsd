<p align="center">
<img src="/assets/images/logo.png" alt="Logo" style="width:200px;"/>
<h1>FAMP</h1>
<h1>FreeBSD.Apache.MariaDB.PHP</h1>
</p>

## Catatan hasil belajar FreeBSD support versi =>11.* sebagai Server

#### Cari bahan pembelajaran di direktori
```sh
# 1 Repo
belajar-freebsd/docs/000pkg/
├── pkg-offline.md
└── pkg-online.md

# 2 Install paket FAMP
belajar-freebsd/docs/fbsd11/services/01http/
├── apache24.md
└── README.md
belajar-freebsd/docs/fbsd11/services/13program-language/
├── php74.md
└── README.md
belajar-freebsd/docs/fbsd11/services/14dbms/
├── mariadb103.md
└── README.md

# 3 konfigurasi apache24
belajar-freebsd/services/fbsd11/01http/apache24/
├── etc
│   └── rc.conf
├── README.md
└── usr
    └── local
        └── etc
            └── apache24
                └── httpd.conf

# 4 Konfigurasi hostname dan hosts
belajar-freebsd/configs/hosts/
├── etc
│   ├── hosts
│   └── rc.conf
└── README.md

# 5 Konfigurasi php74 dan apache24
belajar-freebsd/services/fbsd11/13program-language/php74/apache24/
└── usr
    └── local
        ├── etc
        │   ├── apache24
        │   │   └── httpd.conf
        │   └── php.ini
        └── www
            └── apache24
                └── data
                    └── phpinfo.php

# 6 Konfigurasi mariadb103-server
belajar-freebsd/services/fbsd11/14dbms/mariadb103/
├── etc
│   └── rc.conf
├── README0.md
└── usr
    └── local
        └── etc
            └── my.cnf
```
#### Install phpMyAdmin-php74
```sh
pkg ins phpMyAdmin-php74
```
1. buka file /usr/local/etc/apache24/httpd.conf dan edit:
  ```sh
  ee /usr/local/etc/apache24/httpd.conf
  ```

  ```sh
  Include etc/apache24/Includes/*.conf

  Alias /phpmyadmin/ "/usr/local/www/phpMyAdmin/"

  <Directory "/usr/local/www/phpMyAdmin/">
  Options None
  AllowOverride Limit

  Require local
    Require host webserverbsd.net
  </Directory>
  ```
2. Salin file /usr/local/www/phpMyAdmin/config.sample.inc.php menjadi config.inc.php
```sh
cp /usr/local/www/phpMyAdmin/config.sample.inc.php /usr/local/www/phpMyAdmin/config.inc.php
```
3. Edit file /usr/local/www/phpMyAdmin/config.inc.php
```sh
ee /usr/local/www/phpMyAdmin/config.inc.php
```
```sh
$cfg['blowfish_secret'] = ''
# tambahan kunci sacara acak yang susah ditebak
$cfg['blowfish_secret'] = 'Ey0r*h!5g#oNf5WvkosW)*H$jasn%$!1'
```

#### Sumber belajar
0. [FreeBSD Handbook](https://docs.freebsd.org/en/books/handbook/network-servers/#network-apache)(https://docs.freebsd.org/en/books/handbook/network-servers/#network-apache)
1. [FAMP | Belajar FreeBSD repo Indonesia](http://repo.belajarfreebsd.or.id/Ebook/FAMP)(http://repo.belajarfreebsd.or.id/Ebook/FAMP%20(FreeBSD-Apache-MariaDB-PHP).pdf)
