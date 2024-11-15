BIND : Configure Zone Files
 	
Configure Zone Files for each Zone set in [named.conf]. Replace Network or Domain name on the example below to your own environment.

[1]	Create a zone file with forward lookup information that resolves IP addresses from hostnames. The example below uses Internal network [10.0.0.0/24], Domain name [belajarfreebsd.or.id]. Replace them to your domain name, internal IP address, or external IP address for your needs.
```sh
root@belajarfreebsd:~# ee /usr/local/etc/namedb/primary/belajarfreebsd.or.id.lan
$TTL 86400
@   IN  SOA     ns.belajarfreebsd.or.id. root.belajarfreebsd.or.id. (
        ;; any numerical values are OK for serial number
        ;; recommended : [YYYYMMDDnn] (update date + number)
        2023122001  ;Serial
        3600        ;Refresh
        1800        ;Retry
        604800      ;Expire
        86400       ;Minimum TTL
)
        ;; define Name Server
        IN  NS      ns.belajarfreebsd.or.id.
        ;; define Name Server's IP address
        IN  A       10.0.0.30
        ;; define Mail Exchanger Server
        IN  MX 10   ns.belajarfreebsd.or.id.

;; define each IP address of a hostname
ns     IN  A       10.0.0.30
www     IN  A       10.0.0.31
```
[2]	Create a zone file with reverse lookup information that resolves hostnames from IP addresses. The example below uses Internal network [10.0.0.0/24], Domain name [belajarfreebsd.or.id]. Replace them to your domain name, internal IP address, or external IP address for your needs.
```sh
root@belajarfreebsd:~# ee /usr/local/etc/namedb/primary/0.0.10.db
$TTL 86400
@   IN  SOA     ns.belajarfreebsd.or.id. root.belajarfreebsd.or.id. (
        2023122001  ;Serial
        3600        ;Refresh
        1800        ;Retry
        604800      ;Expire
        86400       ;Minimum TTL
)
        ;; define Name Server
        IN  NS      ns.belajarfreebsd.or.id.

;; define each hostname of an IP address
30      IN  PTR     ns.belajarfreebsd.or.id.
31      IN  PTR     www.belajarfreebsd.or.id.
```
[3]	Next, Start BIND and Verify Name or Address Resolution, refer to here.