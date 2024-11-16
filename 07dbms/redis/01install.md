Redis 7 : Install
 	
Install Redis which is the In-memory Data structure store Software.

[1]	Install Redis.
```sh
root@belajarfreebsd:~# pkg install -y redis70
```
[2]	Configure basic settings for Redis.
```sh
root@belajarfreebsd:~# vi /usr/local/etc/redis.conf
# line 87 : listening interface
# localhost only by default
# if you'd like to connect from other Hosts,
# change to the own IP address or set to [0.0.0.0]
bind 127.0.0.1 ::1
# line 138 : listening port
port 6379
# line 309 : daemonize setting
# if you use Redis as service daemon, turn to [yes]
daemonize yes
# line 379 : number of Databases
# database ID is assigned from 0 to (setting value - 1)
databases 16
# line 433 : save caching Database on Disk
# the default settings below means like follows
# after 3600 seconds (an hour) if at least 1 change was performed
# after 300 seconds (5 minutes) if at least 100 changes were performed
# after 60 seconds if at least 10000 changes were performed
# if you like to disable this function, comment out the line and set to [save ""]
# save 3600 1 300 100 60 10000
# line 1037 : authentication password
requirepass password
# line 1379 : alternative persistence mode ("yes" means enabled)
# if enabled, Redis loses high performance but get more safety
appendonly no
# line 1438 : if enabled [appendonly yes] when writing data on Disk
# [no] means do not fsync by Redis (just let the OS flush the data)
# appendfsync always
appendfsync everysec
# appendfsync no
root@belajarfreebsd:~# service redis enable
redis enabled in /etc/rc.conf
root@belajarfreebsd:~# service redis start
Starting redis.