Redis 7 : Basic Operation for Server2024/08/23
 	
This is the Basic Usage of Redis with [redis-cli] client program.

Following examples are basic one, you can see more commands on Official Site below. ⇒ https://redis.io/commands

[1]	Connect to Redis Server like follows.
```sh
# connect to local Redis server
root@belajarfreebsd:~# redis-cli

# authenticate  ⇒ specify [password] you set in [redis.conf]
127.0.0.1:6379> auth password 
OK

# exit from connection
127.0.0.1:6379> quit 

# connect with password and database ID
# -a [password] -n [database ID]
# -a [password] on terminal is not safe, so warnings is shown
# if database ID is not specified, connect to database ID [0]
root@belajarfreebsd:~# redis-cli -a password -n 1 
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.

# if not display auth warnings above, add [--no-auth-warning] option
root@belajarfreebsd:~# redis-cli -a password -n 1 --no-auth-warning 

# change to Database-ID [2]
127.0.0.1:6379[1]> select 2 
OK
127.0.0.1:6379[2]> quit 

# to connect to Redis on another Host, specify [-h (hostname)]
root@belajarfreebsd:~# redis-cli -h node01.srv.world 
node01.srv.world:6379>

# possible to get results with non-interactively with [redis-cli]
# for example, set and get Value of a Key
root@belajarfreebsd:~# redis-cli -a password --no-auth-warning set key01 value01 
root@belajarfreebsd:~# redis-cli -a password --no-auth-warning get key01 
"value01"
```
[2]	This is the basic Usage of control Redis Server itself.
```sh
root@belajarfreebsd:~# redis-cli
127.0.0.1:6379> auth password 
OK

# refer to statics
127.0.0.1:6379> info 
# Server
redis_version:7.0.15
redis_git_sha1:00000000
redis_git_dirty:0
redis_build_id:acbb172d25191eda
redis_mode:standalone
os:FreeBSD 14.1-RELEASE amd64
arch_bits:64
monotonic_clock:POSIX clock_gettime
multiplexing_api:kqueue
atomicvar_api:c11-builtin
gcc_version:4.2.1
process_id:885
process_supervised:no
run_id:085d05345fc8f1637d96faa5a5b673174fe5359d
tcp_port:6379
server_time_usec:1724391156106080
uptime_in_seconds:447
uptime_in_days:0
hz:10
configured_hz:10
lru_clock:13115124
executable:/usr/local/bin/redis-server
config_file:/usr/local/etc/redis.conf
io_threads_active:0

# Clients
connected_clients:1
cluster_connections:0
maxclients:10000
client_recent_max_input_buffer:20480
client_recent_max_output_buffer:0
.....
.....

# show connected clients now
127.0.0.1:6379> client list 
id=3 addr=10.0.0.51:57774 laddr=10.0.0.30:6379 fd=8 name= age=17 idle=17 flags=N db=0 sub=0 psub=0 ssub=0 multi=-1 qbuf=0 qbuf-free=0 argv-mem=0 multi-mem=0 rbs=1024 rbp=0 obl=0 oll=0 omem=0 tot-mem=1800 events=r cmd=command user=default redir=-1 resp=2
id=4 addr=127.0.0.1:35764 laddr=127.0.0.1:6379 fd=9 name= age=11 idle=0 flags=N db=0 sub=0 psub=0 ssub=0 multi=-1 qbuf=26 qbuf-free=20448 argv-mem=10 multi-mem=0 rbs=1024 rbp=0 obl=0 oll=0 omem=0 tot-mem=22298 events=r cmd=client|list user=default redir=-1 resp=2

# kill connection of a client
127.0.0.1:6379> client kill 10.0.0.51:57774 
OK

# dump all requests after the command below
127.0.0.1:6379> monitor 
OK
1718064847.746066 [0 10.0.0.51:46744] "auth" "(redacted)"
1718064862.052344 [0 10.0.0.51:46744] "set" "key01" "value01"
.....
.....

# save data on disk on foreground
127.0.0.1:6379> save 
OK

# save data on disk on background
127.0.0.1:6379> bgsave 
Background saving started

# get UNIX time stamp of the last save to disk
127.0.0.1:6379> lastsave 
(integer) 1718064934