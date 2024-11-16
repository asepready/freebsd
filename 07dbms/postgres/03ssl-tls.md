PostgreSQL 15 : PostgreSQL over SSL/TLS

Enable SSL/TLS connection to PostgreSQL.
[1]	Get SSL/TLS certificate or Create self signed certificate first. It uses self signed certificate on this example.

[2]	Copy certificates and configure PostgreSQL.
```sh
root@www:~# cp /usr/local/etc/ssl/server.* /var/db/postgres/data15/
root@www:~# chown postgres:postgres /var/db/postgres/data15/server.*
root@www:~# chmod 600 /var/db/postgres/data15/server.*
root@www:~# vi /var/db/postgres/data15/postgresql.conf
# line 105 : uncomment and change
ssl = on
# line 107, 110 : uncomment and change to your own certs
ssl_cert_file = 'server.crt'
ssl_key_file = 'server.key'
root@www:~# vi /var/db/postgres/data15/pg_hba.conf
local   all             all                                     peer
host    all             all             127.0.0.1/32            ident
host    all             all             ::1/128                 ident
local   replication     all                                     peer
host    replication     all             127.0.0.1/32            ident
host    replication     all             ::1/128                 ident
host    all             all             10.0.0.0/24             scram-sha-256
# add to last line
# [hostssl] ⇒ use TCP/IP connection only when enabling SSL/TLS
# [10.0.0.0/24] ⇒ allowed network to connect
# [scram-sha-256] ⇒ use SCRAM-SHA-256 password method
hostssl all             all             10.0.0.0/24             scram-sha-256

root@www:~# service postgresql restart
```
[3]	Verify settings to connect to PostgreSQL Database from hosts in network you allowed to connect.
```sh
# no SSL/TLS on Unix socket connection
sysadmin@www:~$ psql testdb
psql (16.1)
Type "help" for help.

testdb=> \q

# on TCP/IP connection, SSL/TLS is enabled
# on SSL/TLS connection, messages [SSL connection ***] is shown
sysadmin@www:~$ psql -h www.srv.world testdb
Password for user freebsd:
psql (16.1)
SSL connection (protocol: TLSv1.3, cipher: TLS_AES_256_GCM_SHA384, compression: off)
Type "help" for help.

testdb=> \q


# SSL/TLS is enabled from other hosts, too
root@node01:~# psql -h www.srv.world -d testdb -U freebsd
Password for user freebsd:
psql (16.1)
SSL connection (protocol: TLSv1.3, cipher: TLS_AES_256_GCM_SHA384, compression: off)
Type "help" for help.

testdb=>
```