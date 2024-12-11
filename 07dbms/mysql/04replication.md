MariaDB 10.11 : Replication
 	
Configure MariaDB Replication. This is the general Primary/Replica setting.

[1]	
On all Hosts, Install and Start MariaDB Server, refer to here.

[2]	Change settings and create a user for replication on MariaDB Primary Host.
```sh
root@www:~ # vi /usr/local/etc/mysql/conf.d/server.cnf
# line 18 : change to IP of this host
bind-address = 10.0.0.31
# line 25 : add unique server ID
server-id = 101
# line 26 : add the line
log_bin = /var/log/mysql/mysql-bin.log
root@www:~ # service mysql-server restart
root@www:~ # mysql
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 3
Server version: 10.11.6-MariaDB FreeBSD Ports

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

# create user (set any password for [password] section)
root@localhost [(none)]> grant replication slave on *.* to replica@'%' identified by 'password'; 
Query OK, 0 rows affected (0.00 sec)

root@localhost [(none)]> exit
Bye
```
[3]	Change settings on Replica Host.
```sh
root@node01:~ # vi /usr/local/etc/mysql/conf.d/server.cnf
# line 18 : change to IP of this host
bind-address            = 10.0.0.51

# line 25 : add unique server ID  (different one from Primary Host)
server-id               = 102

# line 26 : add follows
log_bin                 = /var/log/mysql/mysql-bin.log
read_only               = 1
# specify this hostname
report-host             = node01.srv.world
root@node01:~ # service mysql-server restart
```
[4]	Get Dump-Data on Primary Primary Host.
After getting Data, transfer it to Replica Hosts with [sftp] or [rsync] and so on.
```sh
# create a directory and get Backup Data
root@www:~ # mkdir /home/mariadb_backup
root@www:~ # mariabackup --backup --target-dir /home/mariadb_backup -u root
.....
.....
[00] 2024-02-02 14:29:53         ...done
[00] 2024-02-02 14:29:53 Redo log (from LSN 49856 to 49872) was copied.
[00] 2024-02-02 14:29:53 completed OK!
[5]	On Replica Host, Copy back Backup Data of Primary Host and Configure replication settings.
After starting replication, verify replication works normally to create test database or insert test data and so on.
# stop MariaDB and remove existing data
root@node01:~ # service mysql-server stop
root@node01:~ # rm -rf /var/db/mysql/*
# transferred backup data
root@node01:~ # ls -l mariadb_backup.tar.gz
-rw-r--r-- 1 freebsd freebsd 696163 Feb 2 14:31 mariadb_backup.tar.gz
root@node01:~ # tar zxvf mariadb_backup.tar.gz
# run prepare task before restore task (OK if [completed OK])
root@node01:~ # mariabackup --prepare --target-dir /root/mariadb_backup
.....
.....
2024-02-02 14:33:26 0 [Note] InnoDB: End of log at LSN=49872
[00] 2024-02-02 14:33:26 Last binlog file , position 0
[00] 2024-02-02 14:33:26 completed OK!

# run restore
root@node01:~ # mariabackup --copy-back --target-dir /root/mariadb_backup
.....
.....
[01] 2024-02-02 14:33:40 Copying ./test_database/test_table.frm to /var/db/mysql/test_database/test_table.frm
[01] 2024-02-02 14:33:40         ...done
[01] 2024-02-02 14:33:40 Copying ./xtrabackup_info to /var/db/mysql/xtrabackup_info
[01] 2024-02-02 14:33:40         ...done
[00] 2024-02-02 14:33:40 completed OK!

root@node01:~ # chown -R mysql:mysql /var/db/mysql
root@node01:~ # service mysql-server start
# confirm [File] and [Position] value of logs of primary host
root@node01:~ # cat /root/mariadb_backup/xtrabackup_binlog_info
mysql-bin.000001        328

# set replication
root@node01:~ # mysql
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 4
Server version: 10.11.6-MariaDB-log FreeBSD Ports

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

# master_host = Primary Host IP address
# master_user = replication user ID
# master_password = replication user ID password
# master_log_file = [File] value confirmed above
# master_log_pos = [Position] value confirmed above

root@localhost [(none)]> change master to 
master_host='10.0.0.31',
master_user='replica',
master_password='password',
master_log_file='mysql-bin.000001',
master_log_pos=328;
Query OK, 0 rows affected (0.295 sec)

# start replication
root@localhost [(none)]> start slave; 
Query OK, 0 rows affected (0.00 sec)

# show status
root@localhost [(none)]> show slave status\G 
*************************** 1. row ***************************
                Slave_IO_State: Waiting for master to send event
                   Master_Host: 10.0.0.31
                   Master_User: replica
                   Master_Port: 3306
                 Connect_Retry: 60
               Master_Log_File: mysql-bin.000001
           Read_Master_Log_Pos: 328
                Relay_Log_File: mysqld-relay-bin.000002
                 Relay_Log_Pos: 555
         Relay_Master_Log_File: mysql-bin.000001
              Slave_IO_Running: Yes
             Slave_SQL_Running: Yes
          Replicate_Rewrite_DB:
               Replicate_Do_DB:
           Replicate_Ignore_DB:
            Replicate_Do_Table:
        Replicate_Ignore_Table:
       Replicate_Wild_Do_Table:
   Replicate_Wild_Ignore_Table:
                    Last_Errno: 0
                    Last_Error:
                  Skip_Counter: 0
           Exec_Master_Log_Pos: 328
               Relay_Log_Space: 865
               Until_Condition: None
                Until_Log_File:
                 Until_Log_Pos: 0
            Master_SSL_Allowed: No
            Master_SSL_CA_File:
            Master_SSL_CA_Path:
               Master_SSL_Cert:
             Master_SSL_Cipher:
                Master_SSL_Key:
         Seconds_Behind_Master: 0
 Master_SSL_Verify_Server_Cert: No
                 Last_IO_Errno: 0
                 Last_IO_Error:
                Last_SQL_Errno: 0
                Last_SQL_Error:
   Replicate_Ignore_Server_Ids:
              Master_Server_Id: 101
                Master_SSL_Crl:
            Master_SSL_Crlpath:
                    Using_Gtid: No
                   Gtid_IO_Pos:
       Replicate_Do_Domain_Ids:
   Replicate_Ignore_Domain_Ids:
                 Parallel_Mode: optimistic
                     SQL_Delay: 0
           SQL_Remaining_Delay: NULL
       Slave_SQL_Running_State: Slave has read all relay log; waiting for more updates
              Slave_DDL_Groups: 0
Slave_Non_Transactional_Groups: 0
    Slave_Transactional_Groups: 0
1 row in set (0.000 sec)
```