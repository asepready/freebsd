1. Konfigurasi Interfaces Jaringan
- buka dan edit untuk interfaces di /etc/rc.conf
```sh term
#/etc/rc.conf
# Interfaces Networks
ifconfig_em0="DHCP" #IPv4 DHCP
ifconfig_re0="inet 192.168.122.2 netmask 255.255.255.0" #IPv4 STATIC
defaultrouter="192.168.122.1" #IPv4 Gateway

ifconfig_em0_ipv6="inet6 accept_rtadv" #IPv6 DHCP 
```