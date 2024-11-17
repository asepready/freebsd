Squid : Configure Reverse Proxy2024/04/15
 	
Configure Squid as a Reverse Proxy Server.
[1]	Get SSL Certificate to receive HTTPS access, too, refer to here.

[2]	Configure Squid.
```sh
root@belajarfreebsd.or.id:~# vi /usr/local/etc/squid/squid.conf
# line 66 : add to allow all http access
http_access allow all 
# And finally deny all other access to this proxy
http_access deny all

# line 71 : specify the backend Web server
#http_port 3128
http_port 80 accel defaultsite=www.belajarfreebsd.or.id
https_port 443 accel defaultsite=www.belajarfreebsd.or.id cert=/usr/local/etc/letsencrypt/live/ns.belajarfreebsd.or.id/fullchain.pem key=/usr/local/etc/letsencrypt/live/ns.belajarfreebsd.or.id/privkey.pem

# line 75 : uncomment
# number means ⇒ [disk cache size] [number of directories on top level] [number of directories on 2nd level]
cache_dir ufs /var/spool/squid 100 16 256

# add to last line
cache_peer www.belajarfreebsd.or.id parent 80 0 no-query originserver 

# memory cache size
cache_mem 256 MB 

# define hostname
visible_hostname ns.belajarfreebsd.or.id 

root@belajarfreebsd.or.id:~# sysrc squid_user=root
squid_user: -> root
root@belajarfreebsd.or.id:~# service squid enable
squid enabled in /etc/rc.conf
root@belajarfreebsd.or.id:~# service squid start
```
[3]	Change settings of DNS or Routers in your local network if need to listen HTTP/HTTPS access on Squid, then try to access to Squid Reverse Proxy Server from a Client PC with Web browser like follows.