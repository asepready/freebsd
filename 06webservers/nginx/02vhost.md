Nginx : Virtual Hostings2024/02/13

This is the Virtual Hostings configuration for Nginx. For example, configure additional domainame [virtual.host].

[1]	Configure Nginx.
```sh
root@www:~# vi /usr/local/etc/nginx/nginx.conf
http {
.....
.....
    # add settings in [http] section
    server {
        listen       80;
        server_name  www.virtual.host;

        location / {
            root   /usr/local/www/virtual.host;
            index  index.html index.htm;
        }
    }
}

root@www:~# mkdir /usr/local/www/virtual.host
root@www:~# service nginx reload
```
[2]	Create a test page to make sure it works normally.
```sh
root@www:~# vi /usr/local/www/virtual.host/index.html
<html>
<body>
<div style="width: 100%; font-size: 40px; font-weight: bold; text-align: center;">
Nginx Virtual Host Test Page
</div>
</body>
</html>
```