Apache httpd : Configure mod_proxy
 	
Enable [mod_proxy] module to configure reverse proxy settings.

This example is based on the environment like follows.
```sh
----------------+-------------------------------------+-----------
                |                                     |
                |10.0.0.31                            |10.0.0.51
+---------------+---------------+   +-----------------+---------------+
| [ www.belajarfreebsd.or.id ]  |   | [ node01.belajarfreebsd.or.id ] |
|         Web Server#1          |   |            Web Server#2         |
+-------------------------------+   +---------------------------------+
```
[1]	Configure Apache2.
```sh
root@www:~# vi /usr/local/etc/apache24/httpd.conf
# line 129 : uncomment
LoadModule proxy_module libexec/apache24/mod_proxy.so
# line 132 : uncomment
LoadModule proxy_http_module libexec/apache24/mod_proxy_http.so
root@www:~# vi /usr/local/etc/apache24/Includes/revers_proxy.conf
# create new
<IfModule mod_proxy.c>
    ProxyRequests Off
    <Proxy *>
        Require all granted
    </Proxy>
    # backend server and forwarded path
    ProxyPass / http://node01.belajarfreebsd.or.id/
    ProxyPassReverse / http://node01.belajarfreebsd.or.id/
</IfModule> 

root@www:~# service apache24 reload
```
[2]	Access to frontend server to verify backend server responses like follows.

[3]	It's possible to configure load balancing.
```sh
----------------+---------------------------------------+-------------------------------------+------------
                |                                       |                                     |
                |10.0.0.31                              |10.0.0.51                            |10.0.0.52
+---------------+-----------------+   +-----------------+---------------+   +-----------------+---------------+
|  [ www.belajarfreebsd.or.id ]   |   | [ node01.belajarfreebsd.or.id ] |   | [ node02.belajarfreebsd.or.id ] |
|          Web Server#1           |   |           Web Server#2          |   |           Web Server#3          |
+---------------------------------+   +---------------------------------+   +---------------------------------+

root@www:~# vi /usr/local/etc/apache24/httpd.conf
# line 139 : uncomment
LoadModule proxy_balancer_module libexec/apache24/mod_proxy_balancer.so
# line 146 : uncomment
LoadModule slotmem_shm_module libexec/apache24/mod_slotmem_shm.so
# line 153 : uncomment
LoadModule lbmethod_byrequests_module libexec/apache24/mod_lbmethod_byrequests.so
root@www:~# vi /usr/local/etc/apache24/Includes/revers_proxy.conf
# create new
<IfModule mod_proxy.c>
    ProxyRequests Off
    <Proxy *>
        Require all granted
    </Proxy>
    # specify the way of load balancing with [lbmethod]
    # also possible to set [bytraffic] which means httpd balances requests by traffic
    ProxyPass / balancer://cluster lbmethod=byrequests
    <proxy balancer://cluster>
        BalancerMember http://node01.belajarfreebsd.or.id/ loadfactor=1
        BalancerMember http://node02.belajarfreebsd.or.id/ loadfactor=1
    </proxy>
</IfModule>

root@www:~# service apache24 reload
```
[4]	Access to frontend server to verify backend servers response like follows.

