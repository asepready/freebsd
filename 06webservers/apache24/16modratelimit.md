Apache httpd : Configure mod_ratelimit
 	
Enable [mod_ratelimit] module to limit bandwidth for clients.

[1]	Configure [mod_ratelimit].
```sh
root@www:~# vi /usr/local/etc/apache24/httpd.conf
# line 101 : uncomment
LoadModule ratelimit_module libexec/apache24/mod_ratelimit.so
root@www:~# vi /usr/local/etc/apache24/Includes/ratelimit.conf
# create new
# for example, limit bandwidth as [500 KB/sec] under the [/download] location
<IfModule mod_ratelimit.c>
    <Location /download>
        SetOutputFilter RATE_LIMIT
        SetEnv rate-limit 500
    </Location>
</IfModule> 

root@www:~# service apache24 reload
```
[2]	Access to the location to make sure the settings is effective.
The lower one is downloading from the limited location, the upper is downloading from a unlimited location.