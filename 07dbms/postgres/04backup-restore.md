PostgreSQL 15 : Backup and Restore2024/02/09

For Backup and Restore PostgreSQL Data, it's possible to run with [pg_dump] and [pg_restore].

[1]	Backup Databases.
```sh
# available types for [--format=*]
#     p = plain (SQL)
#     c = custom (compression)
#     t = tar
#     d = directory

# [freebsd] user takes backup of [testdb]
sysadmin@www:~ $ pg_dump -U freebsd --format=t -d testdb > pg_testdb.tar
sysadmin@www:~ $ ls -l
total 5
-rw-r--r--  1 freebsd freebsd 6656 Feb  9 15:56 pg_testdb.tar


# admin user [postgres] takes backup of all databases
postgres@www:~ $ mkdir ~/backups
postgres@www:~ $ pg_dumpall -f ~/backups/pg_DB_all.sql
postgres@www:~ $ ls -l ~/backups
total 1
-rw-r--r--  1 postgres postgres 3271 Feb  9 15:57 pg_DB_all.sql
```
[2]	Restore Databases.
```sh
# [freebsd] user restores [testdb] database from backup file
sysadmin@www:~ $ pg_restore -U freebsd -d testdb pg_testdb.tar

# admin user [postgres] restores all database from backup file
# if the type of backup file is SQL text, use [psql] command for restoring
postgres@www:~ $ psql -f ~/backups/pg_DB_all.sql
```