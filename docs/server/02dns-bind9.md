# Bind9
## Install Paket Bind9
```sh
apt-get install bind9
```
Lakukan konfigurasi dan edit file di /etc/bind/named.conf.default-zones
```sh file
// Baris zona domain abcnet-1.id
zone "abcnet-1.id" {
type master;
file "/etc/bind/main/db.abcnet";
};
```
Salin dan modifikasi file zona forward pada /etc/bind/db.local ke /etc/bind/main/db.abcnet
```sh
#salin file
cp /etc/bind/db.local /etc/bind/main/db.abcnet

#modif file
$TTL 604800
@   IN  SOA ns.abcnet-1.id. info.abcnet-1.id. (
                1       ;   Serial
            604800      ;   Refresh
            86400       ;   Retry
            2419200     ;   Expire
            604800 )    ;   Negative Cache TTL
;
@   IN  NS  ns.abcnet-1.id.
@   IN  A   20.0.0.1
ns  IN  A   20.0.0.1
www IN  A   20.0.0.1
```
Lakukan edit /etc/bind/named.conf.options untuk keamanan dari serangan DNS Enumeration dan DNS Amplification
```sh
options {
        directory "/var/cache/bind";
        // Nonaktifkan fungsi transfer zona domain
        allow-transfer { none; };
        // Nonaktifkan fungsi recursive
        allow-recursion { none; };
        // forwarders {
        // 0.0.0.0;
        // };
};
```
service bind9 restart

netstat -tapun |grep named