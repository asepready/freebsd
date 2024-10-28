```sh
#
# Calomel.org  -|-  April 2021
#          
# https://calomel.org/freebsd_network_tuning.html
#

zfs_enable="YES"         # enable the ZFS filesystem
clear_tmp_enable="YES"   # clear /tmp on boot
gateway_enable="YES"     # enable firewall/router mode, allow packets to pass between interfaces
keyrate="250.34"         # keyboard delay to 250 ms and repeat to 34 cps

# PF firewall
pf_enable="YES"          # Enable PF (load kernel module as required)
pf_rules="/etc/pf.conf"  # rule set definition file for pf
pf_flags=""              # additional flags for pfctl start up
pflog_enable="YES"       # start pflogd(8)
pflog_logfile="/var/log/pflog" # where pflogd should store the logfile
pflog_flags=""           # additional flags for pflogd start up

hostname="calomel"

# IPv6, force enable IPv6 interfaces before dhcp intilization
#ipv6_activate_all_interfaces="YES"

# DHCP, enable the ISC dual stack dhcp client
#dhclient_program="/usr/local/sbin/dual-dhclient"

# Internet: Disable large receive offload (LRO) and TCP segmentation offload
# (TSO) support if this server is a Network Address Translation (NAT) firewall
# or router. Depending on the network interface you may need to force disable
# transmit checksums (-txcsum) in order to disable TCP segmentation offload
# (TSO) even if "-tso" is defined. Chelsio cards require "-txcsum" in order to
# also disable TSO as seen in the logs, "cxl0: tso4 disabled due to -txcsum."
#
# Receive and Transmit hardware checksum support is safe to keep enabled on a
# firewall (rxcsum and txcsum). But, we would argue, the firmware on consumer
# grade one(1) gigabit network interfaces are probably years out of date, so
# you may want to concider disabling hardware checksum support as to not incur
# firmware vulnerabilities and driver-to-hardware inefficiencies at the cost of
# a negligible increase in CPU usage.
#
ifconfig_igb0="dhcp ether 00:07:43:2a:4b:6c -rxcsum -rxcsum6 -txcsum -txcsum6 -lro -tso -vlanhwtso"
#
#ifconfig_igb0_ipv6="inet6 dhcp accept_rtadv -rxcsum6 -txcsum6"
#ifconfig_igb0="dhcp -rxcsum -rxcsum6 -txcsum -txcsum6 -lro -tso -vlanhwtso"

# LAN: define any private, non-routable IPv4 and IPv6 address. Disable LRO,
# TSO and hardware checksum support.
#
ifconfig_igb1="inet 10.10.10.1/24 -rxcsum -rxcsum6 -txcsum -txcsum6 -lro -tso -vlanhwtso"
#
#ifconfig_igb1_ipv6="inet6 fddd::1/64 -rxcsum6 -txcsum6"
#ifconfig_igb1="inet 10.10.10.1/24 -rxcsum -rxcsum6 -txcsum -txcsum6 -lro -tso -vlanhwtso"

# daemons disabled
dumpdev="NO"
sendmail_enable="NONE"

# daemons enabled
#chronyd_enable="YES"
#dhcpd_enable="YES"
#dhcpd_flags="igb1"
#entropy_file="/var/db/entropy-file"
#unbound_enable="YES"
#postfix_enable="YES"
#sshd_enable="YES"
#syslogd_flags="-ss"

### DISABLED FOR REFERENCE ###

# deamons
#postgrey_enable="YES"
#postgrey_flags="--greylist-text=\"GREYLIST\" --delay=870 --unix=/var/run/postgrey/postgrey.sock"

# ipv6 lan static
#ipv6_activate_all_interfaces="YES"
#ifconfig_igb1_ipv6="inet6 fddd::1/64 -lro -tso"
#ipv6_defaultrouter="fddd::1"

# wireless, https://calomel.org/freebsd_wireless_access_point.html
#wlans_ath0="wlan0"
#create_args_wlan0="wlanmode hostap"
#hostapd_enable="YES"
#ifconfig_wlan0="inet 10.0.100.1 netmask 255.255.255.0"

# Security Level (kern.securelevel) Note: updates cannot be installed when the
# system securelevel is greater than zero.
#kern_securelevel_enable="YES"
#kern_securelevel="2"

### EOF ###