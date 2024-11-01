1. Konfigurasi Interfaces Jaringan
- buka dan edit untuk interfaces di /etc/rc.conf
```sh term
#/etc/rc.conf
# Interfaces Networks
#ifconfig_DEFAULT="DHCP inet6 accept_rtadv"
ifconfig_vtnet0="inet 9.9.9.3 netmask 255.255.255.0 description 'authoritative'"
ifconfig_vtnet0_ipv6="inet6 2001:500:9f::3 prefixlen 64 description 'authoritative'"
ifconfig_vtnet0_alias1="inet 74.125.24.100 netmask 255.255.255.0 description 'google'"
ifconfig_vtnet0_alias1_ipv6="inet6 2001:503:ba3e::2:1864 prefixlen 64 description 'google'"
ifconfig_vtnet0_alias2="inet 69.171.250.35 netmask 255.255.255.0 description 'facebook'"
ifconfig_vtnet0_alias2_ipv6="inet6 2801:1b8:10::35 prefixlen 64 description 'facebook'"
ifconfig_vtnet0_alias3="inet 114.125.160.163 netmask 255.255.255.0 description 'msftncsi'"
ifconfig_vtnet0_alias3_ipv6="inet6 2001:500:2::163 prefixlen 64 description 'msftncsi'"
ifconfig_vtnet0_alias4="inet 104.215.95.187 netmask 255.255.255.0 description 'msftconnecttest'"
ifconfig_vtnet0_alias4_ipv6="inet6 2001:500:2f::163 prefixlen 64 description 'msftconnecttest'"
ifconfig_vtnet0_alias5="inet 162.159.200.100 netmask 255.255.255.0 description 'ntp'"
ifconfig_vtnet0_alias5_ipv6="inet6 2001:500:12::1864 prefixlen 64 description 'ntp'"
ifconfig_vtnet0_alias6="inet 131.107.255.255 netmask 255.255.255.0 description ''"
ifconfig_vtnet0_alias6_ipv6="inet6 2001:7fe::255 prefixlen 64 description ''"
defaultrouter="9.9.9.99" #IPv4 Gateway
ipv6_defaultrouter="2001:500:9f::99" #IPv6 Gateway
```

1. restart service
    ```sh
    service netif restart
    service routing restart

    #atau untuk routing
    service netif restart && service routing restart
    ```

2. restart manual ifconfig
    ```sh
    ifconfig network-interface down
    ifconfig network-interface up
    ```
