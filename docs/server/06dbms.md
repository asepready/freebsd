# Layanan DataBase Management System (DBMS)
## Install Paket
https://obsigna.com/articles/1539726598.html
```sh
pkg install mariadb105-server phpMyAdmin-php80
chmod -R 777 /var/lib/phpmyadmin/tmp
```

## Enable Start Boot
```sh
sysrc mysql_enable="YES"
#run service
service mysql-server start
```
