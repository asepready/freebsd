## Dasar Konfigurasi
1. Nginx on Start up(aktifkan ketika memulai boot)
```sh
sysrc nginx_enable=yes
```
atau buka /etc/rc.conf dan edit:
```sh
ee /etc/rc.conf
```
```sh
#Nginx
nginx_enable="YES"
```
2. Buka dan Edit file di /usr/local/etc/nginx/nginx.conf
```sh
ee /usr/local/etc/nginx/nginx.conf
```
```sh
```
3. Menjalankan Apache24 Service & Status
```sh
service nginx start
```
