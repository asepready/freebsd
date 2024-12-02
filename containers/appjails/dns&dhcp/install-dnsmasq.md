Dnsmasq : Install
 	
Install Dnsmasq which is the lightweight DNS forwarder and DHCP Server Software.

[1]	Install Dnsmasq.
```sh
root@belajarfreebsd:~# pkg install -y dnsmasq
```
[2]	Configure Dnsmasq.
```sh
root@belajarfreebsd:~# vi /usr/local/etc/dnsmasq.conf
# line 19 : uncomment
# never forward plain names
domain-needed
# line 21 : uncomment
# never forward addresses in the non-routed address spaces
bogus-priv
# line 53 : uncomment
# query with each server strictly in the order in resolv.conf
strict-order
# line 67 : add setting if you need
# query the specific domain name to the specific DNS server
# the example follows means query [server.education] domain to the [10.0.0.10] server
server=/server.education/10.0.0.10
# line 145 : uncomment to add domain name on hostname automatically
expand-hosts
# line 155 : add to set domain name
domain=belajarfreebsd.or.id
root@belajarfreebsd:~# echo 'dnsmasq_enable="YES"' >> /etc/rc.conf
sysrc dnsmasq_enable="YES"
sysrc dnsmasq_conf="/usr/local/share/appjail/files/dnsmasq.conf"
root@belajarfreebsd:~# service dnsmasq start
```
[3]	For DNS records, add them in [/etc/hosts]. Then, Dnsmasq will answer to queries from clients.
```sh
root@belajarfreebsd:~# vi /etc/hosts
# add DNS entries
10.0.0.30       belajarfreebsd.or.id belajarfreebsd
10.0.0.31       www.belajarfreebsd.or.id www 

root@belajarfreebsd:~# service dnsmasq reload
```
[4]	Verify Name or Address Resolution from a client host in your network.
```sh
root@node01:~ # vi /etc/resolv.conf
# change DNS setting to refer to Dnsmasq Server
nameserver 10.0.0.30

root@node01:~ # dig belajarfreebsd.or.id.

; <<>> DiG 9.18.20 <<>> belajarfreebsd.or.id.
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 58792
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
;; QUESTION SECTION:
;belajarfreebsd.or.id.                 IN      A

;; ANSWER SECTION:
belajarfreebsd.or.id.          0       IN      A       10.0.0.30

;; Query time: 0 msec
;; SERVER: 10.0.0.30#53(10.0.0.30) (UDP)
;; WHEN: Thu Dec 21 10:28:46 JST 2023
;; MSG SIZE  rcvd: 58

root@node01:~ # dig -x 10.0.0.31

; <<>> DiG 9.18.20 <<>> -x 10.0.0.31
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 720
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
;; QUESTION SECTION:
;31.0.0.10.in-addr.arpa.                IN      PTR

;; ANSWER SECTION:
31.0.0.10.in-addr.arpa. 0       IN      PTR     www.belajarfreebsd.or.id.

;; Query time: 0 msec
;; SERVER: 10.0.0.30#53(10.0.0.30) (UDP)
;; WHEN: Thu Dec 21 10:29:31 JST 2023
;; MSG SIZE  rcvd: 78
```