DHCP : Configure DHCP Server
 	
Configure DHCP ( Dynamic Host Configuration Protocol ) Server to assign IP addresses to client hosts in local network.
[1]	Install and Configure DHCP. On this example, it shows only for IPv4 configuration.
```sh
root@belajarfreebsd:~# pkg install -y isc-dhcp44-server
root@belajarfreebsd:~# mv /usr/local/etc/dhcpd.conf /usr/local/etc/dhcpd.conf.org
root@belajarfreebsd:~# vi /usr/local/etc/dhcpd.conf
# create new
# specify domain name
option domain-name     "belajarfreebsd.or.id";

# specify DNS server hostname or IP address
option domain-name-servers     ns.belajarfreebsd.or.id;

# default lease time
default-lease-time 600;

# max lease time
max-lease-time 7200;

# this DHCP server to be declared valid
authoritative;

# specify network address and subnetmask
subnet 10.0.0.0 netmask 255.255.255.0 {
    # specify the range of lease IP address
    range dynamic-bootp 10.0.0.200 10.0.0.254;
    # specify broadcast address
    option broadcast-address 10.0.0.255;
    # specify gateway
    option routers 10.0.0.1;
}

root@belajarfreebsd:~# echo 'dhcpd_enable="YES"' >> /etc/rc.conf
root@belajarfreebsd:~# service isc-dhcpd start
```
[2]	It's possible to see leased IP address in the file below from DHCP Server to DHCP Clients.
```sh
root@belajarfreebsd:~# ls -l /var/db/dhcpd
total 14
drwxr-xr-x   2 dhcpd dhcpd uarch    4 Dec 21 09:02 ./
drwxr-xr-x  14 root  wheel uarch   19 Dec 21 09:02 ../
-rw-r--r--   1 dhcpd dhcpd uarch 1147 Dec 21 09:13 dhcpd.leases
-rw-r--r--   1 dhcpd dhcpd uarch    0 Dec 21 09:02 dhcpd.leases~

root@belajarfreebsd:~# cat /var/db/dhcpd/dhcpd.leases
# The format of this file is documented in the dhcpd.leases(5) manual page.
# This lease file was written by isc-dhcp-4.4.3-P1

# authoring-byte-order entry is generated, DO NOT DELETE
authoring-byte-order little-endian;

server-duid "\000\001\000\001-\026=0RT\000c\222\344";

lease 10.0.0.200 {
  starts 4 2023/12/21 00:03:54;
  ends 4 2023/12/21 00:13:54;
  cltt 4 2023/12/21 00:03:54;
  binding state active;
  next binding state free;
  rewind binding state free;
  hardware ethernet 52:54:00:c6:38:d1;
  uid "\001RT\000\3068\321";
  client-hostname "localhost";
}
.....
.....
```