```sh
# Virtual Hosts
#
# Required modules: mod_log_config

<VirtualHost *:80>
	ServerAdmin webmaster@localhost
	ServerName belajarbsd.id
	ServerAlias www.belajarbsd.id
	#Alias /webmail /var/lib/roundcube
	DocumentRoot "/usr/local/www/faztrain"
	<Directory />
		Options FollowSymLinks
		AllowOverride None
	</Directory>
	<Directory "/usr/local/www/faztrain">
		Options Indexes FollowSymLinks MultiViews
		AllowOverride None
		Order allow,deny
		allow from all
	</Directory>

	ScriptAlias /cgi-bin/ "/usr/local/www/apache24/cgi-bin/"
	<Directory "/usr/local/www/apache24/cgi-bin">
		AllowOverride None
		Options None
		Require all granted
	</Directory>

	ErrorLog "/var/log/httpd-error.log"
	
        LogLevel warn
	CustomLog "/var/log/httpd-access.log" combined
</VirtualHost>

<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        ServerName google.com
        ServerAlias www.google.com
        DocumentRoot "/usr/local/www/google/"
        <Directory />
                Options FollowSymLinks
                AllowOverride None
        </Directory>
        <Directory "/usr/local/www/google/">
                Options Indexes FollowSymLinks MultiViews
                AllowOverride None
                Order allow,deny
                allow from all
        </Directory>
</VirtualHost>

<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        ServerName facebook.com 
        ServerAlias www.facebook.com 
        DocumentRoot "/usr/local/www/facebook/"
        <Directory />
                Options FollowSymLinks
                AllowOverride None
        </Directory>
        <Directory "/usr/local/www/facebook/">
                Options Indexes FollowSymLinks MultiViews
                AllowOverride None
                Order allow,deny
                allow from all
        </Directory>
</VirtualHost>

<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        ServerName msftncsi.com 
        ServerAlias www.msftncsi.com 
        DocumentRoot "/usr/local/www/msftncsi/"
        <Directory />
                Options FollowSymLinks
                AllowOverride None
        </Directory>
        <Directory "/usr/local/www/msftncsi/">
                Options Indexes FollowSymLinks MultiViews
                AllowOverride None
                Order allow,deny
                allow from all
        </Directory>
</VirtualHost>

<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        ServerName msftconnecttest.com 
        ServerAlias www.msftconnecttest.com 
        DocumentRoot "/usr/local/www/msftconnecttest/"
        <Directory />
                Options FollowSymLinks
                AllowOverride None
        </Directory>
        <Directory "/usr/local/www/msftconnecttest/">
                Options Indexes FollowSymLinks MultiViews
                AllowOverride None
                Order allow,deny
                allow from all
        </Directory>
</VirtualHost>

<VirtualHost *:80>
	ServerName pkg.belajarbsd.id
	DocumentRoot "/usr/local/www/FreeBSD:13:i386/"
</VirtualHost>

<VirtualHost *:80>
        ServerName speedtest.belajarbsd.id  
        DocumentRoot "/usr/local/www/speedtest/"
</VirtualHost>

<VirtualHost *:80>
        ServerName dns.belajarbsd.id
        DocumentRoot "/usr/local/www/dns/"
</VirtualHost>

<VirtualHost *:80>
        ServerName cli.belajarbsd.id
        DocumentRoot "/usr/local/www/cli/"
</VirtualHost>