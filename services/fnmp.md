<p align="center">
<img src="/assets/images/logo.png" alt="Logo" style="width:200px;"/>
<h1>FNMP</h1>
<h1>FreeBSD.Nginx.MariaDB.PHP</h1>
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
├── nginx-1.20.md
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
#### Cek paket terinstall melalui pkg
```sh
pkg search php74 | grep gd
pkg search php74 | egrep -i --color 'gd|mysqli|openssl'
pkg search php74 | egrep --color -i -- '-(gd|mysqli|openssl|memcached|opcache|json|mbstring|imagick|xml|zip|composer|igbinary)-'
```

#### Install phpMyAdmin-php74
```sh
pkg ins php74-composer php74-gd php74-mysqli php74-json php74-mbstring php74-session php74-hash php74-extensions
pkg ins phpMyAdmin-php74
```
2. Salin file config.sample.inc.php menjadi config.inc.php pada /usr/local/www/phpMyAdmin
```sh
cd /usr/local/www/phpMyAdmin/
cp /usr/local/www/phpMyAdmin/config{.sample,}.inc.php
```
edit baris pada /usr/local/www/phpMyAdmin/config.inc.php
```sh
$cfg['blowfish_secret'] = ''
# menjadi
$cfg['blowfish_secret'] = 'Ey0r*h!5g#oNf5WvkosW)*H$jasn%$!1'
```
3. Buat simbolik link
```sh
ln -s /usr/local/www/phpMyAdmin/ /usr/local/www/nginx-dist/phpmyadmin
```
