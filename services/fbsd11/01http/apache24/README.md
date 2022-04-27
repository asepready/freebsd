1. Apache24 on Start up(aktifkan ketika memulai boot)
```sh
sysrc apache24_enable=yes
sysrc apache24_http_accept_enable=yes
```
atau buka /etc/rc.conf dan edit:
```sh
ee /etc/rc.conf
```
```sh
#/etc/rc.conf
#Apache24
apache24_enable=”YES”
#apache24_http_accept_enable=”YES”
```
2. Buka dan Edit file di /usr/local/etc/apache24/httpd.conf
```sh
ee /usr/local/etc/apache24/httpd.conf
```
```sh
#
# ServerAdmin: Your address, where problems with the server should be
# e-mailed.  This address appears on some server-generated pages, such
# as error documents.  e.g. admin@your-domain.com
#
ServerAdmin you@example.com

#
# ServerName gives the name and port that the server uses to identify itself.
# This can often be determined automatically, but we recommend you specify
# it explicitly to prevent problems during startup.
#
# If your host doesn't have a registered DNS name, enter its IP address here.
#
ServerName webserverbsd.net:80
```
3. Menjalankan Apache24 Service & Status
```sh
service apache24 start
```
