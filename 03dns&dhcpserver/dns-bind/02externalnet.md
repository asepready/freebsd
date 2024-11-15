BIND : Configure for External Network2023/12/20
 	
Install BIND to Configure DNS (Domain Name System) Server to provide Name or Address Resolution service for client computers.

[1]	Install BIND.
```sh
root@belajarfreebsd:~# pkg install -y bind918 bind-tools
```
[2]	On this example, Configure BIND for External Network.
The example follows is for the case that External network is [172.16.0.80/29], Domain name is [belajarfreebsd.or.id], Replace them to your own environment.
( Actually, [172.16.0.80/29] is for private IP addresses, replace to your global IP addresses. )
```sh
root@belajarfreebsd:~# vi /usr/local/etc/namedb/named.conf
// line 20 : specify IP address bind listens
// if listen all, specify [any]
         listen-on       { 10.0.0.30; };

// line 25 : if bind listens on IPv6, comment out and set IPv6 address
// if listen all, specify [any]
//         listen-on-v6    { ::1; };

// line 27 : add follows
// network range you allow to recieve queries from client computers
// accept queries from all hosts for external use
         allow-query     { any; };
// network range you allow to transfer zone files to client computers
// set secondary DNS servers if they exist
         allow-transfer  { localhost; };
// not allow recursive queries for external use
// answer to zones only this server has their entries
         recursion no;

// add to last line
include "/usr/local/etc/namedb/external-zones.conf";

root@belajarfreebsd:~# vi /usr/local/etc/namedb/external-zones.conf
// create new
// add zones for your network and domain name
zone "belajarfreebsd.or.id" IN {
        type primary;
        file "/usr/local/etc/namedb/primary/belajarfreebsd.or.id.wan";
        allow-update { none; };
};
zone "80.0.16.172.in-addr.arpa" IN {
        type primary;
        file "/usr/local/etc/namedb/primary/80.0.16.172.db";
        allow-update { none; };
};
```
[3]	Next, Configure Zone Files for each Zone you set in [named.conf] above.
To Configure Zone Files, refer to here.