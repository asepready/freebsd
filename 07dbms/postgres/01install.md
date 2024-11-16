PostgreSQL 15 : Install
 	
Install PostgreSQL to configure database server.

[1]	Install and start PostgreSQL.
```sh
root@www:~# pkg install -y postgresql15-server
root@www:~# sysrc postgresql_enable="YES"
root@www:~# /usr/local/etc/rc.d/postgresql initdb
The files belonging to this database system will be owned by user "postgres".
This user must also own the server process.

.....
.....

root@www:~# service postgresql start
2024-02-09 15:40:37.963 JST [984] LOG: ending log output to stderr
2024-02-09 15:40:37.963 JST [984] HINT: Future log output will go to log destination "syslog".
```
[2]	By default setting, it's possible to connect to PostgreSQL Server only from Localhost. Refer to the official site below about details of authentication methods. ⇒ https://www.postgresql.jp/document/10/html/auth-pg-hba-conf.html
```sh
# listen only localhost by default
root@www:~# grep listen_addresses /var/db/postgres/data15/postgresql.conf
#listen_addresses = 'localhost' # what IP address(es) to listen on;
# change authentication methods because default setting is insecure
root@www:~# cp -p /var/db/postgres/data15/pg_hba.conf /var/db/postgres/data15/pg_hba.conf.org
root@www:~# cat > /var/db/postgres/data15/pg_hba.conf <<'EOF'
local   all             all                                     peer
host    all             all             127.0.0.1/32            ident
host    all             all             ::1/128                 ident
local   replication     all                                     peer
host    replication     all             127.0.0.1/32            ident
host    replication     all             ::1/128                 ident
EOF 

root@www:~# service postgresql restart
```
[3]	Add PostgreSQL user and its Database with PostgreSQL admin user.
```sh
# add OS user
root@www:~# pw useradd freebsd -m
root@www:~# passwd freebsd
# add PostgreSQL user that name is the same with OS user
root@www:~# su - postgres
$ createuser freebsd
$ createdb testdb -O freebsd
# show users and databases
$ psql -c "select usename from pg_user;"
 usename
----------
 postgres
 freebsd
(2 rows)

$ psql -l
                                                   List of databases
   Name    |  Owner   | Encoding | Locale Provider | Collate |  Ctype  | ICU Locale | ICU Rules |   Access privileges
-----------+----------+----------+-----------------+---------+---------+------------+-----------+-----------------------
 postgres  | postgres | UTF8     | libc            | C.UTF-8 | C.UTF-8 |            |           |
 template0 | postgres | UTF8     | libc            | C.UTF-8 | C.UTF-8 |            |           | =c/postgres          +
           |          |          |                 |         |         |            |           | postgres=CTc/postgres
 template1 | postgres | UTF8     | libc            | C.UTF-8 | C.UTF-8 |            |           | =c/postgres          +
           |          |          |                 |         |         |            |           | postgres=CTc/postgres
 testdb    | freebsd  | UTF8     | libc            | C.UTF-8 | C.UTF-8 |            |           |
(4 rows)
```
[4]	Try to connect to PostgreSQL Database with a user added above.
```sh
# connect to testdb
sysadmin@www:~ $ psql testdb
psql (15.5)
Type "help" for help.

# show user roles
testdb=> \du
                             List of roles
 Role name |                         Attributes
-----------+------------------------------------------------------------
 freebsd   |
 postgres  | Superuser, Create role, Create DB, Replication, Bypass RLS

# show databases
testdb=> \l
                                                   List of databases
   Name    |  Owner   | Encoding | Locale Provider | Collate |  Ctype  | ICU Locale | ICU Rules |   Access privileges
-----------+----------+----------+-----------------+---------+---------+------------+-----------+-----------------------
 postgres  | postgres | UTF8     | libc            | C       | C.UTF-8 |            |           |
 template0 | postgres | UTF8     | libc            | C       | C.UTF-8 |            |           | =c/postgres          +
           |          |          |                 |         |         |            |           | postgres=CTc/postgres
 template1 | postgres | UTF8     | libc            | C       | C.UTF-8 |            |           | =c/postgres          +
           |          |          |                 |         |         |            |           | postgres=CTc/postgres
 testdb    | freebsd  | UTF8     | libc            | C       | C.UTF-8 |            |           |
(4 rows)

# create a test table
testdb=> create table test_table (no int, name text); 
CREATE TABLE

# show tables
testdb=> \dt 
           List of relations
 Schema |    Name    | Type  |  Owner
--------+------------+-------+---------
 public | test_table | table | freebsd
(1 row)

# insert data to test table
testdb=> insert into test_table (no,name) values (01,'FreeBSD'); 
INSERT 0 1

# confirm
testdb=> select * from test_table; 
 no |  name
----+---------
  1 | FreeBSD
(1 row)

# remove test table
testdb=> drop table test_table; 
DROP TABLE

testdb=> \dt 
Did not find any relations.

# exit
testdb=> \q 

# remove testdb
sysadmin@www:~ $ dropdb testdb
sysadmin@www:~ $ psql -l
                                                   List of databases
   Name    |  Owner   | Encoding | Locale Provider | Collate |  Ctype  | ICU Locale | ICU Rules |   Access privileges
-----------+----------+----------+-----------------+---------+---------+------------+-----------+-----------------------
 postgres  | postgres | UTF8     | libc            | C       | C.UTF-8 |            |           |
 template0 | postgres | UTF8     | libc            | C       | C.UTF-8 |            |           | =c/postgres          +
           |          |          |                 |         |         |            |           | postgres=CTc/postgres
 template1 | postgres | UTF8     | libc            | C       | C.UTF-8 |            |           | =c/postgres          +
           |          |          |                 |         |         |            |           | postgres=CTc/postgres
(3 rows)
```