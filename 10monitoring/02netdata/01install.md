NetData : Install
 	
Install NetData to monitor System resources timely via Web browser.

[1]	Install NetData.
```sh
root@belajarfreebsd:~# pkg install -y netdata
root@belajarfreebsd:~# vi /usr/local/etc/netdata/netdata.conf
.....
.....

[web]
        respect do not track policy = yes
        disconnect idle clients after seconds = 3600
        # line 17 : change bind IP address if you like to access to NetData from other Hosts
        bind to = 10.0.0.30
        web files owner = netdata
        web files group = netdata

        # if enable HTTPS, add follows
        # * require that [netdata] user can read certificate and key file
        ssl key = /usr/local/etc/letsencrypt/live/ns.belajarfreebsd.or.id/privkey.pem
        ssl certificate = /usr/local/etc/letsencrypt/live/ns.belajarfreebsd.or.id/fullchain.pem
        tls version = 1.3

root@belajarfreebsd:~# service netdata enable
netdata enabled in /etc/rc.conf
root@belajarfreebsd:~# service netdata start
Starting netdata.
```
[2]	Access to [(your server's hostname or IP address):19999/] with Web borwser on a Client in your network or from Localhost, then, NetData admin console is shown like follows and you can monitor System resources.


