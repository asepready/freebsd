Apache httpd : Use CGI Scripts
 	
Use CGI (Common Gateway Interface) Scripts.

[1]	By default, CGI is allowed under the [/usr/local/www/apache24/cgi-bin] directory.
It's possible to use CGI Scripts to put under the directory. All files under it are processed as CGI.
```sh
root@www:~ # vi /usr/local/etc/apache24/httpd.conf
# line 166 : uncomment below if httpd is running in except [prefork] mode
sed -i -e '/mod_cgid.so/s/#LoadModule/LoadModule/' /usr/local/etc/apache24/httpd.conf
# line 169 : uncomment below if httpd is running in [prefork] mode
sed -i -e '/mod_cgi.so/s/LoadModule/#LoadModule/' /usr/local/etc/apache24/httpd.conf

# line 367 : CGI is allowed under the directory
ScriptAlias /cgi-bin/ "/usr/local/www/apache24/cgi-bin/"

root@www:~ # service apache24 reload
# verify working to create test script
# any languages are OK for CGI scripts (example below is Perl)
root@www:~ # cat > /usr/local/www/apache24/cgi-bin/index.cgi <<'EOF'
#!/usr/local/bin/perl
print "Content-type: text/html\n\n";
print "CGI Script Test Page\n";
EOF
root@www:~ # chmod 755 /usr/local/www/apache24/cgi-bin/index.cgi
root@www:~ # curl localhost/cgi-bin/index.cgi
CGI Script Test Page
```
[2]	If you like to allow CGI in other directories, configure like follows.
For example, allow in [/usr/local/www/apache24/data/cgi-enabled].
```sh
root@www:~ # ee /usr/local/etc/apache24/extra/httpd-vhosts.conf
# create new
# specify extension that are processed as CGI on [AddHandler cgi-script] line
<VirtualHost *:80>
    ServerName www.belajarfreebsd.or.id
    DocumentRoot "/usr/local/www/apache24/data"
    RewriteEngine On
    RewriteCond %{HTTPS} !=on
    RewriteRule ^/?(.*) https://%{SERVER_NAME}/$1 [R,L]
	# add
    <Directory "/usr/local/www/apache24/cgi-bin">
        Options +ExecCGI
        AddHandler cgi-script .cgi .pl .py .rb
    </Directory>
</VirtualHost>

root@www:~ # ee /usr/local/etc/apache24/extra/httpd-ssl.conf
    .....
	# add
    <Directory "/usr/local/www/apache24/cgi-bin">
        Options +ExecCGI
        AddHandler cgi-script .cgi .pl .py .rb
    </Directory>
</VirtualHost>
root@www:~ # service apache24 reload
```
[3]	Create a CGI test page and access to it from any client computer with web browser.
```sh
root@www:~ # cat << EOF > /usr/local/www/apache24/cgi-bin/index.cgi
#!/usr/local/bin/perl
print "Content-type: text/html\n\n";
print "<html>\n<body>\n";
print "<div style=\"width: 100%; font-size: 40px; font-weight: bold; text-align: center;\">\n";
print "CGI Script Test Page\n";
print "</div>\n";
print "</body>\n</html>\n";
EOF

root@www:~ # chmod 755 /usr/local/www/apache24/cgi-bin/index.cgi
```