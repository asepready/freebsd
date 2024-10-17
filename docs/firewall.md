## Enable Packet Filter (PF)
```sh
#/etc/rc.conf
sysrc pf_enable="YES" # Menjalan Service Start Boot
sysrc pf_flags="" # additional flags for pfctl startup
sysrc pf_rules="/usr/local/etc/pf.conf" # Kastum tempat pf.conf
sysrc pflog_enable="YES" # Menjalan Service Start Boot
sysrc pflog_logfile="/var/log/pflog" # tempat pnyimpan log pflog
sysrc pflog_flags="" # additional flags for pflogd startup
sysrc gateway_enable="YES" # untuk mengaktifkan NAT 
```

## Create FIle 
```sh
#/usr/local/etc/pf.conf
icmp_type = "{ echoreq unreach }"
table <bruteforce> persist
set skip on lo0
scrub in all fragment reassemble max-mss 1440
block all
pass in proto { tcp udp } to port { 22 123 } keep state \
    (max-src-conn 15, max-src-conn-rate 3/1, overload <bruteforce> flush global)
pass out proto tcp to port { 22 80 123 443 110 143 993 }
pass proto udp to port 53 keep state
pass out inet proto icmp icmp-type $icmp_type
#pass in inet proto icmp icmp-type $icmp_type
```

DDOS Part
```sh
table <bruteforce> persist
pass in proto tcp from any to any port ssh flags S/SA keep state \
    (source-track rule, max-src-conn-rate 2/10, overload <bruteforce> flush global)
block drop in quick from <bruteforce> to any
block out quick from any to <bruteforce>
```
pfctl -vnf /usr/local/etc/pf.conf

## Enable forwarding
```sh
sysrc gateway_enable="YES"
sysctl net.inet.ip.forwarding=1
```
## PF can now be started with logging support:
service pf start; service pflog start