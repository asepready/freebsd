MariaDB 10.11 : Backup
 	
For Backup and Restore MariaDB Data, it's possible to run with [mariabackup].

[1]	Run Backup.
For example, get backup under [/home/mariadb_backup].
```sh
root@www:~ # mkdir /home/mariadb_backup
root@www:~ # mariabackup --backup --target-dir /home/mariadb_backup -u root
.....
.....
[00] 2024-02-02 13:52:29 mariabackup: The latest check point (for incremental): '49856'
mariabackup: Stopping log copying thread
[00] 2024-02-02 13:52:29 Executing BACKUP STAGE END
[00] 2024-02-02 13:52:29 All tables unlocked
[00] 2024-02-02 13:52:29 Backup created in directory '/home/mariadb_backup/'
[00] 2024-02-02 13:52:29 Writing backup-my.cnf
[00] 2024-02-02 13:52:29         ...done
[00] 2024-02-02 13:52:29 Writing xtrabackup_info
[00] 2024-02-02 13:52:29         ...done
[00] 2024-02-02 13:52:29 Redo log (from LSN 49856 to 49872) was copied.
[00] 2024-02-02 13:52:29 completed OK!

root@www:~ # ls -l /home/mariadb_backup
total 330
-rw-r-----  1 root wheel   417792 Feb  2 13:52 aria_log.00000001
-rw-r-----  1 root wheel       52 Feb  2 13:52 aria_log_control
-rw-r-----  1 root wheel      423 Feb  2 13:52 backup-my.cnf
-rw-r-----  1 root wheel    12304 Feb  2 13:52 ib_logfile0
-rw-r-----  1 root wheel 12582912 Feb  2 13:52 ibdata1
drwx------  2 root wheel       90 Feb  2 13:52 mysql
drwx------  2 root wheel        3 Feb  2 13:52 performance_schema
drwx------  2 root wheel      106 Feb  2 13:52 sys
drwx------  2 root wheel        5 Feb  2 13:52 test_database
-rw-r-----  1 root wheel       73 Feb  2 13:52 xtrabackup_checkpoints
-rw-r-----  1 root wheel      432 Feb  2 13:52 xtrabackup_info
```
[2]	For restoring data from backup on another host, run like follows.
Before restoring, transfer backup data to the target host with [rsync] or [scp] and so on.
```sh
# stop MariaDB and remove existing data
root@node01:~ # service mysql-server stop
root@node01:~ # rm -rf /var/db/mysql/*
# transferred backup data
root@node01:~ # ls -l mariadb_backup.tar.gz
-rw-r--r-- 1 freebsd freebsd 694655 Feb 2 14:01 mariadb_backup.tar.gz
root@node01:~ # tar zxvf mariadb_backup.tar.gz
# run prepare task before restore task (OK if [completed OK])
root@node01:~ # mariabackup --prepare --target-dir /root/mariadb_backup
[00] 2024-02-02 14:03:18 cd to /root/mariadb_backup/
[00] 2024-02-02 14:03:18 open files limit requested 0, set to 116244
[00] 2024-02-02 14:03:18 Loading plugins from provider_bzip2=provider_bzip2;provider_lz4=provider_lz4;provider_lzma=provider_lzma
[00] 2024-02-02 14:03:18 Loading plugins
[00] 2024-02-02 14:03:18         Plugin parameter :  '--plugin_load=provider_bzip2=provider_bzip2;provider_lz4=provider_lz4;provider_lzma=provider_lzma'
[00] 2024-02-02 14:03:18         Plugin parameter :  '--prepare'
[00] 2024-02-02 14:03:18         Plugin parameter :  '--target-dir'
[00] 2024-02-02 14:03:18         Plugin parameter :  '/root/mariadb_backup'
[00] 2024-02-02 14:03:18 This target seems to be not prepared yet.
[00] 2024-02-02 14:03:18 mariabackup: using the following InnoDB configuration for recovery:
[00] 2024-02-02 14:03:18 innodb_data_home_dir = .
[00] 2024-02-02 14:03:18 innodb_data_file_path = ibdata1:12M:autoextend
[00] 2024-02-02 14:03:18 innodb_log_group_home_dir = .
[00] 2024-02-02 14:03:18 Starting InnoDB instance for recovery.
[00] 2024-02-02 14:03:18 mariabackup: Using 104857600 bytes for buffer pool (set by --use-memory parameter)
2024-02-02 14:03:18 0 [Note] InnoDB: Compressed tables use zlib 1.3
2024-02-02 14:03:18 0 [Note] InnoDB: Number of transaction pools: 1
2024-02-02 14:03:18 0 [Note] InnoDB: Using crc32 + pclmulqdq instructions
2024-02-02 14:03:18 0 [Note] InnoDB: Initializing buffer pool, total size = 100.000MiB, chunk size = 100.000MiB
2024-02-02 14:03:18 0 [Note] InnoDB: Completed initialization of buffer pool
2024-02-02 14:03:18 0 [Note] InnoDB: End of log at LSN=49872
[00] 2024-02-02 14:03:18 Last binlog file , position 0
[00] 2024-02-02 14:03:18 completed OK!

# run restore
root@node01:~ # mariabackup --copy-back --target-dir /root/mariadb_backup
.....
.....
[01] 2024-02-02 14:04:33 Copying ./test_database/test_table.ibd to /var/db/mysql/test_database/test_table.ibd
[01] 2024-02-02 14:04:33         ...done
[01] 2024-02-02 14:04:33 Copying ./test_database/test_table.frm to /var/db/mysql/test_database/test_table.frm
[01] 2024-02-02 14:04:33         ...done
[01] 2024-02-02 14:04:33 Copying ./performance_schema/db.opt to /var/db/mysql/performance_schema/db.opt
[01] 2024-02-02 14:04:33         ...done
[00] 2024-02-02 14:04:33 completed OK!

root@node01:~ # chown -R mysql:mysql /var/db/mysql
root@node01:~ # service mysql-server start
```