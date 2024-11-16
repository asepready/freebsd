Apache httpd : Enable Userdir

Enable userdir. Users can create websites under their own home directory by this setting.

[1]	Enable UserDir setting.
```sh
root@www:~ # vi /usr/local/etc/apache24/httpd.conf
# line 179 : uncomment
sed -i -e '/mod_userdir.so/s/#LoadModule/LoadModule/' /usr/local/etc/apache24/httpd.conf
# line 503 : uncomment
sed -i -e '/httpd-userdir.conf/s/#Include/Include/' /usr/local/etc/apache24/httpd.conf
root@www:~ # ee /usr/local/etc/apache24/extra/httpd-userdir.conf
# line 18-22
<Directory "/home/*/public">
    AllowOverride All     # change if you need
    Options None          # change if you need
    Require method GET POST OPTIONS
</Directory>

root@www:~ # service apache24 reload
```
[2]	Create a test page with a user and access to it from any client computer with Web browser.
```sh
sysadmin@www:~ $ mkdir /home/sysadmin/public
sysadmin@www:~ $ chmod 711 /home/sysadmin
sysadmin@www:~ $ chmod 755 /home/sysadmin/public
sysadmin@www:~ $ cat << EOF > /home/sysadmin/public/index.html
<html>
<body>
<div style="width: 100%; font-size: 40px; font-weight: bold; text-align: center;">
UserDir Test Page
</div>
</body>
</html>
EOF