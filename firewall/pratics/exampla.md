```sh
nmap -sS -sU -T4 -A -v -PE -PP -PS21,22,23,25,80,113,31339 -PA80,113,443,10042 -PO --script all 192.168.122.254
```
```sh
#/pf.conf
ext_if="em0"
scrub in on $ext_if all fragment reassemble

block all

set skip on lo0
antispoof for $ext_if inet

### filter spoofs
block in quick on $ext_if proto tcp flags FUP/WEUAPRSF
block in quick on $ext_if proto tcp flags WEUAPRSF/WEUAPRSF
block in quick on $ext_if proto tcp flags SRAFU/WEUAPRSF
block in quick on $ext_if proto tcp flags /WEUAPRSF
block in quick on $ext_if proto tcp flags SR/SR
block in quick on $ext_if proto tcp flags SF/SF

### traffic going OUTSIDE
pass out on $ext_if proto { tcp, udp, icmp } from any to any flags any modulate state

### traffic going INSIDE
pass in on $ext_if proto tcp from any to any port ssh flags S/SA
pass in on tap0 
#pass in on $ext_if proto tcp from any to any port www flags S/SA

###  prevent brute force on ssh
table <ssh_abuse> persist
block in log quick from <ssh_abuse>
pass in on $ext_if proto tcp to any port ssh flags S/SA keep state (max-src-conn 10, max-src-conn-rate 3/5, overload <ssh_abuse> flush)
