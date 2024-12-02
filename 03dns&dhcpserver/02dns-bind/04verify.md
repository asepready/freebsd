BIND : Verify Resolution

[1]	Start named service.
```sh
root@nsx:~# sysrc named_enable="YES"
root@nsx:~# service named start
wrote key file "/usr/local/etc/namedb/rndc.key"
Starting named.
```
[2]	Change DNS setting to refer to your server if need.
```sh
root@nsx:~# vi /etc/resolv.conf
# change to y our DNS servers
search nsx.srv.cnsa
nameserver 192.168.122.100
```
[3]	Verify Name and Address Resolution. If [ANSWER SECTION] is shown, that's OK.
```sh
root@nsx:~# dig nsx.srv.cnsa.

; <<>> DiG 9.20.2 <<>> nsx.srv.cnsa.
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 61354
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: 794264d2f015740e01000000674c7a468f0a352d6f310ac1 (good)
;; QUESTION SECTION:
;nsx.srv.cnsa.                  IN      A

;; ANSWER SECTION:
nsx.srv.cnsa.           86400   IN      A       192.168.122.100

;; Query time: 0 msec
;; SERVER: 192.168.122.100#53(192.168.122.100) (UDP)
;; WHEN: Sun Dec 01 22:01:26 WIB 2024
;; MSG SIZE  rcvd: 85

root@nsx:~# dig -x 192.168.122.100

; <<>> DiG 9.20.2 <<>> -x 192.168.122.100
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 6879
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: de06928bcf35bee001000000674c7ac1d0891e8679818e63 (good)
;; QUESTION SECTION:
;100.122.168.192.in-addr.arpa.  IN      PTR

;; ANSWER SECTION:
100.122.168.192.in-addr.arpa. 86400 IN  PTR     nsx.srv.cnsa.

;; Query time: 0 msec
;; SERVER: 192.168.122.100#53(192.168.122.100) (UDP)
;; WHEN: Sun Dec 01 22:03:29 WIB 2024
;; MSG SIZE  rcvd: 111
```