BIND : Verify Resolution

[1]	Start named service.
```sh
root@belajarfreebsd:~# echo 'named_enable="YES"' >> /etc/rc.conf
root@belajarfreebsd:~# service named start
wrote key file "/usr/local/etc/namedb/rndc.key"
Starting named.
```
[2]	Change DNS setting to refer to your server if need.
```sh
root@belajarfreebsd:~# vi /etc/resolv.conf
# change to y our DNS servers
search belajarfreebsd.or.id
nameserver 10.0.0.30
```
[3]	Verify Name and Address Resolution. If [ANSWER SECTION] is shown, that's OK.
```sh
root@belajarfreebsd:~# dig ns.belajarfreebsd.or.id.

; <<>> DiG 9.18.20 <<>> ns.belajarfreebsd.or.id.
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 37149
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: b5a1836a18b4839a010000006582414e5c2ae7ceea002657 (good)
;; QUESTION SECTION:
;ns.belajarfreebsd.or.id.                 IN      A

;; ANSWER SECTION:
ns.belajarfreebsd.or.id.          86400   IN      A       10.0.0.30

;; Query time: 0 msec
;; SERVER: 10.0.0.30#53(10.0.0.30) (UDP)
;; WHEN: Wed Dec 20 10:20:14 JST 2023
;; MSG SIZE  rcvd: 86

root@belajarfreebsd:~# dig -x 10.0.0.30

; <<>> DiG 9.18.20 <<>> -x 10.0.0.30
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 46843
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: 44483ecdccafc9140100000065824170a8abb44dc5397688 (good)
;; QUESTION SECTION:
;30.0.0.10.in-addr.arpa.                IN      PTR

;; ANSWER SECTION:
30.0.0.10.in-addr.arpa. 86400   IN      PTR     ns.belajarfreebsd.or.id.

;; Query time: 0 msec
;; SERVER: 10.0.0.30#53(10.0.0.30) (UDP)
;; WHEN: Wed Dec 20 10:20:48 JST 2023
;; MSG SIZE  rcvd: 106
```