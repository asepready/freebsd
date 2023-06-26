# Bind9
## Install Paket Bind9
```sh
pkg install bind916

#rndc-confgen -a
#chown root:bind /usr/local/etc/namedb/rndc.key
#chmod 640 /usr/local/etc/namedb/rndc.key
sysrc named_enable="YES"
sysrc altlog_proglist+=named #syslog
service named start
```
Lakukan konfigurasi dan edit file di /usr/local/etc/namedb/named.conf.default-zones
```sh file
# "/usr/local/etc/namedb/rndc.key"
include "/usr/local/etc/namedb/rndc.key";

controls {
        inet 127.0.0.1 allow { localhost; } keys { "rndc-key"; };
        inet 142.93.201.231 allow { 104.248.47.54; } keys { "rndc-key"; };
};

// Baris zona domain asepready.id
zone "asepready.id" {
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
@   IN  SOA ns.asepready.id. admin.asepready.id. (
                1       ;   Serial
            604800      ;   Refresh
            86400       ;   Retry
            2419200     ;   Expire
            604800 )    ;   Negative Cache TTL
;
@   IN  NS  ns.asepready.id.
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