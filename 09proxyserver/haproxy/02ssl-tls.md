HAProxy : SSL/TLS Setting2024/04/16
 	
Configure HAProxy with SSL/TLS connection.
The connection between HAproxy and Clients are encrypted with SSL.
```
---------------+------------------------------------+--------------------------------------+------------
               |                                    |                                      |
               |10.0.0.30                           |10.0.0.51                             |10.0.0.52
+--------------+---------------+   +----------------+----------------+   +-----------------+---------------+
| [ ns.belajarfreebsd.or.id ]  |   | [ node01.belajarfreebsd.or.id ] |   | [ node02.belajarfreebsd.or.id ] |
|           HAProxy            |   |           Web Server#1          |   |           Web Server#2          |
+------------------------------+   +---------------------------------+   +---------------------------------+
```
[1]	Get SSL certificates, refer to here.

[2]	In addition to previous basic HTTP Load Balancing setting, add settings for SSL/TLS.
```sh
# concatenate cert and key
root@belajarfreebsd:~# cat /usr/local/etc/letsencrypt/live/belajarfreebsd.or.id/fullchain.pem \
/usr/local/etc/letsencrypt/live/belajarfreebsd.or.id/privkey.pem > /usr/local/etc/haproxy.pem
root@belajarfreebsd:~# vi /usr/local/etc/haproxy.conf
# add into frontend section
# * comment out the 80 port line if you do not need unencrypted connection
frontend http-in
    bind *:80
    bind *:443 ssl crt /usr/local/etc/haproxy.pem 

root@belajarfreebsd:~# service haproxy reload
```
[3]	Verify working normally to access to frontend HAproxy Server.