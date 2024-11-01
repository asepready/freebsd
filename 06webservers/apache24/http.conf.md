# Layanan HTTP
## Install Paket Apache dan PHP5
```sh
pkg install apache24 php82 php82-{mysqli,extensions}
```
## Enable Start Boot
```sh
sysrc apache24_enable="YES" #or
service apache24 enable


#run service
service apache24 start
```
## 1. Konfigurasi Apache2
```sh file
#/usr/local/etc/apache24/httpd.conf
LoadModule vhost_alias_module libexec/apache24/mod_vhost_alias.so

ServerAdmin info@belajarbsd.id
ServerName www.belajarbsd.id:80

DocumentRoot "/home/sysadmin/www"
<Directory "/home/sysadmin/www">
    Options Indexes FollowSymLinks MultiViews
    AllowOverride All
    #Require all granted
</Directory>

# Virtual hosts
Include etc/apache24/extra/httpd-vhosts.conf

#====================================================================
#/usr/local/etc/apache24/extra/httpd-vhosts.conf
<VirtualHost *:80>
    ServerName pkg.asepready.id
    ServerAlias pkg.asepready.id
    DocumentRoot "/home/sysadmin/www"
</VirtualHost>
```
apache test
```sh
apachectl configtest
apachectl restart
```

## 2. Konfigurasi PHP
```sh
#/usr/local/www/info.php
<?php phpinfo(); ?>

#/usr/local/etc/php-fpm.d/www
listen = /var/run/php-fpm.sock
listen.owner = www
listen.group = www
listen.mode = 0660

#/usr/local/etc/apache24/httpd.conf
LoadModule proxy_module libexec/apache24/mod_proxy.so
LoadModule proxy_fcgi_module libexec/apache24/mod_proxy_fcgi.so

<IfModule dir_module>
    DirectoryIndex index.php index.html
</IfModule>

<FilesMatch \.php$>
    SetHandler "proxy:unix:/var/run/php-fpm.sock|fcgi://localhost"
</FilesMatch>

```
```sh
cp /usr/local/etc/php.ini-production /usr/local/etc/php.ini
rehash
sysrc php_fpm_enable="YES"
service php-fpm start
apachectl restart
```

## 3. Konfigurasi SSL
```sh
# Genarate rootCA
mkdir -p /usr/local/etc/ssl/certs/
mkdir -p /usr/local/etc/ssl/private/
openssl genrsa -out /usr/local/etc/ssl/private/rootCA.key 2048
openssl req -x509 -new -nodes -key /usr/local/etc/ssl/private/rootCA.key -sha256 -days 1024 -out /usr/local/etc/ssl/certs/rootCA.pem -batch -subj '/C=ID/L=Bangka Belitung/O=BABEL/OU=BABEL/CN=admin'

# Genarate Apache
mkdir -p /usr/local/etc/apache24/ssl/certs/
mkdir -p /usr/local/etc/apache24//ssl/private/
openssl genrsa -out /usr/local/etc/apache24/ssl/private/lab.fbsd.key 2048
openssl req -new -key /usr/local/etc/apache24/ssl/private/lab.fbsd.key -out /usr/local/etc/apache24/ssl/private/lab.fbsd.csr -batch -subj '/C=ID/L=Bangka Belitung/O=BABEL/OU=BABEL/CN=app.lab.fbsd'

cat << EOF >> /usr/local/etc/apache24/ssl/certs/v3.ext
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = *.lab.fbsd
EOF

openssl x509 -req -in /usr/local/etc/apache24/ssl/private/lab.fbsd.csr -CA /usr/local/etc/ssl/certs/rootCA.pem -CAkey /usr/local/etc/ssl/private/rootCA.key -CAcreateserial -out /usr/local/etc/apache24/ssl/certs/lab.fbsd.crt -days 500 -sha256 -extfile /usr/local/etc/apache24/ssl/certs/v3.ext
```

## Module Apache
```sh
cat /usr/local/etc/apache24/httpd.conf | nl -ba | grep mod_ssl

147 #LoadModule ssl_module libexec/apache24/mod_ssl.so
529 # but a statically compiled-in mod_ssl.

ee +147 /usr/local/etc/apache24/httpd.conf

cat httpd.conf | nl -ba | grep httpd-vhosts.conf

509	#Include etc/apache24/extra/httpd-vhosts.conf

ee +508 httpd.conf

cat << EOF >> /usr/local/etc/apache24/modules.d/020_mod_ssl.conf
Listen 443
SSLProtocol ALL -SSLv2 -SSLv3
SSLCipherSuite HIGH:MEDIUM:!aNULL:!MD5
SSLPassPhraseDialog builtin
SSLSessionCacheTimeout 300
EOF

# Virtual Hosts
cat << EOF >> /usr/local/etc/apache24/extra/httpd-vhosts.conf
<VirtualHost *:80>
    ServerAdmin webmaster@dummy-host.example.com
    DocumentRoot "/usr/local/docs/dummy-host.example.com"
    ServerName dummy-host.example.com
    ServerAlias www.dummy-host.example.com
    ErrorLog "/var/log/dummy-host.example.com-error_log"
    CustomLog "/var/log/dummy-host.example.com-access_log" common
</VirtualHost>

<VirtualHost *:80>
    ServerAdmin webmaster@dummy-host2.example.com
    DocumentRoot "/usr/local/docs/dummy-host2.example.com"
    ServerName dummy-host2.example.com
    ErrorLog "/var/log/dummy-host2.example.com-error_log"
    CustomLog "/var/log/dummy-host2.example.com-access_log" common
</VirtualHost>


<VirtualHost *:443>
    ServerAdmin webmaster@dummy-host.example.com
    DocumentRoot "/usr/local/www/apache24/data/"
    ServerName localhost
    ServerAlias 192.168.122.142
    SSLEngine on
    SSLCertificateFile "/usr/local/etc/apache24/ss/cert.crt"
    SSLCertificateKeyFile "/usr/local/etc/apache24/ssl/cert.key"
    ErrorLog "/var/log/wptest-error_log"
    CustomLog "/var/log/wptest-access_log" common
</VirtualHost>
EOF

apachectl configtest
```sh
# Cara Pertama :
cp rootCA.pem /usr/local/etc/ssl/certs/
certctl rehash

# Cara Kedua :
cp rootCA.pem /usr/local/etc/ssl/certs/
chmod 0644 /etc/ssl/certs/rootCA.pem
openssl x508 -noout -hash -in /etc/ssl/certs/rootCA.pem
cd /etc/ssl/certs
ln -s rootCA.pem $(openssl x508 -noout -hash -in /etc/ssl/certs/rootCA.pem)

# Test 
openssl s_client -connect fqdn:443 | grep -i -e verify
```

