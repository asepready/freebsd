BIND : Configure for Internal Network
 	
Install BIND to Configure DNS (Domain Name System) Server to provide Name or Address Resolution service for Clients.

[1]	Install BIND.
```sh
root@nsx:~# pkg install -y bind918 bind-tools
```
[2]	On this example, Configure BIND for Internal Network. The example follows is for the case that Local network is [192.168.122.0/24], Domain name is [srv.cnsa], Replace them to your own environment.
```sh
root@nsx:~# vi /usr/local/etc/namedb/named.conf
// line 8 : add to set ACL entry for your local network
acl internal-network { 192.168.122.0/24; };

// line 20 : specify IP address bind listens
// if listen all, specify [any]
         listen-on       { 192.168.122.100; };

// line 25 : if bind listens on IPv6, comment out and set IPv6 address
// if listen all, specify [any]
//         listen-on-v6    { ::1; };

// line 27 : add follows
// network range you allow to recieve queries from client computers
// set ACL entry you set above
         allow-query     { localhost; internal-network; };
// network range you allow to transfer zone files to client computers
// set secondary DNS servers if they exist
         allow-transfer  { localhost; };
// allow recursion
         recursion yes;

// add to last line
include "/usr/local/etc/namedb/internal-zones.conf";

root@nsx:~# vi /usr/local/etc/namedb/internal-zones.conf
// create new
// add zones for your network and domain name
zone "srv.cnsa" IN {
        type primary;
        file "/usr/local/etc/namedb/primary/srv.cnsa.lan";
        allow-update { none; };
};
zone "122.168.192.in-addr.arpa" IN {
        type primary;
        file "/usr/local/etc/namedb/primary/122.168.192.db";
        allow-update { none; };
};

// For how to write the section [*.*.*.*.in-addr.arpa], write your network address reversely like follows
// case of 10.0.0.0/24
// network address     ⇒ 10.0.0.0
// network range       ⇒ 10.0.0.0 - 10.0.0.255
// how to write        ⇒ 0.0.10.in-addr.arpa

// case of 192.168.1.0/24
// network address     ⇒ 192.168.1.0
// network range       ⇒ 192.168.1.0 - 192.168.1.255
// how to write        ⇒ 1.168.192.in-addr.arpa
```
[3]	Next, Configure Zone Files for each Zone you set in [named.conf] above.
To Configure Zone Files, refer to here.