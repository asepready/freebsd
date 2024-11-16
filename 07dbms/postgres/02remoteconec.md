PostgreSQL 15 : Remote Connection
 	
It's possible to connect to PostgreSQL Server only from Localhost by default like here, however if you like to connect to PostgreSQL from Remote hosts, change settings like follows.

[1]	There are many authentication methods on PostgreSQL, though. On this example, Configure scram-sha-256 password method.
```sh
root@www:~# vi /var/db/postgres/data15/postgresql.conf
# line 60 : uncomment and change
listen_addresses = '*'
root@www:~# vi /var/db/postgres/data15/pg_hba.conf
local   all             all                                     peer
host    all             all             127.0.0.1/32            ident
host    all             all             ::1/128                 ident
local   replication     all                                     peer
host    replication     all             127.0.0.1/32            ident
host    replication     all             ::1/128                 ident
# add to last line
# specify network range you allow to connect on [ADDRESS] section
# if allow all, specify [0.0.0.0/0]
host    all             all             10.0.0.0/24             scram-sha-256

root@www:~# service postgresql restart
```
[2]	To connect to a PostgreSQL Database from remote hosts, set password for each PostgreSQL user.
```sh
# connect to own database
sysadmin@www:~ $ psql -d testdb
psql (15.5)
Type "help" for help.

# set or change own password
testdb=> \password
Enter new password for user "freebsd":
Enter it again:
testdb=> \q

# also possible to set or change password for any users with PostgreSQL admin user
postgres@www:~ $ psql -c "alter user debian with password 'password';"
ALTER ROLE
```
[3]	Verify settings to connect to PostgreSQL Database with password from remote hosts.
```sh
root@node01:~ # psql -h www.srv.world -d testdb -U freebsd
Password for user freebsd:   # password
psql (15.5)
Type "help" for help.

testdb=> # connected
```