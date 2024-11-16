PostgreSQL 15 : Streaming Replication2024/02/09

Configure PostgreSQL Streaming Replication. This configuration is common Primary/Replica settings.
[1]	Install and start PostgreSQL Server on all Nodes, refer to here [1].

[2]	Configure Primary Node.
```sh
root@www:~# vi /var/db/postgres/data15/postgresql.conf
# line 60 : uncomment and change
listen_addresses = '*'
# line 205 : uncomment
wal_level = replica
# line 210 : uncomment
synchronous_commit = on
# line 308 : uncomment (max number of concurrent connections from streaming clients)
max_wal_senders = 10
# line 322 : uncomment and change
synchronous_standby_names = '*'
root@www:~# vi /var/db/postgres/data15/pg_hba.conf
# add to last line
# host replication [replication user] [allowed network] [authentication method]
host    replication     rep_user        10.0.0.30/32            scram-sha-256
host    replication     rep_user        10.0.0.51/32            scram-sha-256

# create a user for replication
root@www:~# su - postgres -c "createuser --replication -P rep_user"
Enter password for new role:   # set any password
Enter it again:
root@www:~# service postgresql restart
```
[3]	Configure Replica Node.
```sh
# stop PostgreSQL and remove existing data
root@node01:~ # service postgresql stop
root@node01:~ # rm -rf /var/db/postgres/data15/*
# get backup from Primary Node
root@node01:~ # su - postgres -c "pg_basebackup -R -h www.srv.world -U rep_user -D /var/db/postgres/data15 -P"
Password:   # password of replication user
31246/31246 kB (100%), 1/1 tablespace
root@node01:~ # vi /var/db/postgres/data15/postgresql.conf
# line 335 : uncomment
hot_standby = on
root@node01:~ # service postgresql start
```
[4]	That's OK if result of the command below on Primary Node is like follows. Verify the setting works normally to create databases or to insert data on Primary Node.
```sh
root@www:~# su - postgres -c 'psql -c "select usename, application_name, client_addr, state, sync_priority, sync_state from pg_stat_replication;"'
 usename  | application_name | client_addr |   state   | sync_priority | sync_state
----------+------------------+-------------+-----------+---------------+------------
 rep_user | walreceiver      | 10.0.0.51   | streaming |             1 | sync
(1 row)
```