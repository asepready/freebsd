HAProxy : HTTP Load Balancing2024/04/16
 	
Install HAProxy to configure Load Balancing Server.
This example is based on the environment like follows.
```
---------------+------------------------------------+--------------------------------------+------------
               |                                    |                                      |
               |10.0.0.30                           |10.0.0.51                             |10.0.0.52
+--------------+---------------+   +----------------+----------------+   +-----------------+---------------+
| [ ns.belajarfreebsd.or.id ]  |   | [ node01.belajarfreebsd.or.id ] |   | [ node02.belajarfreebsd.or.id ] |
|           HAProxy            |   |           Web Server#1          |   |           Web Server#2          |
+------------------------------+   +---------------------------------+   +---------------------------------+
```
 	
Configure Servers that HTTP connection to HAProxy Server is forwarded to backend Web Servers.

[1]	Install HAProxy.
```sh
root@belajarfreebsd:~# pkg install -y haproxy
```
[2]	Configure HAProxy.
```sh
root@belajarfreebsd:~# vi /usr/local/etc/haproxy.conf
# create new
global
    log         127.0.0.1:514 local1 info
    chroot      /var/empty
    pidfile     /var/run/haproxy.pid
    maxconn     4000
    user        haproxy
    group       haproxy
    daemon

defaults
    mode                    http
    log                     global
    option                  httplog
    option                  dontlognull
    option http-server-close
    option forwardfor       except 127.0.0.0/8
    retries                 3
    timeout http-request    10s
    timeout queue           1m
    timeout connect         10s
    timeout client          1m
    timeout server          1m
    timeout http-keep-alive 10s
    timeout check           10s
    maxconn                 3000

# define frontend ( for [http-in], any name you like )
frontend http-in
    # listen 80 port
    bind *:80
    # set default backend
    default_backend    backend_servers

# define backend
backend backend_servers
    # balance with roundrobin
    balance            roundrobin
    # define backend servers
    server             node01 10.0.0.51:80 check
    server             node02 10.0.0.52:80 check

root@belajarfreebsd:~# pw useradd haproxy -u 200 -d /var/empty -s /usr/sbin/nologin
root@belajarfreebsd:~# service haproxy enable
haproxy enabled in /etc/rc.conf
root@belajarfreebsd:~# service haproxy start
Starting haproxy.
```
[3]	Configure Syslogd to receive Haproxy log to a file.
```sh
root@belajarfreebsd:~# vi /etc/syslog.conf
# line 8 : add
*.err;kern.warning;auth.notice;mail.crit                /dev/console
local1.*                                                /var/log/haproxy.log
*.notice;authpriv.none;kern.debug;lpr.info;mail.crit;news.err   /var/log/messages

root@belajarfreebsd:~# touch /var/log/haproxy.log
root@belajarfreebsd:~# chown haproxy:haproxy /var/log/haproxy.log
root@belajarfreebsd:~# sysrc syslogd_flags="-b localhost -C"
syslogd_flags: -s -> -b localhost -C
root@belajarfreebsd:~# service syslogd restart
```
[4]	Change settings on Backend Web servers (Apache httpd on this example) to logging X-Forwarded-For header.
```sh
root@node01:~ # vi /usr/local/etc/apache24/httpd.conf
# line 316,317 : change like follows
LogFormat "\"%{X-Forwarded-For}i\" %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
LogFormat "\"%{X-Forwarded-For}i\" %l %u %t \"%r\" %>s %b" common
root@node01:~ # service apache24 reload
```
[5]	Verify it works normally to access to frontend HAproxy Server.

