1. Mariadb103 on Start up(aktifkan ketika memulai boot)
```sh
sysrc mysql_enable=yes
```
atau buka /etc/rc.conf dan edit:
```sh
ee /etc/rc.conf
```
```sh
#MariaDB
mysql_enable="YES"
```
2. Salin file my-small.cnf di /usr/local/share/mysql/my-small.cnf menjadi salinan my.cnf
```sh
cp /usr/local/etc/my.cnf{.sample}
```
3. Menjalankan MariaDB Service & Status
```sh
service mysql-server start
sockstat -4 -l
```
4. Pertama kali untuk buat root password MariaDB
```sh
mysqladmin -u root password ‘passwordanda’
```
6. Pertama kali untuk masuk ke sistem MariaDB
```sh
mysql -u root -p
```
