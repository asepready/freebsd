Message from cyrus-sasl-2.1.28:

--
You can use sasldb2 for authentication, to add users use:

        saslpasswd2 -c username

If you want to enable SMTP AUTH with the system Sendmail, read
Sendmail.README

NOTE: This port has been compiled with a default pwcheck_method of
      auxprop.  If you want to authenticate your user by /etc/passwd,
      PAM or LDAP, install ports/security/cyrus-sasl2-saslauthd and
      set sasl_pwcheck_method to saslauthd after installing the
      Cyrus-IMAPd 2.X port.  You should also check the
      /usr/local/lib/sasl2/*.conf files for the correct
      pwcheck_method.
      If you want to use GSSAPI mechanism, install
      ports/security/cyrus-sasl2-gssapi.
      If you want to use SRP mechanism, install
      ports/security/cyrus-sasl2-srp.
      If you want to use LDAP auxprop plugin, install
      ports/security/cyrus-sasl2-ldapdb.
=====
Message from groff-1.22.4_4:

--
In order to be able to use the html driver, you need to install the following
packages:
 - ghostscript
 - netpbm
=====
Message from openldap26-client-2.6.4:

--
The OpenLDAP client package has been successfully installed.

Edit
  /usr/local/etc/openldap/ldap.conf
to change the system-wide client defaults.

Try `man ldap.conf' and visit the OpenLDAP FAQ-O-Matic at
  http://www.OpenLDAP.org/faq/index.cgi?file=3
for more information.
=====
Message from mysql57-client-5.7.40:

--
This is the mysql CLIENT without the server.
for complete server and client, please install databases/mysql57-server
--
===>   NOTICE:

This port is deprecated; you may wish to reconsider installing it:

Upstream support ended in October 2019.

It is scheduled to be removed on or after 2023-12-31.
=====
Message from mysql57-server-5.7.40:

--
Initial password for first time use of MySQL is saved in $HOME/.mysql_secret
ie. when you want to use "mysql -u root -p" first you should see password
in /root/.mysql_secret

MySQL57 has a default /usr/local/etc/mysql/my.cnf,
remember to replace it with your own
or set `mysql_optfile="$YOUR_CNF_FILE` in rc.conf.
--
===>   NOTICE:

This port is deprecated; you may wish to reconsider installing it:

Upstream support ended in October 2019.

It is scheduled to be removed on or after 2023-12-31.