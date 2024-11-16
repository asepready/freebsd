Apache httpd : Install
 	
Install Apache httpd to configure Web Server.

[1]	Install Apache httpd.
```sh
root@www:~ # pkg install -y apache24
```
[2]	Configure httpd. Replace Server name to your own environment.
```sh
root@www:~ # ee /usr/local/etc/apache24/httpd.conf
# line 217 : change to admin email address
# sed -i -e 's/ServerAdmin you@example.com/ServerAdmin admin@belajarfreebsd.or.id/g' /usr/local/etc/apache24/httpd.conf
ServerAdmin admin@belajarfreebsd.or.id
# line 226 : change to your server's name
# sed -i -e 's/#ServerName www.example.com:80/ServerName belajarfreebsd.or.id:80/g' /usr/local/etc/apache24/httpd.conf
ServerName belajarfreebsd.or.id:80
# line 264 : change (remove [Indexes])
Options FollowSymLinks
# line 271 : change
AllowOverride All
# line 287 : add follows if you need
# file names that it can access only with directory name
DirectoryIndex index.html index.php index.cgi
# line 334 : comment out to switch to combined log
#CustomLog "/var/log/httpd-access.log" common
# line 340 : uncomment to switch to combined log
CustomLog "/var/log/httpd-access.log" combined
# line 518 : uncomment to switch
Include etc/apache24/extra/httpd-default.conf
root@www:~ # ee /usr/local/etc/apache24/extra/httpd-default.conf
# line 55 : change (server response header)
ServerTokens Prod
root@www:~ # sysrc apache24_enable="YES"
apache24_enable:  -> YES
root@www:~ # service apache24 start
Performing sanity check on apache24 configuration:
Syntax OK
Starting apache24.
```
[3]	Create a HTML test page and access to it from any client computer with web browser. It's OK if following page is shown.
```html
root@www:~ # vi /usr/local/www/apache24/data/index.html
<html>
<body>
<div style="width: 100%; font-size: 40px; font-weight: bold; text-align: center;">
Test Page
</div>
</body>
</html>
``
Check 