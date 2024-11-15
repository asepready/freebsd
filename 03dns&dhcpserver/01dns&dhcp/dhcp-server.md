Dnsmasq : Configure DHCP Server
 	
Enable integrated DHCP feature on Dnsmasq and Configure DHCP Server.

[1]	Configure Dnsmasq.
```sh
root@belajarfreebsd:~# vi /usr/local/etc/dnsmasq.conf
# line 168 : add : range of IP address to lease and term of lease
dhcp-range=10.0.0.200,10.0.0.250,12h
# line 345 : add : define default gateway
dhcp-option=option:router,10.0.0.1
# line 351 : add : define NTP, DNS, server and subnetmask
dhcp-option=option:ntp-server,10.0.0.10
dhcp-option=option:dns-server,10.0.0.10
dhcp-option=option:netmask,255.255.255.0
root@belajarfreebsd:~# service dnsmasq restart