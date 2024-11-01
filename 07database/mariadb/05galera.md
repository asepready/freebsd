MariaDB 10.11 : Galera Cluster2024/02/02
 	
Configure MariaDB Galera Cluster.
All nodes in cluster become Master-Server on this Multi-Master configuration.

[1]	
Install MariaDB on all nodes, refer to here.

[2]	Configure a 1st node like follows.
```sh
root@www:~ # service mysql-server stop
root@www:~ # vi /usr/local/etc/mysql/conf.d/server.cnf
# line 18 : comment out
#bind-address = 127.0.0.1
# add to last line
[galera]
wsrep_on=ON
wsrep_provider=/usr/local/lib/libgalera_smm.so
wsrep_cluster_address="gcomm://"
binlog_format=row
default_storage_engine=InnoDB
innodb_autoinc_lock_mode=2
bind-address=0.0.0.0
# any cluster name
wsrep_cluster_name="MariaDB_Cluster"
# server IP address
wsrep_node_address="10.0.0.31"

root@www:~ # echo 'mysql_args="--wsrep-new-cluster"' >> /etc/rc.conf
root@www:~ # service mysql-server start
root@www:~ # sed -i -e '/^mysql_args/d' /etc/rc.conf
root@www:~ # vi /usr/local/etc/mysql/conf.d/server.cnf
# add nodes you plan to set in cluster
wsrep_cluster_address="gcomm://10.0.0.31,10.0.0.51"
```
[3]	Configure other nodes except a 1st node.
```sh
root@node01:~ # service mysql-server stop
root@node01:~ # vi /usr/local/etc/mysql/conf.d/server.cnf
# line 18 : comment out
#bind-address = 127.0.0.1
# add to last line
[galera]
wsrep_on=ON
wsrep_provider=/usr/local/lib/libgalera_smm.so
# specify all nodes in cluster
wsrep_cluster_address="gcomm://10.0.0.31,10.0.0.51"
binlog_format=row
default_storage_engine=InnoDB
innodb_autoinc_lock_mode=2
bind-address=0.0.0.0
# any cluster name
wsrep_cluster_name="MariaDB_Cluster"
# specify server IP address
wsrep_node_address="10.0.0.51"

root@node01:~ # service mysql-server start
```
[4]	That's OK. Make sure the status like follows. It's OK if [wsrep_local_state_comment] is [Synced].
```sh
root@node01:~ # mysql
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 8
Server version: 10.11.6-MariaDB FreeBSD Ports

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

root@localhost [(none)]> show status like 'wsrep_%'; 
+-------------------------------+----------------------------------------------------+
| Variable_name                 | Value                                              |
+-------------------------------+----------------------------------------------------+
| wsrep_local_state_uuid        | 4224b63c-c19a-11ee-9c53-4a9062092178               |
| wsrep_protocol_version        | 10                                                 |
| wsrep_last_committed          | 3                                                  |
| wsrep_replicated              | 0                                                  |
| wsrep_replicated_bytes        | 0                                                  |
| wsrep_repl_keys               | 0                                                  |
| wsrep_repl_keys_bytes         | 0                                                  |
| wsrep_repl_data_bytes         | 0                                                  |
| wsrep_repl_other_bytes        | 0                                                  |
| wsrep_received                | 3                                                  |
| wsrep_received_bytes          | 240                                                |
| wsrep_local_commits           | 0                                                  |
| wsrep_local_cert_failures     | 0                                                  |
| wsrep_local_replays           | 0                                                  |
| wsrep_local_send_queue        | 0                                                  |
| wsrep_local_send_queue_max    | 1                                                  |
| wsrep_local_send_queue_min    | 0                                                  |
| wsrep_local_send_queue_avg    | 0                                                  |
| wsrep_local_recv_queue        | 0                                                  |
| wsrep_local_recv_queue_max    | 1                                                  |
| wsrep_local_recv_queue_min    | 0                                                  |
| wsrep_local_recv_queue_avg    | 0                                                  |
| wsrep_local_cached_downto     | 3                                                  |
| wsrep_flow_control_paused_ns  | 0                                                  |
| wsrep_flow_control_paused     | 0                                                  |
| wsrep_flow_control_sent       | 0                                                  |
| wsrep_flow_control_recv       | 0                                                  |
| wsrep_flow_control_active     | false                                              |
| wsrep_flow_control_requested  | false                                              |
| wsrep_cert_deps_distance      | 0                                                  |
| wsrep_apply_oooe              | 0                                                  |
| wsrep_apply_oool              | 0                                                  |
| wsrep_apply_window            | 0                                                  |
| wsrep_apply_waits             | 0                                                  |
| wsrep_commit_oooe             | 0                                                  |
| wsrep_commit_oool             | 0                                                  |
| wsrep_commit_window           | 0                                                  |
| wsrep_local_state             | 4                                                  |
| wsrep_local_state_comment     | Synced                                             |
| wsrep_cert_index_size         | 0                                                  |
| wsrep_causal_reads            | 0                                                  |
| wsrep_cert_interval           | 0                                                  |
| wsrep_open_transactions       | 0                                                  |
| wsrep_open_connections        | 0                                                  |
| wsrep_incoming_addresses      | 10.0.0.51:3306,10.0.0.31:3306                      |
| wsrep_cluster_weight          | 2                                                  |
| wsrep_desync_count            | 0                                                  |
| wsrep_evs_delayed             |                                                    |
| wsrep_evs_evict_list          |                                                    |
| wsrep_evs_repl_latency        | 8.1142e-05/0.000202894/0.000434747/0.000136301/7   |
| wsrep_evs_state               | OPERATIONAL                                        |
| wsrep_gcomm_uuid              | 340849d7-c19d-11ee-87f7-afa5e2f4dbc5               |
| wsrep_gmcast_segment          | 0                                                  |
| wsrep_applier_thread_count    | 1                                                  |
| wsrep_cluster_capabilities    |                                                    |
| wsrep_cluster_conf_id         | 2                                                  |
| wsrep_cluster_size            | 2                                                  |
| wsrep_cluster_state_uuid      | 4224b63c-c19a-11ee-9c53-4a9062092178               |
| wsrep_cluster_status          | Primary                                            |
| wsrep_connected               | ON                                                 |
| wsrep_local_bf_aborts         | 0                                                  |
| wsrep_local_index             | 0                                                  |
| wsrep_provider_capabilities   | :MULTI_MASTER:CERTIFICATION:PARALLEL_APPLYING..... |
| wsrep_provider_name           | Galera                                             |
| wsrep_provider_vendor         | Codership Oy <info@codership.com>                  |
| wsrep_provider_version        | 4.16(rXXXX)                                        |
| wsrep_ready                   | ON                                                 |
| wsrep_rollbacker_thread_count | 1                                                  |
| wsrep_thread_count            | 2                                                  |
+-------------------------------+----------------------------------------------------+
69 rows in set (0.001 sec)
```