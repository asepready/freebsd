Apache httpd : Virtual Hostings
 	
Configure Virtual Hostings to use multiple domain names.

[1]	For example, Add a new Host setting that domain name is [virtual.host], document root is [/usr/local/www/apache24/virtual.host].
```sh
root@www:~ # ee /usr/local/etc/apache24/httpd.conf
# line 526 : Uncomment
# sed -i -e '/httpd-vhosts.conf/s/#Include/Include/' /usr/local/etc/apache24/httpd.conf
Include etc/apache24/extra/httpd-vhosts.conf
root@www:~ # ee /usr/local/etc/apache24/extra/httpd-vhosts.conf
# create new
# settings for original domain
<VirtualHost *:80>
    DocumentRoot /usr/local/www/apache24/data
    ServerName www.belajarfreebsd.or.id
</VirtualHost>

# settings for new domain
<VirtualHost *:80>
	DocumentRoot "/usr/local/www/repos"
    ServerName pkg.belajarfreebsd.or.id
</VirtualHost>

<Directory "/usr/local/www">
    Options FollowSymLinks
    AllowOverride All
    Require all granted
</Directory>

root@www:~ # service apache24 reload
```
[2]	Create a test page and access to it from any client computer with web browser. It's OK if following page is shown.
```sh
root@www:~ # cat << EOF > /usr/local/www/repos/index.html
<html>
<body>
<div style="width: 100%; font-size: 40px; font-weight: bold; text-align: center;">
Virtual Host Repos Page
</div>
</body>
</html>
EOF