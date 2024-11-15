BIND : Set Alias (CNAME)
 	
If you'd like to set Alias (Another Name) to a Host, set CNAME record in a zone file.

[1]	Set [CNAME] record in a zone file.
```sh
root@belajarfreebsd:~# vi /usr/local/etc/namedb/primary/belajarfreebsd.or.id.lan
$TTL 86400
@   IN  SOA     ns.belajarfreebsd.or.id. root.belajarfreebsd.or.id. (
        ;; update serial number
        2023122002  ;Serial
        3600        ;Refresh
        1800        ;Retry
        604800      ;Expire
        86400       ;Minimum TTL
)
        IN  NS      ns.belajarfreebsd.or.id.
        IN  A       10.0.0.30
        IN  MX 10   ns.belajarfreebsd.or.id.

dlp     IN  A       10.0.0.30
www     IN  A       10.0.0.31

;; [Alias] IN CNAME [Original Name]
ftp     IN  CNAME   ns.belajarfreebsd.or.id.

root@belajarfreebsd:~# rndc reload
server reload successful
# verify resolution
root@belajarfreebsd:~# dig ftp.belajarfreebsd.or.id.

; <<>> DiG 9.18.20 <<>> ftp.belajarfreebsd.or.id.
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 15239
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: f5ff3ca286ad282d01000000658249f29d8877399fbc119c (good)
;; QUESTION SECTION:
;ftp.belajarfreebsd.or.id.                 IN      A

;; ANSWER SECTION:
ftp.belajarfreebsd.or.id.          86400   IN      CNAME   ns.belajarfreebsd.or.id.
dlp.belajarfreebsd.or.id.          86400   IN      A       10.0.0.30

;; Query time: 0 msec
;; SERVER: 10.0.0.30#53(10.0.0.30) (UDP)
;; WHEN: Wed Dec 20 10:57:06 JST 2023
;; MSG SIZE  rcvd: 104