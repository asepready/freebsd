Squid : Install
 	
Install Squid to configure Proxy server.

[1]	Install Squid.
```sh
root@prox:~# pkg install -y squid
```
[2]	This is general forward proxy settings.
```sh
root@prox:~# vi /usr/local/etc/squid/squid.conf
.....
.....
acl Safe_ports port 777         # multiling http
# line 28 : add your local network
# network range you allow to use this proxy server
acl my_localnet src 10.0.0.0/24

# line 66 : add a line you defined ACL
# http_access allow localnet
http_access allow my_localnet

# add to last line
request_header_access Referer deny all
request_header_access X-Forwarded-For deny all
request_header_access Via deny all
request_header_access Cache-Control deny all

# add (do not display IP address)
forwarded_for off

root@prox:~# service squid enable
squid enabled in /etc/rc.conf
root@prox:~# service squid start
```