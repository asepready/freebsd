DHCP : Configure DHCP Client : FreeBSD
 	
Configure DHCP Client to get IP address from DHCP Server in local network.

[1]	For FreeBSD Clients, Configure like follows.
```sh
root@node01:~# vi /etc/rc.conf
# specify [DHCP] on the following line
ifconfig_vtnet0="DHCP"
root@node01:~# ifconfig
vtnet0: flags=1008843<UP,BROADCAST,RUNNING,SIMPLEX,MULTICAST,LOWER_UP< metric 0 mtu 1500
        options=4c07bb<RXCSUM,TXCSUM,VLAN_MTU,VLAN_HWTAGGING,JUMBO_MTU,VLAN_HWCSUM,TSO4,TSO6,LRO,VLAN_HWTSO,LINKSTATE,TXCSUM_IPV6<
        ether 52:54:00:c6:38:d1
        inet 10.0.0.51 netmask 0xffffff00 broadcast 10.0.0.255
        inet6 fe80::5054:ff:fec6:38d1%vtnet0 prefixlen 64 scopeid 0x1
        media: Ethernet autoselect (10Gbase-T <full-duplex<)
        status: active
        nd6 options=23<PERFORMNUD,ACCEPT_RTADV,AUTO_LINKLOCAL<
.....
.....

root@node01:~# service dhclient restart vtnet0
dhclient not running? (check /var/run/dhclient/dhclient.vtnet0.pid).
Starting dhclient.
DHCPREQUEST on vtnet0 to 255.255.255.255 port 67
DHCPACK from 10.0.0.30
bound to 10.0.0.200 -- renewal in 300 seconds.
```
DHCP : Configure DHCP Client : Windows
 	
Configure DHCP Client on Windows computer. This example is based on Windows 11.

[2]	Right-click the start button and open the [Network connection], and then click the [Properties].

[3]	That's OK if [IP assignment] is [DHCP]. If not, click the [Edit] button.

[4]	If clicked [Edit] button on previous section, following window is shown. Select [Automatic (DHCP)] and save.

[5]	Confirm the Network connection status, that's OK if IP is assigned.
