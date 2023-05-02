1. Konfigurasi Interfaces Jaringan
- buka dan edit untuk interfaces di /etc/rc.conf
```sh term
#/etc/rc.conf
# Interfaces Networks
ifconfig_em0="DHCP" #IPv4 DHCP
ifconfig_em0="inet 10.10.10.3 netmask 255.255.255.0" #IPv4 STATIC
defaultrouter="10.10.10.2" #IPv4 Gateway

ifconfig_em0_ipv6="inet6 accept_rtadv" #IPv6 DHCP 
```