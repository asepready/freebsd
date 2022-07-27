1. Apache24 on Start up(aktifkan ketika memulai boot)
```sh
sysrc apache24_enable="YES"
#sysrc apache24_http_accept_enable="YES"
```
atau buka /etc/rc.conf dan edit:
```sh
edit /etc/rc.conf
```
```sh
#/etc/rc.conf
#Apache24
apache24_enable="YES"
#apache24_http_accept_enable=”YES”
```
2. Buka dan Edit file di /usr/local/etc/apache24/httpd.conf
```sh
edit /usr/local/etc/apache24/httpd.conf
```
```sh
#ServerName www.example.com:80
ServerName www.example.com:80
```
3. Menjalankan Apache24 Service & Status
```sh
service apache24 start
```
