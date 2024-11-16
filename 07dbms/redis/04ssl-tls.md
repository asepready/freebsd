Redis 7 : SSL/TLS Setting2024/08/23
 	
Configure SSL/TLS Setting on Redis.

[1]	Create self-signed certificate. If you use valid certificate like Let's Encrypt or others, skip this section.
```sh
root@belajarfreebsd:~# cd /usr/local/etc
root@belajarfreebsd:/usr/local/etc# openssl req -x509 -nodes -newkey rsa:2048 -keyout redis.pem -out redis.pem -days 3650
Generating a RSA private key
.................+++++
........+++++
writing new private key to 'vsftpd.pem'
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:ID                            # country code
State or Province Name (full name) [Some-State]:BangkaBelitung  # State
Locality Name (eg, city) []:Pangkalpinang                       # city
Organization Name (eg, company) [Internet Widgits Pty Ltd]:EDU  # company
Organizational Unit Name (eg, section) []:Belajar FreeBSD          # department
Common Name (e.g. server FQDN or YOUR name) []:ns.belajarfreebsd.or.id    # server's FQDN
Email Address []:root@belajarfreebsd.or.id                                 # admin's email

root@belajarfreebsd:/usr/local/etc# chmod 600 redis.pem
root@belajarfreebsd:/usr/local/etc# chown redis:redis redis.pem
```
[2]	Configure Redis.
```sh
root@belajarfreebsd:~# vi /usr/local/etc/redis.conf
# line 138 : change : disable it with [0]
port 0
# line 195: uncomment
tls-port 6379
# line 201,202 : uncomment and specify certificate
tls-cert-file /usr/local/etc/redis.pem
tls-key-file /usr/local/etc/redis.pem
# line 246 : uncomment
tls-auth-clients no
root@belajarfreebsd:~# service redis restart
```
[3]	Connect to Redis with SSL/TLS from clients. If connect from other Hosts, it needs to transfer certificate to them.
```sh
root@node01:~# ll /usr/local/etc/redis.pem
-rw-------  1 root wheel uarch 3164 Aug 23 14:51 /usr/local/etc/redis.pem

# specify [tls] option and certificate
root@node01:~# redis-cli -h ns.belajarfreebsd.or.id --tls \
--cert /usr/local/etc/redis.pem \
--key /usr/local/etc/redis.pem \
--cacert /usr/local/etc/redis.pem

ns.belajarfreebsd.or.id:6379> auth password 
OK
ns.belajarfreebsd.or.id:6379> info
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
process_id:994
process_supervised:no
run_id:7b3e1b07f0db8a38f417e7537f328f6322710c8d
tcp_port:6379
server_time_usec:1724392480769227
uptime_in_seconds:49
uptime_in_days:0
hz:10
configured_hz:10
lru_clock:13116448
executable:/usr/local/bin/redis-server
config_file:/usr/local/etc/redis.conf
io_threads_active:0
.....
.....
```