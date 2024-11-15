BIND : DNS over HTTPS : Server Settings

Configure DNS over HTTPS Server on BIND.

[1]	Get SSL/TLS certificate, refer to here.

[2]	Configure BIND.
```sh
root@belajarfreebsd:~# openssl dhparam -out /usr/local/etc/namedb/dhparam.pem 3072
root@belajarfreebsd:~# cp /usr/local/etc/letsencrypt/live/ns.belajarfreebsd.or.id/fullchain.pem /usr/local/etc/namedb/
root@belajarfreebsd:~# cp /usr/local/etc/letsencrypt/live/ns.belajarfreebsd.or.id/privkey.pem /usr/local/etc/namedb/
root@belajarfreebsd:~# chown bind:bind /usr/local/etc/namedb/*.pem
root@belajarfreebsd:~# vi /usr/local/etc/namedb/named.conf
// add settings for certificate
tls local-tls {
        key-file "/usr/local/etc/namedb/privkey.pem";
        cert-file "/usr/local/etc/namedb/fullchain.pem";
        dhparam-file "/usr/local/etc/namedb/dhparam.pem";
};

http local {
        endpoints { "/dns-query"; };
};

options {
.....
.....
        // change like follows
        listen-on tls local-tls http local { any; };
        listen-on-v6 tls local-tls http local { any; };
};

root@belajarfreebsd:~# service named restart
```
[3]	Verify Name Resolution with HTTPS on localhost.
```sh
root@belajarfreebsd:~# dig +https @127.0.0.1 ns.belajarfreebsd.or.id.

; <<>> DiG 9.18.20 <<>> +https @127.0.0.1 ns.belajarfreebsd.or.id.
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 32809
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: 6503da58d1b6a58e0100000065826360381b930bb82ce034 (good)
;; QUESTION SECTION:
;ns.belajarfreebsd.or.id.                 IN      A

;; ANSWER SECTION:
ns.belajarfreebsd.or.id.          86400   IN      A       10.0.0.30

;; Query time: 0 msec
;; SERVER: 127.0.0.1#443(127.0.0.1) (HTTPS)
;; WHEN: Wed Dec 20 12:45:36 JST 2023
;; MSG SIZE  rcvd: 86
```