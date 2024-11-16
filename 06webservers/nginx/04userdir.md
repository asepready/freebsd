Nginx : Enable Userdir2024/02/13
 	
Enable Userdir for common users to open their site in the home directories.

[1]	Configure Nginx. Add settings into [server] section of a site definition you'd like to set.
```sh
root@www:~# vi /usr/local/etc/nginx/nginx.conf
# add into [server] section
    server {
        .....
        .....
        location ~ ^/~(.+?)(/.*)?$ {
              alias /home/$1/public_html$2;
              index  index.html index.htm;
              autoindex on;
        }

root@www:~# service nginx reload
```
[2]	Create a test page with a common user to make sure it works normally.
```sh
syadmin@www:~$ chmod 711 $HOME
syadmin@www:~$ mkdir ~/public_html
syadmin@www:~$ chmod 755 ~/public_html
syadmin@www:~$ vi ~/public_html/index.html
<html>
<body>
<div style="width: 100%; font-size: 40px; font-weight: bold; text-align: center;">
Nginx UserDir Test Page
</div>
</body>
</html>
```