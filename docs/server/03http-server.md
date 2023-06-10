# Layanan HTTP
## Install Paket Apache dan PHP5
```sh
apt-get install php5 apache2
```
# 1. Konfigurasi Apache2
```sh file
#/etc/apache2/sites-available/abcnet
<VirtualHost *:80>
    ServerAdmin info@abcnet-1.id
    ServerName abcnet-1.id
    ServerAlias www.abcnet-1.id
    Alias /webmail /var/lib/roundcube
    DocumentRoot /home/sysadmin/web/
    
    <Directory /home/sysadmin/web/>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Order allow,deny
        allow from all
    </Directory>
    
    CustomLog "|cronolog /home/sysadmin/log/%Y/%m/%d-%m-%Y-access.log" combined
    ErrorLog "|cronolog /home/sysadmin/log/%Y/%m/%d-%m-%Y-error.log"
</VirtualHost>
```
enable/disable
```sh
#disable
a2dissite default
#enable
a2ensite abcnet
```


