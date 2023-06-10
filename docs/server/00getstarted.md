## 1. Konfigurasi IP Dinamis/Statik Pada NIC
aktifkan interface eth1
```sh
ifconfig eth1 up
```
Buka dan edit untuk hostname di /etc/network/interfaces
```sh interface
# The seconds network interface
auto eth0
iface eth0 inet static
        address 10.3.1.1
        network 10.3.1.0
        netmask 255.255.255.0
        gateway 10.3.1.111
        dns-domain google.com
        dns-nameservers 10.3.1.111 8.8.8.8
```
Lakukan restart pada network
```sh term
# mengaktifkan interface
    ifconfig network-interface down
    ifconfig network-interface up
# merestart ip pada interface
    service networking restart
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