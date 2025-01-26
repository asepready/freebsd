#!/bin/sh
##################################################################
##################################################################
#
#     The FreeBSD System Hardening Script
#     David Childers - 15 February, 2010
#
#     This software is released under the Attribution-ShareAlike version 3.0 Licence.
#     www.creativecommons.org/licenses/by-sa/3.0/
#
#     Article: http://www.bsdguides.org/2005/hardening-freebsd/
#
##################################################################
##################################################################
#
#     Portions of the script that are marked with bold face type require additional steps to be
#     performed.  If these additional steps are not completed, then the changes initiated by this
#     script will not function properly.
#
##################################################################
##################################################################
#
#     This script can be used with either an i386 or amd64 computer.
#
##################################################################
##################################################################
#
#      The file rc.conf contains descriptive information about the local host name, configuration details for
#      any potential network interfaces and which services should be started up at system initial boot time.
#
#      Ensure syslogd does not bind to a network socket if you are not logging into a remote machine.
#
echo 'syslogd_flags="-ss"' >> /etc/rc.conf
#
#      ICMP Redirect messages can be used by attackers to redirect traffic and should be ignored.
#
echo 'icmp_drop_redirect="YES"' >> /etc/rc.conf
#
#      sendmail is an insecure service and should be disabled.
#
echo 'sendmail_enable="NO"' >> /etc/rc.conf
#
#       The Internet Super Server (inetd) allows a number of simple Internet services to be enabled, including
#       finger, ftp ssh, and telnetd.  Enabling these services may increase risk of security problems by
#       increasing the exposure of your system.
#
echo 'inetd_enable="NO"' >> /etc/rc.conf
#
#      Network File System allows a system to share directories and files with other computers over a network
#      and should be disabled.
#
echo 'nfs_server_enable="NO"' >> /etc/rc.conf
#
echo 'nfs_client_enable="NO"' >> /etc/rc.conf
#
#      SSHD is a family of applications that can used with network connectivity tools.
#      This disables rlogin, RSH, RCP and telenet.
#
echo 'sshd_enable="NO"' >> /etc/rc.conf
#
#      Disable portmap if you are not running Network File Systems.
#
echo 'portmap_enable="NO"' >> /etc/rc.conf
#
#      Disable computer system details from being added to /etc/motd on system reboot.
#
echo 'update_motd="NO"' >> /etc/rc.conf
#
#      The /tmp directory should be cleared at startup to ensure that any malicious code that may have
#      entered into the temp file is removed.
#
echo 'clear_tmp_enable="YES"' >> /etc/rc.conf
#
##################################################################
##################################################################
#
#      The sysctl.conf file allows you to configure various aspects of a FreeBSD computer. This includes many
#      advanced options of the TCP/IP stack and virtual memory system that can dramatically improve
#      performance.
#
#      Prevent users from seeing information about processes that are being run under another UID.
#
echo 'security.bsd.see_other_uids=0' >> /etc/sysctl.conf
#
#      Generate a random ID for the IP packets as opposed to incrementing them by one.
#
echo 'net.inet.ip.random_id=1' >> /etc/sysctl.conf
#
#      This will discover dead connections and clear them.
#
echo 'net.inet.tcp.always_keepalive=1' >> /etc/sysctl.conf
#
#      Enabling blackholes for udp and tcp will drop all packets that are received on a closed port and will not
#      give a reply.
#
echo 'net.inet.tcp.blackhole=2' >> /etc/sysctl.conf
echo 'net.inet.udp.blackhole=1' >> /etc/sysctl.conf
#
##################################################################
##################################################################
#
#      The TCP/IP Stack is what controls the communication of the computer on a data network.
#
#      Disable ICMP broadcast echo activity.  This could allow the computer to be used as part of a Smurf
#      attack.
#
sysctl -w net.inet.icmp.bmcastecho=0
#
#      Disable ICMP routing redirects.  This could allow the computer to have its routing table corrupted by an
#      attacker.
#
sysctl -w net.inet.ip.redirect=0
sysctl -w net.inet.ip6.redirect=0
#
#     Disable ICMP broadcast probes.  This could allow an attacker to reverse engineer details of your
#     network infrastructure.
#
sysctl -w net.inet.icmp.maskrepl=0
#
#     Disable IP source routing.  This could allow attackers to spoof IP addresses that you normally trust as
#     internal hosts.
#
sysctl -w net.inet.ip.sourceroute=0
sysctl -w net.inet.ip.accept_sourceroute=0
#
##################################################################
##################################################################
#
#     Disable users from having access to configuration files.
#
chmod o= /etc/fstab
chmod o= /etc/ftpusers
chmod o= /etc/group
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
#
##################################################################
##################################################################
#
#      Enable root as the only account with the ability to schedule jobs.
#
echo "root" > /var/cron/allow
echo "root" > /var/at/at.allow
chmod o= /etc/crontab
chmod o= /usr/bin/crontab
chmod o= /usr/bin/at
chmod o= /usr/bin/atq
chmod o= /usr/bin/atrm
chmod o= /usr/bin/batch
#
##################################################################
##################################################################
#
#     Secure the root directory contents to prevent viewing.
#
chmod 710 /root
#
##################################################################
##################################################################
#
#     Disable user from having access to the system log file directory.
#
chmod o= /var/log
#
##################################################################
##################################################################
#
#     Merge all temporary file directories.
#
#     A single directory should be used for temporary files, not two.
#     The /var/tmp directory will be replaced with a link to /tmp.
#
#     The contents of the /var/tmp directory remain after a reboot.  The contents of the /tmp directory do not.
#
mv /var/tmp/* /tmp/
rm -rf /var/tmp
ln -s /tmp /var/tmp
#
##################################################################
##################################################################
#
#     Enable the use of blowfish password encryption for enhanced password security.
#
##########
##########
##
##     (#indicates a typed command.)
##
##     Manually edit /etc/auth.conf
##     # nano /etc/auth.conf
##
##     The following lines needs to be added to the /etc/auth.conf file
##     crypt_default=blf
##
##     Manually edit /etc/login.conf
##     # nano /etc/login.conf
##
##     The password format must be changed from md5 to blf.
##     passwd_format="blf"
##
##########
##########
#
##################################################################
##################################################################
#
#        Secure FreeBSD in single user mode
#
##########
##########
##
##     (#indicates a typed command.)
##
##    Edit the /etc/ttys file:
##    # nano /etc/ttys
##
##    Find this line in the /etc/ttys file
##    console none   unknown off secure
##
##    change the secure to insecure
##    console none   unknown off insecure
##
##    Insecure indicates that the console can be accessed by unauthorized persons, and is not
##    secure.
##
##    After rebooting and entering single user mode, the user will be prompted for a password to
##    gain access to the shell prompt.
##
##########
##########
#
##################################################################
##################################################################
#
#     Installing and configuring the Network Time Protocol service.
#
##########
##########
##
##     This will enable ntpdate, which will keep the computer date/time correct.
##
##     (#indicates a typed command.)
##
##     Manually edit /etc/rc.conf
##     # nano /etc/rc.conf
##
##     The following line needs to be placed in the /etc/rc.conf file
##     ntpdate_enable="YES"
##
##     Select the appropriate ntp server for your location.
##     psp2.ntp.org/bin/view/Servers/WebHome
##
##     Manually edit /etc/ntp.conf
##     # nano /etc/ntp.conf
##
##     The following lines need to be added to the file:
##     (Based upon the ntp server preferences you selected from the list.)
##
##     server ntplocal.example.com prefer
##     server timeserver.example.org
##     server ntp2a.example.net
##     driftfile /var/db/ntp.drift
##
##     The server option specifies which servers are to be used, with one server listed on each
##     line. If a server is specified with the prefer argument, as with ntplocal.example.com, that
##     server is preferred over other servers. A response from a preferred server will be
##     discarded if it differs significantly from other servers' responses, otherwise it will be used
##     without any consideration to other responses. The prefer argument is normally used for
##     NTP servers that are known to be highly accurate, such as those with special time
##     monitoring hardware.
##
##     The driftfile option specifies which file is used to store the system clock's frequency offset.
##
##########
##########
#
##################################################################
##################################################################
#
echo  "End of script."
#