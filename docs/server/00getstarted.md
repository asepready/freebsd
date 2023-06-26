## 1. Konfigurasi IP Dinamis/Statik Pada NIC
aktifkan interface eth1
```sh
ifconfig eth1 up
```
Buka dan edit untuk hostname di /etc/rc.conf
```sh startup
# MultiGateway
defaultrouter="192.168.8.1"

ifconfig_em0="inet 192.168.8.10 netmask 255.255.255.0"
ifconfig_re0="inet 192.168.0.10 netmask 255.255.255.0 fib 1"


#SIngleGateway
ifconfig_em0="DHCP"
defaultrouter="192.168.123.1"
ifconfig_em1="inet 10.3.1.1 netmask 255.255.255.0"

static_routes="lan"
route_lan="-net 10.3.1.0/24 10.3.1.111"

static_routes="fibadsl"
route_fibadsl="default 192.168.0.254 -fib 1"
```
Lakukan restart pada network
```sh term
# mengaktifkan interface
    ifconfig network-interface down
    ifconfig network-interface up
# merestart ip pada interface
    service routing restart
```
## 2. Merubah nama Host & Domain
buka dan edit untuk hostname di /etc/hostname
```sh file
abcnet-1
```
buka dan edit untuk domain di /etc/hosts
```sh file
127.0.0.1       localhost
127.0.1.1       abcnet-1.id      abcnet-1

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
```