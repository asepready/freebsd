Hardening System

Edit /etc/ttys make all secure to insecure

Edit /etc/ssh/sshd_config
- ForwardX11=no
- Protocol 2

Single session CMD
umask 027

Edit /etc/login.conf
- passwd_format=blf \ blowfish
- cap_mkdb /etc/login.conf

Edit /etc/rc.conf
#kern_securelevel_enable="YES"
#kern_securelevel="3"
sendmail_enable="NONE"
inetd_enable="NO"
clear_tmp_enable="YES"
syslogd_flags="-ss"
icmp_drop_redirect="YES"
icmp_log_redirect="YES"
nfs_server_enable="NO"
nfs_client_enable="NO"
portmap_enable="NO"
update_motd="NO"
pf_enable="NO"
pf_rules="etc/pf.conf"
pflog_enable="NO"
pflog_logfile="/var/log/pflog"

Edit /etc/sysctl.conf
security.bsd.see_other_uids=0
security.bsd.stack_guard_page=1
net.inet.tcp.blackhole=2
net.inet.udp.blackhole=1
net.inet.ip.random_id=1
kern.securelevel=2
net.inet.tcp.always_keepalive=1
net.inet.ip.redirect=0
net.inet6.ip6.redirect=0

This will stop non-elevated users from viewing or altering these files
chmod 0= /etc/fstab
chmod 0= /etc/ftpusers
chmod 0= /etc/group
chmod 0= /etc/hosts
chmod 0= /etc/hosts.allow
chmod 0= /etc/hosts.equiv
chmod 0= /etc/hosts.lpd
chmod 0= /etc/inetd.conf
chmod 0= /etc/login.access
chmod 0= /etc/login.conf
chmod 0= /etc/newsyslog.conf
chmod 0= /etc/rc.conf
chmod 0= /etc/ssh/sshd_config
chmod 0= /etc/sysctl.conf
chmod 0= /etc/ttys

Only allow root too access or schedule jabs..
Edit /var/cron/allow 
root

Edit /var/at/at.allow
root

Temp File, one dirtory
mv /var/tmp/* /tmp/
rm -rf /var/tmp
ln -s /tmp /var/tmp

blowfish change login add /etc/auth.conf
crypt_default=blf

Firewall /etc/pf.conf
scrub in all

set skip on lo0

block in on em0

pass in on proto icmp
pass in on proto icmp6

pass in on em0 proto tcp from any to any port 22

Test syntax firewall
pfctl -nf /etc/pf.conf