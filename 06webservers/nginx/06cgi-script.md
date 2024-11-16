Nginx : Use CGI Scripts
 	
Configure CGI executable Environment on Nginx.

[1]	Install FastCGI Wrap and Configure Nginx for it.
```sh
root@www:~# pkg install -y fcgiwrap
root@www:~# vi /usr/local/etc/nginx/nginx.conf
# add follows in the [server] section
# for example, enable CGI under the location [/cgi-bin]
    server {
        .....
        .....
        location /cgi-bin/ {
            gzip off;
            root  /usr/local/www;
            fastcgi_pass  unix:/var/run/fcgiwrap/fcgiwrap.sock;
            include /usr/local/etc/nginx/fastcgi_params;
            fastcgi_param SCRIPT_FILENAME  $document_root$fastcgi_script_name;
        }

root@www:~# mkdir /usr/local/www/cgi-bin
root@www:~# chmod 755 /var/www/cgi-bin
root@www:~# service nginx reload
root@www:~# sysrc fcgiwrap_enable="YES"
root@www:~# sysrc fcgiwrap_user="www"
root@www:~# sysrc fcgiwrap_group="www"
root@www:~# sysrc fcgiwrap_socket_owner="www"
root@www:~# sysrc fcgiwrap_socket_group="www"
root@www:~# service fcgiwrap start
Starting fcgiwrap.
```
[2]	Create a test scripts with a language (example below is Python3) under the directory you set CGI executable ([/usr/local/www/cgi-bin] on this example) and Access to it to verify CGI works normally.
```sh
root@www:~# vi /usr/local/www/cgi-bin/index.cgi
#!/usr/local/bin/python3.9

print("Content-type: text/html\n")
print("<html>\n<body>")
print("<div style=\"width: 100%; font-size: 40px; font-weight: bold; text-align: center;\">")
print("CGI Script Test Page")
print("</div>")
print("</body>\n</html>")

root@www:~# chmod 705 /usr/local/www/cgi-bin/index.cgi
```