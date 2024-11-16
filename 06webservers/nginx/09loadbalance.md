Nginx : Load Balancing
 	
Configure Nginx as a Load Balancing Server.
This example is based on the environment like follows.
```sh
----------------+--------------------------------+-----
                |                                |
                |10.0.0.31                       |
+---------------+----------------+               |
|  [ www.belajarfreebsd.or.id ]  |               |
|             Nginx              |               |
+--------------------------------+               |
                                                 |
------------+------------------------------------+--------------------------------------+------------
            |                                    |                                      |
            |10.0.0.51                           |10.0.0.52                             |10.0.0.53
+-----------+---------------------+   +----------+----------------------+   +-----------+---------------------+
| [ node01.belajarfreebsd.or.id ] |   | [ node02.belajarfreebsd.or.id ] |   | [ node03.belajarfreebsd.or.id ] |
|           Web Server#1          |   |            Web Server#2         |   |           Web Server#3          |
+---------------------------------+   +---------------------------------+   +---------------------------------+
```
[1]	Get SSL certificates, refer to here.

[2]	Configure Nginx.
```sh
root@www:~# vi /usr/local/etc/nginx/nginx.conf
# add in the [http] section
# [backup] means this server is balanced only when other servers are down
# [weight=*] means balancing weight
http {
    upstream backends {
        server node01.belajarfreebsd.or.id:80 weight=2;
        server node02.belajarfreebsd.or.id:80;
        server node03.belajarfreebsd.or.id:80 backup;
    }


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
                proxy_pass http://backends;
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



