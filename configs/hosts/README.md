1. Konfigurasi hostname
- buka dan edit untuk hostname di /etc/rc.conf
```sh
ee /etc/rc.conf
```
```sh
#Set Hosts
hostname="webserver"
```
2. Konfigurasi hosts
  - buka dan edit untuk hostname di /etc/rc.conf
  ```sh
  ee /etc/hosts
  ```
  - Server ip address & Server FQDN
  ```sh
    #Set Hosts
    ::1                     localhost localhost.my.domain
    127.0.0.1               localhost localhost.my.domain
    # I added here
    192.168.122.2           webserverbsd.net webserver
  ```
