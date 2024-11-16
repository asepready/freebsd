Redis 7 : Basic Operation for Database

This is the Basic Usage of Redis with [redis-cli] client program.

Following examples are basic one, you can see more commands on Official Site below. ⇒ https://redis.io/commands

[1]	This is the basic Usage of Keys.
```sh
root@belajarfreebsd:~# redis-cli
127.0.0.1:6379> auth password 
OK

# set Value of a Key
127.0.0.1:6379> set key01 value01 
OK

# get Value of a Key
127.0.0.1:6379> get key01 
"value01"

# delete a Key
127.0.0.1:6379> del key01 
(integer) 1

# determine if a Key exists or not (1 means true)
127.0.0.1:6379> exists key01 
(integer) 0

# set Value of a Key only when the Key does not exist yet
# integer 0 means Value is not set because the Key already exists
127.0.0.1:6379> setnx key01 value02 
(integer) 1

# set Value of a Key with expiration date (60 means Value will expire after 60 second)
127.0.0.1:6379> setex key01 60 value01 
OK

# set expiration date to existing Key
127.0.0.1:6379> expire key01 30 
(integer) 1

# add Values to a Key
127.0.0.1:6379> append key01 value02 
(integer) 15

# get substring of Value of a Key : [Key] [Start] [End]
127.0.0.1:6379> substr key01 0 3 
"valu"

127.0.0.1:6379> set key02 1 
OK

# increment integer Value of a Key
127.0.0.1:6379> incr key02 
(integer) 2

# increment integer Value of a Key by specified value
127.0.0.1:6379> incrby key02 100 
(integer) 102

# decrement integer Value of a Key
127.0.0.1:6379> decr key02 
(integer) 101

# decrement integer Value of a Key by specified value
127.0.0.1:6379> decrby key02 51 
(integer) 50

# set values of some Keys
127.0.0.1:6379> mset key01 value01 key02 value02 key03 value03 
OK

# get some Values of Keys
127.0.0.1:6379> mget key01 key02 key03 
1) "value01"
2) "value02"
3) "value03"

# rename existing Key
127.0.0.1:6379> rename key03 key04 
OK
127.0.0.1:6379> mget key01 key02 key03 key04 
1) "value01"
2) "value02"
3) (nil)
4) "value03"

# rename existing Key but if renamed Key already exists, command is not run
127.0.0.1:6379> renamenx key01 key02 
(integer) 0
127.0.0.1:6379> mget key01 key02 key03 key04 
1) "value01"
2) "value02"
3) (nil)
4) "value03"

# get number of Keys on current Database
127.0.0.1:6379> dbsize 
(integer) 3

# move a key to another Database
127.0.0.1:6379> move key04 1 
(integer) 1
127.0.0.1:6379> select 1 
OK
127.0.0.1:6379[1]> get key04 
"value03"

# delete all Keys on current Database
127.0.0.1:6379> flushdb 
OK

# delete all Keys on all Database
127.0.0.1:6379> flushall 
OK
127.0.0.1:6379> quit 

# process with reading data from stdout
root@belajarfreebsd:~# echo 'test_words' | redis-cli -a password --no-auth-warning -x set key01 
OK
root@belajarfreebsd:~# redis-cli -a password --no-auth-warning get key01 
"test_words\n"
```
[2]	It's possible to use CAS operation (Check And Set) with watch command on Redis. If another process changed value of the Key between multi - exec, change is not applied to the Key.
```sh
# watch a key
127.0.0.1:6379> watch key01 
OK
127.0.0.1:6379> get key01 
"test_words\n"
127.0.0.1:6379> multi 
OK
127.0.0.1:6379(TX)> set key01 value02 
QUEUED
127.0.0.1:6379(TX)> exec 
1) OK