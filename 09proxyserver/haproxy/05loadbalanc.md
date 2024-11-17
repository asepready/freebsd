HAProxy : Layer 4 Load Balancing
 	
Configure HAProxy on Layer 4 Mode.
On this example, configure MariaDB backend like the following environment.
```
---------------+------------------------------------+--------------------------------------+------------
               |                                    |                                      |
               |10.0.0.30                           |10.0.0.51                             |10.0.0.52
+--------------+---------------+   +----------------+----------------+   +-----------------+---------------+
| [ ns.belajarfreebsd.or.id ]  |   | [ node01.belajarfreebsd.or.id ] |   | [ node02.belajarfreebsd.or.id ] |
|           HAProxy            |   |        MariaDB Server#1         |   |         MariaDB Server#2        |
+------------------------------+   +---------------------------------+   +---------------------------------+
```

[1]	Configure HAProxy.
```sh
root@dlp:~ # vi /usr/local/etc/haproxy.conf
# change [mode] value in [defaults] section
defaults
    mode            tcp

# define MariaDB for frontend, backend
frontend mysql-in
    bind *:3306
    default_backend backend_db

backend backend_db
    balance         roundrobin
    server          node01 10.0.0.51:3306 check
    server          node02 10.0.0.52:3306 check

root@dlp:~ # service haproxy reload
```
[2]	Verify working normally to access to frontend HAproxy Server.
```sh
root@client:~ # mysql -u freebsd -p -h ns.belajarfreebsd.or.id -e "show variables like 'hostname';"
Enter password:
+---------------+-----------------------------+
| Variable_name | Value                       |
+---------------+-----------------------------+
| hostname      | node02.belajarfreebsd.or.id |
+---------------+-----------------------------+

root@client:~ # mysql -u freebsd -p -h ns.belajarfreebsd.or.id -e "show variables like 'hostname';"
Enter password:
+---------------+-----------------------------+
| Variable_name | Value                       |
+---------------+-----------------------------+
| hostname      | node01.belajarfreebsd.or.id |
+---------------+-----------------------------+
```