```sh
# Enable Packet filter
sysrc pf_enable="YES"
sysrc pflog_enable="YES"

cat << "EOF" >> /etc/pf.conf
nat-anchor 'appjail-nat/jail/*'
nat-anchor "appjail-nat/network/*"
rdr-anchor "appjail-rdr/*"
EOF
service pf reload
service pf restart
service pflog restart

# Enable forwarding
sysrc gateway_enable="YES"
sysctl net.inet.ip.forwarding=1

# Bootstrap a FreeBSD version
appjail fetch

# Create a virtualnet
appjail network add wazuh-net 172.16.0.0/24

# edit /etc/pf.conf
echo 'pass out quick on wazuh-net inet proto { tcp udp } from 172.16.0.2 to any' >> /etc/pf.conf 

# Create a lightweight container system
appjail makejail -f gh+alonsobsd/wazuh-makejail -j wazuh -- --network wazuh-net --server_ip 172.16.0.2
