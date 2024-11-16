Nginx : Install
 	
Install fast HTTP Server [Nginx] and configure HTTP/Proxy Server with it.
[1]	Install Nginx.
```sh
root@www:~# pkg install -y nginx
```
[2]	Configure basic settings.
```sh
root@www:~# vi /usr/local/etc/nginx/nginx.conf
# line 42 : change to your hostname
server_name www.srv.world;
root@www:~# sysrc nginx_enable="YES"
root@www:~# service nginx start
Performing sanity check on nginx configuration:
nginx: the configuration file /usr/local/etc/nginx/nginx.conf syntax is ok
nginx: configuration file /usr/local/etc/nginx/nginx.conf test is successful
Starting nginx.
```
[3]	Access to the default page of Nginx from a Client with Web browser and that's OK if the following page are shown.
