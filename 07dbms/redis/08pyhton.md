Redis 7 : Use on Python2024/08/23
 	
This is an example to use Redis on Python 3.

[1]	Install Python 3 Redis Client Library.
```sh
root@belajarfreebsd:~# pkg install -y py311-redis
```
[2]	Basic usage on Python.
```sh
sysadmin@belajarfreebsd:~$ vi use_redis.py
import redis

client = redis.StrictRedis(host='127.0.0.1', port=6379, db=0, password='password')

# set and get Key
client.set('key01', 'value01')
print('key01.value :', client.get('key01'))

# append and get Key
client.append('key01', ',value02')
print('key01.value :', client.get('key01'))

client.set('key02', 1)

# increment
client.incr('key02', 100)
print('key02.value :', client.get('key02'))

# decrement
client.decr("key02", 51)
print('key02.value :', client.get('key02'))

# list
client.lpush('list01', 'value01', 'value02', 'value03')
print('list01.value :', client.lrange('list01', '0', '2'))

# hash
client.hset('hash01', 'key01', 'value01')
client.hset('hash01', 'key02', 'value02')
client.hset('hash01', 'key03', 'value03')
print('hash01.value :', client.hget('hash01', 'key01'), client.hget('hash01', 'key02'), client.hget('hash01', 'key03'))

# set
client.sadd('set01', 'member01', 'member02', 'member03')
print('set01.value :', client.smembers('set01'))

# run
sysadmin@belajarfreebsd:~$ python3.11 use_redis.py
key01.value : b'value01'
key01.value : b'value01,value02'
key02.value : b'101'
key02.value : b'50'
list01.value : [b'value03', b'value02', b'value01']
hash01.value : b'value01' b'value02' b'value03'
set01.value : {b'member02', b'member01', b'member03'}
```