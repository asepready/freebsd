# Layanan DataBase Management System (DBMS)
## Install Paket
```sh
pkg install mariadb104-server phpMyAdmin-php80
chmod -R 777 /var/lib/phpmyadmin/tmp
```

## Enable Start Boot
```sh
sysrc mysql_enable="YES"
#run service
service mysql-server start
```
