Apache httpd : SSL/TLS Setting
 	
Configure SSL/TLS setting to use secure encrypt HTTPS connection.

[1]	Get SSL Certificate, refer to here.
```sh
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /usr/local/etc/apache24/server.key -out /usr/local/etc/apache24/server.crt -subj "/C=ID/ST=Bangka Belitung/L=Pangkalpinang/O=belajarfreebsd.or.id/CN=belajarfreebsd.or.id/emailAddress=admin@belajarfreebsd.or.id"
```
[2]	Enable SSL/TLS settings.
```sh
# Enable TLS session cache.
# line 92 : uncomment
sed -i -e '/mod_socache_shmcb.so/s/#LoadModule/LoadModule/' /usr/local/etc/apache24/httpd.conf
# line 148 : uncomment
sed -i -e '/mod_ssl.so/s/#LoadModule/LoadModule/' /usr/local/etc/apache24/httpd.conf

# Enable the server's default TLS configuration to be applied.
# line 526 : uncomment
sed -i -e '/httpd-ssl.conf/s/#Include/Include/' /usr/local/etc/apache24/httpd.conf
# line 125, 126 : change to your server name and admin email
sed -i -e 's/ServerName  www.example.com:443/ServerName belajarfreebsd.or.id:443/g' /usr/local/etc/apache24/extra/httpd-ssl.conf
sed -i -e 's/ServerAdmin you@example.com/ServerAdmin admin@belajarfreebsd.or.id/g' /usr/local/etc/apache24/extra/httpd-ssl.conf
# line 144 : change to the certificate you got in [1]
SSLCertificateFile "/usr/local/etc/apache24/server.crt"
# line 154 : change to the certificate you got in [1]
SSLCertificateKeyFile "/usr/local/etc/apache24/server.key"
# line 165 : uncomment and change to the certificate you got in [1]
SSLCertificateChainFile "/usr/local/etc/apache24/server-ca.crt"

root@www:~ # service apache24 reload
```
[3]	If you'd like to set HTTP connection to redirect to HTTPS (Always on SSL/TLS), Set RewriteRule to each Host settings.
For example, if you set Virtual Hostings like the link here, Add RewriteRule like follows. Or It's possible to set RewriteRule in [.htaccess] not in [httpd.conf].
```sh
root@www:~ # ee /usr/local/etc/apache24/httpd.conf
# line 181 : uncomment
# Enabling the rewrite module
sed -i -e '/mod_rewrite.so/s/#LoadModule/LoadModule/' /usr/local/etc/apache24/httpd.conf

root@www:~ # ee /usr/local/etc/apache24/extra/httpd-vhosts.conf
<VirtualHost *:80>
    DocumentRoot /usr/local/www/apache24/data
    ServerName www.belajarfreebsd.or.id
    # add RewriteRule
    RewriteEngine On
    RewriteCond %{HTTPS} !=on
    RewriteRule ^/?(.*) https://%{SERVER_NAME}/$1 [R,L]
</VirtualHost>
root@www:~ # service apache24 reload
```