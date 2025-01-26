#Permission File
chmod o= /etc/fstab
chmod o= /etc/ftpusers
chmod o= /etc/group
chmod o= /etc/passwd
chmod o= /etc/hosts
chmod o= /etc/hosts.allow
chmod o= /etc/hosts.equiv
chmod o= /etc/hosts.lpd
chmod o= /etc/inetd.conf
chmod o= /etc/login.access
chmod o= /etc/login.conf
chmod o= /etc/newsyslog.conf
chmod o= /etc/rc.conf
chmod o= /etc/ssh/sshd_config
chmod o= /etc/sysctl.conf
chmod o= /etc/syslog.conf
chmod o= /etc/ttys

echo "root" > /var/cron/allow
echo "root" > /var/at/at.allow
chmod o= /etc/crontab; chmod 710 /etc/crontab
chmod o= /etc/cron.d; chmod 710 /etc/cron.d
chmod o= /usr/bin/at
chmod o= /usr/bin/atq
chmod o= /usr/bin/atrm
chmod o= /usr/bin/batch
chmod o= /usr/bin/crontab

chmod o= /var/log; chmod 710 /var/log 

mv /var/tmp/* /tmp/
rm -rf /var/tmp
ln -s /tmp /var/tmp

# permission directory by User
# Root
chmod -R o= /root; chmod 710 /root

rm -rf /usr/local/home; rm -rf  /home
mkdir /usr/local/home; ln -s /usr/local/home /home; chmod 710 /home;

# Admin (wheel/root)
chmod o= /home/syadmin