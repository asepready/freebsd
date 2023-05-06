# DHCP Server FreeBSD
<p align="center">
<img src="./../assets/images/logo.png" alt="Logo" style="width:200px;"/>
</p>

## Persiapan
| Komponen | Deskripsi |
| - | - |
| Hostname | lab-fbsd.edu |
| Interface | em0 |
| Host IP address | 172.16.16.99/24 |
| IP address range | 172.16.16.100 – 172.16.16.254 |
| Internet gateway | 172.16.16.1 |
| DNS server/s | 8.8.8.8, 8.8.4.4, 172.16.16.1 |

## Install Paket yang di butuhkan
```sh
pkg ins isc-dhcp44-server
```
## Lakukan Konfigurasi
```sh term
#/etc/rc.conf
hostname="lab-fbsd.edu"
ifconfig_em0="inet 172.16.16.99 netmask 255.255.255.0"
defaultrouter="172.16.16.1"
sshd_enable=YES
sendmail_enable=NONE
clear_tmp_enable=YES
syslogd_flags="-ss"
dumpdev=NO
```
## Mengkonfigurasi Server DHCP
Periksa dan Cadangkan konfigurasi default setelah server DHCP diinstal
```sh file
cat usr/local/etc/dhcpd.conf #IPv4
cat usr/local/etc/dhcpd6.conf #IPv6

cp usr/local/etc/dhcpd.conf usr/local/etc/dhcpd.conf.old
```
1. Ubah nama-domain dan nama-domain-server di bagian atas file.
    ```sh file
    # option definitions common to all supported networks...
    option domain-name "example.org";
    option domain-name-servers ns1.example.org, ns2.example.org;

    default-lease-time 600;
    max-lease-time 7200;

    # Use this to enble / disable dynamic dns updates globally.
    #ddns-update-style none;
    ```
    menjadi
    ```sh file
    # option definitions common to all supported networks...
    option domain-name "lab-fbsd.edu";
    option domain-name-servers 8.8.8.8, 8.8.4.4;

    default-lease-time 600;
    max-lease-time 7200;
    #default-lease-time 3600;
    #max-lease-time 86400;

    # Use this to enble / disable dynamic dns updates globally.
    ddns-update-style none;
    ```
2. Ubah pada deklarasi panjang ip
    ```sh file
    # This declaration allows BOOTP clients to get dynamic addresses,
    # which we don't really recommend.

    subnet 10.254.239.32 netmask 255.255.255.224 {
      range dynamic-bootp 10.254.239.40 10.254.239.60;
      option broadcast-address 10.254.239.31;
      option routers rtr-239-32-1.example.org;
    }
    ```
    menjadi
    ```sh file
    #range ip
    subnet 172.16.16.0 netmask 255.255.255.0 {
      range 172.16.16.100 172.16.16.254;
      option broadcast-address 172.16.16.255;
      option routers 172.16.16.1;
    }
    ```
Aktifkan & jalankan layanan DHCP server
``` sh file
sysrc dhcpd_enable="YES" #aktifkan
sysrc dhcpd_ifaces="em0" #interface
service isc-dhcpd start
service isc-dhcpd status

cat /var/db/dhcpd/dhcpd.leases # menampilkan database 
```
