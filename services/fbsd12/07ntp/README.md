<p align="center">
<img src="/assets/images/logo.png" alt="Debian Logo" style="width:200px;"/>
</p>

## Catatan hasil belajar FreeBSD support versi =>11.* menjalankan service NTP

#### Struktur Folder
```sh
```

1. NTPD on Start up(aktifkan ketika memulai boot)
```sh
sysrc ntpd_enable=yes
sysrc ntpdate_enable=yes
ntpdate id.pool.ntp.org
```
atau buka /etc/rc.conf dan edit:
```sh
ee /etc/rc.conf
```
```sh
#NTP
ntpd_enable="YES"
ntpdate_enable="YES"
ntpdate_hosts="id.pool.ntp.org"
```
2. Buka file /etc/ntp.conf dan edit:
```sh
ee /etc/ntp.conf
```
```sh
# Disallow ntpq control/query access.  Allow peers to be added only
# based on pool and server statements in this file.
restrict default limited kod nomodify notrap noquery nopeer
restrict source  limited kod nomodify notrap noquery

# Allow unrestricted access from localhost for queries and control.
restrict 127.0.0.1
restrict ::1

# Add a specific server.
server ntplocal.example.com iburst

# Add FreeBSD pool servers until 3-6 good servers are available.
tos minclock 3 maxclock 6
pool 0.freebsd.pool.ntp.org iburst

# Use a local leap-seconds file.
leapfile "/var/db/ntpd.leap-seconds.list"
```
3. Menjalankan NTPD Service & Status
```sh
service ntpd start
```

## Sumber belajar
1. [Clock Synchronization with NTP | ](https://docs.freebsd.org/en/books/handbook/network-servers/#network-ntp)(https://docs.freebsd.org/en/books/handbook/network-servers/#network-ntp)
2. [Cara Setting Time Zone dan Tanggal Otomatis dari NTP Server di FreeBSD](https://musaamin.web.id/cara-setting-time-zone-dan-tanggal-otomatis-dari-ntp-server-di-freebsd/)(https://musaamin.web.id/cara-setting-time-zone-dan-tanggal-otomatis-dari-ntp-server-di-freebsd/)
