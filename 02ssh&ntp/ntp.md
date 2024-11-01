## Konfigurasi NTPd server
```sh
pkg search ntp
pkg install -y ntp
```
konfigurasi
```sh
#edit file /etc/ntp.conf
# line 32 : comment out default settings and add NTP Servers for your timezone
#pool 0.freebsd.pool.ntp.org iburst
#pool 2.freebsd.pool.ntp.org iburst
pool ntp.nict.jp iburst 

# line 89 : add network range you allow to receive time syncing requests from clients
restrict 10.0.0.0 mask 255.255.255.0 nomodify notrap
root@dlp:~ # service ntpd enable
ntpd enabled in /etc/rc.conf
root@dlp:~ # service ntpd start
Security policy loaded: MAC/ntpd (mac_ntpd)
Starting ntpd.
# verify status
root@dlp:~ # ntpq -p
    remote           refid      st t when poll reach   delay   offset  jitter
==============================================================================
 ntp.nict.jp     .POOL.          16 p    -   64    0    0.000   +0.000   0.000
+ntp-k1.nict.jp  .NICT.           1 u   35   64    1   11.343   -9.364   6.736
*ntp-a3.nict.go. .NICT.           1 u   35   64    1   17.512   -8.837   3.944
-ntp-b2.nict.go. .NICT.           1 u   33   64    1   29.229  -14.034   4.794
+ntp-b3.nict.go. .NICT.           1 u   33   64    1   17.141   -8.294   4.203
+ntp-a2.nict.go. .NICT.           1 u   32   64    1   17.928   -7.993   7.155
```
## Konfigurasi NTPd server
```sh
root@node01:~ # pkg install ntpstat
root@node01:~ # ntpstat
synchronised to NTP server (10.0.0.30) at stratum 3
   time correct to within 90 ms
   polling server every 64 s
```