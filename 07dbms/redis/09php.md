Redis 7 : Use on PHP
 	
This is an example to use Redis on PHP.

[1]	Install PHP Redis Client Module.
```sh
root@belajarfreebsd:~# pkg install -y php83-pecl-redis
```
[2]	Basic usage on PHP.
```sh
sysadmin@belajarfreebsd:~$ vi use_redis.php
<?php
$redis = new Redis();
$redis->connect("127.0.0.1",6379);
$redis->auth("password");

// set and get Key
$redis->set('key01', 'value01');
print 'key01.value : ' . $redis->get('key01') . "\n";

// append and get Key
$redis->append('key01', ',value02');
print 'key01.value : ' . $redis->get('key01') . "\n";

$redis->set('key02', 1);
print 'key02.value : ' . $redis->get('key02') . "\n";

// increment
$redis->incr('key02', 100);
print 'key02.value : ' . $redis->get('key02') . "\n";

// decrement
$redis->decr('key02', 51);
print 'key02.value : ' . $redis->get('key02') . "\n";

// list
$redis->lPush('list01', 'value01');
$redis->rPush('list01', 'value02');
print 'list01.value : ';
print_r ($redis->lRange('list01', 0, -1));

// hash
$redis->hSet('hash01', 'key01', 'value01');
$redis->hSet('hash01', 'key02', 'value02');
print 'hash01.value : ';
print_r ($redis->hGetAll('hash01'));

// set
$redis->sAdd('set01', 'member01');
$redis->sAdd('set01', 'member02');
print 'set01.value : ';
print_r ($redis->sMembers('set01'));
?>

# run
sysadmin@belajarfreebsd:~ $ php use_redis.php
key01.value : value01
key01.value : value01,value02
key02.value : 1
key02.value : 101
key02.value : 50
list01.value : Array
(
    [0] => value01
    [1] => value02
)
hash01.value : Array
(
    [key01] => value01
    [key02] => value02
)
set01.value : Array
(
    [0] => member01
    [1] => member02
)
