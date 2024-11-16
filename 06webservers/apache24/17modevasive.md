Apache httpd : Configure mod_evasive
 	
Enable [mod_evasive] module to defend from DoS attacks and so on.

[1]	Install and configure [mod_evasive].
```sh
root@www:~# pkg install -y ap24-mod_evasive
root@www:~# vi /usr/local/etc/apache24/httpd.conf
# line 184 : uncomment
LoadModule evasive20_module libexec/apache24/mod_evasive20.so
root@www:~# vi /usr/local/etc/apache24/Includes/evasive.conf
# create new
<IfModule mod_evasive20.c>
    # hash table size
    DOSHashTableSize    3097
    # threshold for the number of requests for the same page per page interval
    DOSPageCount        2
    # threshold for the total number of requests for any object by the same client on the same listener per site interval
    DOSSiteCount        50
    # the interval for the page count threshold
    DOSPageInterval     1
    # the interval for the site count threshold
    DOSSiteInterval     1
    # amount of time (in seconds) that a client will be blocked for if they are added to the blocking list
    DOSBlockingPeriod   10
    # log directory
    DOSLogDir           "/var/log/mod-evasive"

    # uncomment and configure follows if you need
    # notification address if IP address becomes blacklisted
    #DOSEmailNotify      root@localhost
    # possible to set any command
    #DOSSystemCommand    "su - someuser -c '/sbin/... %s ...'"
</IfModule>

root@www:~# mkdir /var/log/mod-evasive
root@www:~# chown www:www /var/log/mod-evasive
root@www:~# service apache24 reload
```
[2]	Test to access to Apache httpd.
```sh
root@www:~# for i in `seq 1 20`; do curl -I localhost; done
HTTP/1.1 200 OK
Date: Fri, 02 Feb 2024 01:01:38 GMT
Server: Apache/2.4.58 (FreeBSD) OpenSSL/3.0.12 mod_auth_kerb/5.4
Upgrade: h2
Connection: Upgrade
Last-Modified: Tue, 30 Jan 2024 00:21:58 GMT
ETag: "82-6101ec01fa41e"
Accept-Ranges: bytes
Content-Length: 130
Content-Type: text/html

HTTP/1.1 200 OK
Date: Fri, 02 Feb 2024 01:01:38 GMT
Server: Apache/2.4.58 (FreeBSD) OpenSSL/3.0.12 mod_auth_kerb/5.4
Upgrade: h2
Connection: Upgrade
Last-Modified: Tue, 30 Jan 2024 00:21:58 GMT
ETag: "82-6101ec01fa41e"
Accept-Ranges: bytes
Content-Length: 130
Content-Type: text/html

HTTP/1.1 200 OK
Date: Fri, 02 Feb 2024 01:01:38 GMT
Server: Apache/2.4.58 (FreeBSD) OpenSSL/3.0.12 mod_auth_kerb/5.4
Upgrade: h2
Connection: Upgrade
Last-Modified: Tue, 30 Jan 2024 00:21:58 GMT
ETag: "82-6101ec01fa41e"
Accept-Ranges: bytes
Content-Length: 130
Content-Type: text/html

HTTP/1.1 200 OK
Date: Fri, 02 Feb 2024 01:01:38 GMT
Server: Apache/2.4.58 (FreeBSD) OpenSSL/3.0.12 mod_auth_kerb/5.4
Upgrade: h2
Connection: Upgrade
Last-Modified: Tue, 30 Jan 2024 00:21:58 GMT
ETag: "82-6101ec01fa41e"
Accept-Ranges: bytes
Content-Length: 130
Content-Type: text/html

HTTP/1.1 403 Forbidden
Date: Fri, 02 Feb 2024 01:01:38 GMT
Server: Apache/2.4.58 (FreeBSD) OpenSSL/3.0.12 mod_auth_kerb/5.4
Content-Type: text/html; charset=iso-8859-1

HTTP/1.1 403 Forbidden
Date: Fri, 02 Feb 2024 01:01:38 GMT
Server: Apache/2.4.58 (FreeBSD) OpenSSL/3.0.12 mod_auth_kerb/5.4
Content-Type: text/html; charset=iso-8859-1

HTTP/1.1 403 Forbidden
Date: Fri, 02 Feb 2024 01:01:38 GMT
Server: Apache/2.4.58 (FreeBSD) OpenSSL/3.0.12 mod_auth_kerb/5.4
Content-Type: text/html; charset=iso-8859-1
.....
.....

# if blocked, logs are recorded
root@www:~# ls -l /var/log/mod-evasive
total 1
-rw-r--r--  1 www www 5 Feb  2 09:59 dos-::1
```