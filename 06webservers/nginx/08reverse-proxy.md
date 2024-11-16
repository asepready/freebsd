Nginx : Reverse Proxy2024/02/13
 	
Configure Nginx as a Reverse Proxy Server. For example, Configure Nginx that HTTP/HTTPS accesses to [www.belajarfreebsd.or.id] are forwarded to [node01.belajarfreebsd.or.id].

[1]	Get SSL certificates, refer to here.

[2]	Configure Nginx.
```sh
root@www:~# vi /usr/local/etc/nginx/nginx.conf
# change content of [server] section like follows
# replace server name or certificates to yours
    server {
        listen      80 default_server;
        listen      [::]:80 default_server;
        listen      443 ssl http2 default_server;
        listen      [::]:443 ssl http2 default_server;
        server_name www.belajarfreebsd.or.id;

        ssl_certificate "/usr/local/etc/letsencrypt/live/www.belajarfreebsd.or.id/fullchain.pem";
        ssl_certificate_key "/usr/local/etc/letsencrypt/live/www.belajarfreebsd.or.id/privkey.pem";
        ssl_session_cache shared:SSL:1m;
        ssl_session_timeout  5m;

        proxy_redirect      off;
        proxy_set_header    X-Real-IP $remote_addr;
        proxy_set_header    X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header    Host $http_host;

        location / {
            proxy_pass http://node01.belajarfreebsd.or.id/;
        }
    }

root@www:~# service nginx reload
```
[3]	Configure backend Nginx server to log X-Forwarded-For header.
```sh
root@node01:~ # vi /usr/local/etc/nginx/nginx.conf
# line 26-28 : uncomment
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    # add lines in [server] section
    server {
        listen       80;
        server_name  node01.belajarfreebsd.or.id;
        set_real_ip_from   10.0.0.0/24;
        real_ip_header     X-Forwarded-For;


root@node01:~ # service nginx reload
```
[4]	Verify it works fine to access to frontend Nginx Server from any Client Computer.

[5]	It's possible to proxy requests of multiple hostnames or domainnames. For example, [www.belajarfreebsd.or.id], [rx-7.belajarfreebsd.or.id], [rx-8.belajarfreebsd.or.id] are assigned the same IP address (10.0.0.31 on here) by DNS setting and Nginx on the server with its IP address receives all requests to those hostname.
This example shows to use servers which have the same domainname but it's no problem if domainnames are not the same one.
The example below shows to configure Nginx that requests to [www.belajarfreebsd.or.id] are forwarded to the backend server [node01.belajarfreebsd.or.id (10.0.0.51)] (settings in [1]),
requests to [rx-7.belajarfreebsd.or.id] are forwarded to the backend server [rx-7.belajarfreebsd.or.id (10.0.0.101)],
requests to [rx-8.belajarfreebsd.or.id] are forwarded to the backend server [rx-8.belajarfreebsd.or.id (10.0.0.102)].
```sh
root@www:~# vi /usr/local/etc/nginx/nginx.conf
# add in the [http] section
http {
.....
.....
    server {
        listen      80;
        listen      [::]:80;
        listen      443 ssl http2;
        listen      [::]:443 ssl http2;
        server_name rx-7.belajarfreebsd.or.id;

        ssl_certificate "/usr/local/etc/letsencrypt/live/rx-7.belajarfreebsd.or.id/fullchain.pem";
        ssl_certificate_key "/usr/local/etc/letsencrypt/live/rx-7.belajarfreebsd.or.id/privkey.pem";
        ssl_session_cache shared:SSL:1m;
        ssl_session_timeout  5m;

        proxy_redirect      off;
        proxy_set_header    X-Real-IP $remote_addr;
        proxy_set_header    X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header    Host $http_host;

        location / {
            proxy_pass http://rx-7.belajarfreebsd.or.id/;
        }
    }

    server {
        listen      80;
        listen      [::]:80;
        listen      443 ssl http2;
        listen      [::]:443 ssl http2;
        server_name rx-8.belajarfreebsd.or.id;

        ssl_certificate "/usr/local/etc/letsencrypt/live/rx-8.belajarfreebsd.or.id/fullchain.pem";
        ssl_certificate_key "/usr/local/etc/letsencrypt/live/rx-8.belajarfreebsd.or.id/privkey.pem";
        ssl_session_cache shared:SSL:1m;
        ssl_session_timeout  5m;

        proxy_redirect      off;
        proxy_set_header    X-Real-IP $remote_addr;
        proxy_set_header    X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header    Host $http_host;

        location / {
            proxy_pass http://rx-8.belajarfreebsd.or.id/;
        }
    }

root@www:~# service nginx reload
```
[6]	Verify it works fine to access to each hostname from any Client Computer.
