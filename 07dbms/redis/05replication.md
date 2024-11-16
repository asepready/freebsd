Redis 7 : Configure Replication
 	
Configure Redis Replication. This configuration is general Primary-Replica settings.

[1]	Change Settings on Primary Host.
```sh
root@belajarfreebsd:~# vi /usr/local/etc/redis.conf
# line 87 : change to own IP address or [0.0.0.0]
bind 0.0.0.0 ::1
# line 309 : change (run as daemon)
daemonize yes
# line 789 : add follows if need
# min-replicas-to-write : if number of Replica Hosts are online, Primary Host accepts write requests
# min-replicas-max-lag : decision time(sec) for online if Replica Hosts return answer within specified time
min-replicas-to-write 1
min-replicas-max-lag 10
# line 1037 : authentication password
requirepass password
root@belajarfreebsd:~# service redis restart
```
[2]	Change Settings on Replica Host.
```sh
root@node01:~ # vi /usr/local/etc/redis.conf
# line 87 : change to own IP address or [0.0.0.0]
bind 0.0.0.0
# line 309 : change (run as daemon)
daemonize yes
# line 528 : add Primary Host IP address and port
replicaof 10.0.0.30 6379
# line 546 : add authentication password set on Primary Host
masterauth password
# line 577 : verify parameter (set Replica Hosts read-only)
replica-read-only yes
root@node01:~ # service redis restart
```
[3]	Verify statistics on Replica Hosts, then it's OK if [master_link_status:up] is shown.
```sh
root@node01:~ # redis-cli
127.0.0.1:6379> auth password 
OK

# show statics
127.0.0.1:6379> info Replication 
# Replication
role:slave
master_host:10.0.0.30
master_port:6379
master_link_status:up
master_last_io_seconds_ago:5
master_sync_in_progress:0
slave_read_repl_offset:227
slave_repl_offset:227
slave_priority:100
slave_read_only:1
replica_announced:1
connected_slaves:0
master_failover_state:no-failover
master_replid:aee8fe536bbf502dccc05bdbd787c942ede22eac
master_replid2:0000000000000000000000000000000000000000
master_repl_offset:227
second_repl_offset:-1
repl_backlog_active:1
repl_backlog_size:1048576
repl_backlog_first_byte_offset:15
repl_backlog_histlen:213

# verify to get keys set on Primary Host
127.0.0.1:6379> get key_on_master 
"value_on_master"
```