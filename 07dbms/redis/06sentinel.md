Redis 7 : Configure Redis Sentinel
 	
Configure Redis Sentinel to provide high availability for Redis Servers.

This example is based on the environment like follows. If Primary Node would be down, Master role will failover to other Replica Node.
```sh
                                       |
+---------------------------+          |          +---------------------------+
|     [ Redis Sentinel ]    |10.0.0.25 | 10.0.0.30|    [ Redis Primary ]      |
|    ctrl.belajarfreebsd    +----------+----------+    ns.belajarfreebsd      |
|                           |          |          |                           |
+---------------------------+          |          +---------------------------+
                                       |
+---------------------------+          |          +---------------------------+
|   [ Redis Replica#1 ]     |10.0.0.51 | 10.0.0.52|     [ Redis Replica#2 ]   |
|   node01.belajarfreebsd   +----------+----------+    node02.belajarfreebsd  |
|                           |                     |                           |
+---------------------------+                     +---------------------------+
```
[1]	Configure replication Settings on all Primary and Replica Nodes, refer to here.
Points to be aware of regarding replication settings, it needs to set the same authentication password on all Nodes.

[2]	Configure Sentinel Server.
```sh
root@ctrl:~ # pkg install -y redis70
root@ctrl:~ # vi /usr/local/etc/sentinel.conf
# line 15 : change (start service)
daemonize yes
# line 73 : change
# [sentinel monitor (any name) (Primary's IP) (Primary's Port) (Quorum)]
# Quorum ⇒ run failover when the specified number of Sentinel servers look Primary is down
sentinel monitor mymaster 10.0.0.30 6379 1
# line 93 : authentication password for Primary Node
sentinel auth-pass mymaster password
# line 106 : the duration Sentinel server looks Primary is down (30 sec by default)
# to change the parameter, uncomment the line and set your value
# sentinel down-after-milliseconds <master-name> <milliseconds>
# line 189 : number of Replicas to be changed when running failover
sentinel parallel-syncs mymaster 1
root@ctrl:~ # service sentinel enable
sentinel enabled in /etc/rc.conf
root@ctrl:~ # service sentinel start
Starting sentinel.
```
[3]	That's OK, verify status on Sentinel server like follows.
Furthermore, stop Redis manually on Primary Node and make sure Primary/Replica failover normally.
```sh
root@ctrl:~ # redis-cli -p 26379
# show Primary Node for [mymaster]
127.0.0.1:26379> sentinel get-master-addr-by-name mymaster 
1) "10.0.0.30"
2) "6379"

# show details of Primary Node for [mymaster]
127.0.0.1:26379> sentinel master mymaster 
 1) "name"
 2) "mymaster"
 3) "ip"
 4) "10.0.0.30"
 5) "port"
 6) "6379"
 7) "runid"
 8) "b6d6812cc9f6b5a8c758bbd7a7abf383275fdf8e"
 9) "flags"
10) "master"
.....
.....

# show Replica Nodes for [mymaster]
127.0.0.1:26379> sentinel replicas mymaster 
1)  1) "name"
    2) "10.0.0.52:6379"
    3) "ip"
    4) "10.0.0.52"
    5) "port"
    6) "6379"
    7) "runid"
    8) "c436362cf8dda92ce9a3eb8dde18dd751d399a0f"
    9) "flags"
   10) "slave"
.....
.....
2)  1) "name"
    2) "10.0.0.51:6379"
    3) "ip"
    4) "10.0.0.51"
    5) "port"
    6) "6379"
    7) "runid"
    8) "10a9949eb5a02f7c8c9de1bd848d7b2bd43dd407"
    9) "flags"
   10) "slave"
.....
.....
```