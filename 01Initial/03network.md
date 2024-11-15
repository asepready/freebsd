Initial Settings : Network Settings
 	
Change to static IP addres if you use FreeBSD as a network server.
```sh
[1]	The interface name [vtnet0] is different on each environment, replace it to your own one.
root@belajarfreebsd:~# ifconfig
vtnet0: flags=1008843<UP,BROADCAST,RUNNING,SIMPLEX,MULTICAST,LOWER_UP> metric 0 mtu 1500
        options=4c07bb<RXCSUM,TXCSUM,VLAN_MTU,VLAN_HWTAGGING,JUMBO_MTU,VLAN_HWCSUM,TSO4,TSO6,LRO,VLAN_HWTSO,LINKSTATE,TXCSUM_IPV6>
        ether 52:54:00:63:92:e4
        inet 10.0.0.251 netmask 0xffffff00 broadcast 10.0.0.255
        inet6 fe80::5054:ff:fe63:92e4%vtnet0 prefixlen 64 scopeid 0x1
        media: Ethernet autoselect (10Gbase-T <full-duplex>)
        status: active
        nd6 options=23<PERFORMNUD,ACCEPT_RTADV,AUTO_LINKLOCAL>
lo0: flags=1008049<UP,LOOPBACK,RUNNING,MULTICAST,LOWER_UP> metric 0 mtu 16384
        options=680003<RXCSUM,TXCSUM,LINKSTATE,RXCSUM_IPV6,TXCSUM_IPV6>
        inet 127.0.0.1 netmask 0xff000000
        inet6 ::1 prefixlen 128
        inet6 fe80::1%lo0 prefixlen 64 scopeid 0x2
        groups: lo
        nd6 options=21<PERFORMNUD,AUTO_LINKLOCAL>

root@belajarfreebsd:~# ee /etc/rc.conf
# set hostname
hostname="belajarfreebsd"
# set static IPv4 address and subnet mask
ifconfig_vtnet0="inet 10.0.0.30/24"
# default gateway
defaultrouter="10.0.0.1"
# if set static IPv6 address, change below
ifconfig_vtnet0_ipv6="inet6 accept_rtadv"
# change to your IPv6 gateway
#ipv6_defaultrouter="::1%vtnet0"
sshd_enable="YES"
moused_nondefault_enable="NO"
# Set dumpdev to "AUTO" to enable crash dumps, "NO" to disable
dumpdev="AUTO"
zfs_enable="YES"

root@belajarfreebsd:~# service netif restart
root@belajarfreebsd:~# ifconfig
vtnet0: flags=1008843<UP,BROADCAST,RUNNING,SIMPLEX,MULTICAST,LOWER_UP> metric 0 mtu 1500
        options=4c07bb<RXCSUM,TXCSUM,VLAN_MTU,VLAN_HWTAGGING,JUMBO_MTU,VLAN_HWCSUM,TSO4,TSO6,LRO,VLAN_HWTSO,LINKSTATE,TXCSUM_IPV6>
        ether 52:54:00:63:92:e4
        inet 10.0.0.30 netmask 0xffffff00 broadcast 10.0.0.255
        inet6 fe80::5054:ff:fe63:92e4%vtnet0 prefixlen 64 scopeid 0x1
        media: Ethernet autoselect (10Gbase-T <full-duplex>)
        status: active
        nd6 options=23<PERFORMNUD,ACCEPT_RTADV,AUTO_LINKLOCAL>
lo0: flags=1008049<UP,LOOPBACK,RUNNING,MULTICAST,LOWER_UP> metric 0 mtu 16384
        options=680003<RXCSUM,TXCSUM,LINKSTATE,RXCSUM_IPV6,TXCSUM_IPV6>
        inet 127.0.0.1 netmask 0xff000000
        inet6 ::1 prefixlen 128
        inet6 fe80::1%lo0 prefixlen 64 scopeid 0x2
        groups: lo
        nd6 options=21<PERFORMNUD,AUTO_LINKLOCAL>

root@belajarfreebsd:~# ee /etc/resolv.conf
# set DNS search base and name servers
search belajarfreebsd.or.id
nameserver 8.8.8.8