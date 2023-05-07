1. Konfigurasi hostname
- buka dan edit untuk hostname di /etc/rc.conf
```sh
#/etc/rc.conf
hostname="lab-FBSD"
```
2. Konfigurasi hosts
```sh
  #Set Hosts
    ::1                     localhost labs.fbsd.edu
    127.0.0.1               localhost labs.fbsd.edu
  # I added here
    192.168.122.2           labs.fbsd.edu lab-FBSD
```
3. Konfigurasi domain
```sh
search google.com
nameserver 8.8.8.8
nameserver 8.8.4.4
```