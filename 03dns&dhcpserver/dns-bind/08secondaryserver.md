BIND : Configure Secondary Server

Configure DNS Secondary Server.
On this example, it shows to configure DNS Secondary Server [ns.server.education] (192.168.100.85) that DNS Primary Server is [ns.belajarfreebsd.or.id] (172.16.0.82) configured like here.
Replace IP address and Hostname to your own environment.

[1]	Configure on DNS Primary Host.
```sh
root@belajarfreebsd:~# vi /usr/local/etc/namedb/named.conf
options {
.....
.....
        allow-query { localhost; internal-network; };
        // add secondary server to allow to transfer zone files
        allow-transfer { localhost; 192.168.100.85; };
.....
.....

root@belajarfreebsd:~# vi /usr/local/etc/namedb/primary/belajarfreebsd.or.id.wan
$TTL 86400
@   IN  SOA     ns.belajarfreebsd.or.id. root.belajarfreebsd.or.id. (
        ;; update serial number
        2023122003  ;Serial
        3600        ;Refresh
        1800        ;Retry
        604800      ;Expire
        86400       ;Minimum TTL
)
        IN  NS      ns.belajarfreebsd.or.id.
        ;; add secondary server
        IN  NS      ns.server.education.
        IN  A       172.16.0.82
        IN  MX 10   ns.belajarfreebsd.or.id.

dlp     IN  A       172.16.0.82
www     IN  A       172.16.0.83

root@belajarfreebsd:~# rndc reload
server reload successful
```
[2]	Configure on DNS Secondary Host.
```sh
root@belajarfreebsd:~#  vi /usr/local/etc/namedb/external-zones.conf
// add target zone info
// IP address is the primary server's one
zone "belajarfreebsd.or.id" IN {
        type secondary;
        primaries { 172.16.0.82; };
        file "/usr/local/etc/namedb/secondary/belajarfreebsd.or.id.wan";
};

root@belajarfreebsd:~# rndc reload
root@belajarfreebsd:~# ls -l /usr/local/etc/namedb/secondary
total 5
-rw-r--r--  1 bind bind 377 Dec 20 11:18 belajarfreebsd.or.id.wan
# zone file has been transferred
```