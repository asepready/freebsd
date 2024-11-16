Nginx : Use Stream module

Configure Nginx to use Stream module.
It's possible to proxy TCP, UDP (Nginx 1.9.13 and later for UDP), UNIX-domain sockets requests.
This example is based on the environment like follows to proxy MariaDB requests to backend servers.
```sh
-----------+--------------------------------------+-----
           |                                      |
           |10.0.0.31                             |
+----------+----------------------+               |
|   [ www.belajarfreebsd.or.id ]  |               |
|               Nginx             |               |
+---------------------------------+               |
                                                  |
------------------+-------------------------------+-----------
                  |                               |           
                  |10.0.0.51                      |10.0.0.52  
+-----------------+---------------+   +-----------+----------+
| [ node01.belajarfreebsd.or.id ] |   | [ node02.belajarfreebsd.or.id ] |
|             Mariadb#1           |   |             Mariadb#2           |
+---------------------------------+   +---------------------------------+
```
[1]	Configure Nginx.
```sh
root@www:~ # vi /usr/local/etc/nginx/nginx.conf
# line 15 : add
load_module /usr/local/libexec/nginx/ngx_stream_module.so;

# add to last line
# [weight=*] means balancing weight
stream {
    upstream mariadb-backend {
        server 10.0.0.51:3306 weight=2;
        server 10.0.0.52:3306;
    }
    server {
        listen 3306;
        proxy_pass mariadb-backend;
    }
}

root@www:~ # service nginx reload
```
[2]	Verify it works fine to access to frontend Nginx server from any client computer.
```sh
sysadmin@client:~ $ mysql -u serverworld -ppassword -h www.belajarfreebsd.or.id -e "show variables like 'hostname';"
+---------------+-----------------------------+
| Variable_name | Value                       |
+---------------+-----------------------------+
| hostname      | node01.belajarfreebsd.or.id |
+---------------+-----------------------------+
sysadmin@client:~ $ mysql -u serverworld -ppassword -h www.belajarfreebsd.or.id -e "show variables like 'hostname';"
+---------------+-----------------------------+
| Variable_name | Value                       |
+---------------+-----------------------------+
| hostname      | node01.belajarfreebsd.or.id |
+---------------+-----------------------------+
sysadmin@client:~ $ mysql -u serverworld -ppassword -h www.belajarfreebsd.or.id -e "show variables like 'hostname';"
+---------------+-----------------------------+
| Variable_name | Value                       |
+---------------+-----------------------------+
| hostname      | node02.belajarfreebsd.or.id |
+---------------+-----------------------------+
sysadmin@client:~ $ mysql -u serverworld -ppassword -h www.belajarfreebsd.or.id -e "show variables like 'hostname';"
+---------------+-----------------------------+
| Variable_name | Value                       |
+---------------+-----------------------------+
| hostname      | node01.belajarfreebsd.or.id |
+---------------+-----------------------------+
