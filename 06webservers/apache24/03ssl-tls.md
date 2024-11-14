Apache httpd : SSL/TLS Setting2024/01/30
 	
Configure SSL/TLS setting to use secure encrypt HTTPS connection.

[1]	Get SSL Certificate, refer to here.
```sh
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /usr/local/etc/apache24/server.key -out /usr/local/etc/apache24/server.crt -subj "/C=ID/ST=Bangka Belitung/L=Pangkalpinang/O=belajarfreebsd.or.id/CN=belajarfreebsd.or.id/emailAddress=admin@belajarfreebsd.or.id"
```
[2]	Enable SSL/TLS settings.
```sh
root@www:~ # vi /usr/local/etc/apache24/httpd.conf
# 4.4- Enable TLS session cache.
# line 92 : uncomment
sed -i -e '/mod_socache_shmcb.so/s/#LoadModule/LoadModule/' /usr/local/etc/apache24/httpd.conf

# line 148 : uncomment
sed -i -e '/mod_ssl.so/s/#LoadModule/LoadModule/' /usr/local/etc/apache24/httpd.conf

# line 181 : uncomment
# 4.6- Redirect HTTP connections to HTTPS (port 80 and 443 respectively)
# 4.6.1- Enabling the rewrite module
sed -i -e '/mod_rewrite.so/s/#LoadModule/LoadModule/' /usr/local/etc/apache24/httpd.conf

# 4.4- Enable the server's default TLS configuration to be applied.
# line 526 : uncomment
sed -i -e '/httpd-ssl.conf/s/#Include/Include/' /usr/local/etc/apache24/httpd.conf

root@www:~ # vi /usr/local/etc/apache24/extra/httpd-ssl.conf
# line 125, 126 : change to your server name and admin email
DocumentRoot "/usr/local/www/apache24/data"
ServerName www.srv.world:443
ServerAdmin root@srv.world
ErrorLog "/var/log/httpd-error.log"
TransferLog "/var/log/httpd-access.log"
# line 144 : change to the certificate you got in [1]
SSLCertificateFile "/usr/local/etc/letsencrypt/live/www.srv.world/cert.pem"
# line 154 : change to the certificate you got in [1]
SSLCertificateKeyFile "/usr/local/etc/letsencrypt/live/www.srv.world/privkey.pem"
# line 165 : uncomment and change to the certificate you got in [1]
SSLCertificateChainFile "/usr/local/etc/letsencrypt/live/www.srv.world/chain.pem"
root@www:~ # service apache24 reload
```
[3]	If you'd like to set HTTP connection to redirect to HTTPS (Always on SSL/TLS), Set RewriteRule to each Host settings.
For example, if you set Virtual Hostings like the link here, Add RewriteRule like follows. Or It's possible to set RewriteRule in [.htaccess] not in [httpd.conf].
root@www:~ # vi /usr/local/etc/apache24/httpd.conf
# line 181 : uncomment
LoadModule rewrite_module libexec/apache24/mod_rewrite.so
root@www:~ # vi /usr/local/etc/apache24/Includes/vhost.conf
<VirtualHost *:80>
    DocumentRoot /usr/local/www/apache24/data
    ServerName www.srv.world
    # add RewriteRule
    RewriteEngine On
    RewriteCond %{HTTPS} off
    RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [R=301,L]
</VirtualHost>

root@www:~ # service apache24 reload