BIND : Configure Zone Files
 	
Configure Zone Files for each Zone set in [named.conf]. Replace Network or Domain name on the example below to your own environment.

[1]	Create a zone file with forward lookup information that resolves IP addresses from hostnames. The example below uses Internal network [192.168.122.0/24], Domain name [srv.cnsa]. Replace them to your domain name, internal IP address, or external IP address for your needs.
```sh
root@nsx:~# ee /usr/local/etc/namedb/primary/srv.cnsa.lan
$TTL 86400
@   IN  SOA     nsx.srv.cnsa. root.srv.cnsa. (
        ;; any numerical values are OK for serial number
        ;; recommended : [YYYYMMDDnn] (update date + number)
        2023122001  ;Serial
        3600        ;Refresh
        1800        ;Retry
        604800      ;Expire
        86400       ;Minimum TTL
)
        ;; define Name Server
        IN  NS      nsx.srv.cnsa.
        ;; define Name Server's IP address
        IN  A       192.168.122.100
        ;; define Mail Exchanger Server
        IN  MX 10   nsx.srv.cnsa.

;; define each IP address of a hostname
nsx     IN  A       192.168.122.100
www     IN  A       192.168.122.31
```
[2]	Create a zone file with reverse lookup information that resolves hostnames from IP addresses. The example below uses Internal network [192.168.122.0/24], Domain name [srv.cnsa]. Replace them to your domain name, internal IP address, or external IP address for your needs.
```sh
root@nsx:~# ee /usr/local/etc/namedb/primary/122.168.192.db
$TTL 86400
@   IN  SOA     nsx.srv.cnsa. root.srv.cnsa. (
        2023122001  ;Serial
        3600        ;Refresh
        1800        ;Retry
        604800      ;Expire
        86400       ;Minimum TTL
)
        ;; define Name Server
        IN  NS      nsx.srv.cnsa.

;; define each hostname of an IP address
30      IN  PTR     nsx.srv.cnsa.
31      IN  PTR     www.srv.cnsa.
```
[3]	Next, Start BIND and Verify Name or Address Resolution, refer to here.