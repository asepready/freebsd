Message from bind918-9.18.14:

--
BIND requires configuration of rndc, including a "secret"
key.  The easiest, and most secure way to configure rndc is
to run 'rndc-confgen -a' to generate the proper conf file,
with a new random key, and appropriate file permissions.

The /usr/local/etc/rc.d/named script will do that for you.

If using syslog to log the BIND9 activity, and using a
chroot'ed installation, you will need to tell syslog to install
a log socket in the BIND9 chroot by running:

  # sysrc altlog_proglist+=named

And then restarting syslogd with: service syslogd restart